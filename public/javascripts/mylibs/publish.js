(function($, window, document) {

  var ie6 = false;

  // Help prevent flashes of unstyled content
  if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
    ie6 = true;
  } else {
    document.documentElement.className = document.documentElement.className + ' ps_fouc';
  }


 var
 sectionID     = 0,
 speed         = 150,
 sectionWidth  = 687,
 $article      = $(this),
 currentHeight = 0,
 $currentSection,
 $currentMenuOption,
 $menu,
 questionStep = 0,
 proposalStep = 0,
 spin_element = document.getElementById('publish_spinner'),
 submitting = false;

  var spin_element = document.getElementById('user_publish_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  store = "publish-popover",
  // Public methods
  methods = { },
  interval,
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    transitionSpeed: 200,
    maxLimit: 140
  };

  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var
      // The current <select> element
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},

      // This gets applied to the 'ps_container' element
      id = $this.attr('id') || $this.attr('name'),

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup userPublishPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
      }

      // Update the reference to $ps
      $ps = $('#' + store);

      $(this).click(_toggle);

      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the userPublishPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

    });
  };

  // Expose the plugin
  $.fn.userPublishPopover = function(method) {
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
    }
  };

  // Toggle popover
  function _toggle(e) {
    if (e) {
      e.preventDefault();
      e.stopPropagation();
    }

    var data  = $(this).data(store);
    var $ps   = $('#' + data.id);

    LockScreen.show(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _open(data) {
    var $ps = data.$ps;

    data.$submit = $ps.find("footer .publish");

    // bindings
    _addCloseAction(data);
    _addDefaultAction(data);
    _bindMenu(data);
    _bindSubmit(data);
    //_addSubmitAction(data);

    // Initialize the initial section
    $currentSection    = $ps.find(".container .section:nth-child(1)");
    $menu              = $ps.find(".menu");
    $currentMenuOption = $menu.find("li.selected");

   _bindActions($ps);
   _enableInputCounter(data);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
    $ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }


   function _enableInputCounter(data) {
     var $ps = data.$ps;

     $ps.find(":text, textarea").keyup(function(e) {
       textCounter($(this), data.$submit);
     });

     $ps.find(":text, textarea").keydown(function(e) {
       textCounter($(this), data.$submit);
     });
   }

   function textCounter($input, $submit) {
     var count = $input.val().length;
     (count <= 0) ? _disableSubmit($submit) : _enableSubmit($submit);
   }


  function _resetSection($section) {
    $section.find(":text, textarea").val("");
    $section.find(".holder").fadeIn(speed);
  }

  function _hasContent($section) {
    return !isEmpty($section.find(":text, textarea").val());
  }

  function _enableSubmit($submit) {
    submitting = false;
    $submit.removeAttr('disabled');
    $submit.removeClass("disabled");
  }

  function _disableSubmit($submit) {
    submitting = true;
    $submit.attr("disable", "disable");
    $submit.addClass("disabled");
  }

  function _selectOption($option) {
    $menu.find("li.selected").removeClass("selected");
    $option.parent().addClass("selected");
  }



  function _bindActions($ps) {

    //_setupUpload("upload_proposal");
    //_setupUpload("upload_image");

    $ps.find(".section .open_upload").click(function(e) {
      e && e.preventDefault();
      $(this).closest("input[type='file']").click();
    });

    $ps.find(".section.video li").click(function(e) {
      e && e.preventDefault();

      $(this).siblings("li").removeClass("selected");
      $(this).addClass("selected");
      $ps.find(".radio.selected").removeClass("selected");
      $(this).find(".radio").addClass("selected");
    });

    $ps.find("a.radio").click(function(e) {
      e && e.preventDefault();
      $ps.find(".section.video li").toggleClass("selected");
    });
  }

   function _resizeSection($ps, $section, callback) {
     height = $section.find(".form").outerHeight(true) + 20;
     $ps.find(".container").animate({ scrollTop: 0, height: height }, speed, function() {
       callback && callback();
     });
   }

  function _hideExtraFields() {
    $currentSection.find(".extra").fadeOut(speed);
  }

  function _showExtraFields() {
    $currentSection.find(".extra").fadeIn(speed);
  }

  function _doProposal(data) {
    var $ps = data.$ps;
    if (proposalStep == 0) {
      proposalStep++;

      _showExtraFields();
      _resizeSection($ps, $currentSection);
      _disableSubmit(data.$submit);
      _changeSubmitTitle(data.$submit, "Publicar");

    } else {
      _showMessage($ps, "success", function() {
        proposalStep = 0;
        _resetSection($currentSection);
      });
    }
  }

  function _doQuestion(data) {
    var $ps = data.$ps;

    if (questionStep == 0) {
      questionStep++;

      _showExtraFields();
      _resizeSection($ps, $currentSection);
      _disableSubmit(data.$submit);
      _changeSubmitTitle(data.$submit, "Publicar");

    } else {
      _showMessage($ps, "success", function() {
        questionStep = 0;
        _resetSection($currentSection);
      });
    }
  }

  function _proposal() {
    return $currentSection.hasClass("proposal");
  }

  function _question() {
    return $currentSection.hasClass("question");
  }

  function _changeSubmitTitle($submit, title) {
    $submit.find("span").text(title);
  }

  function _sectionName($section) {
    return $section.attr("class").replace(/section/g, "").fulltrim();
  }

  function _bindSubmit(data) {
    var $ps = data.$ps;

     data.$submit.click(function(e) {
       e && e.preventDefault();

       if (!_hasContent($currentSection)) return;

       _disableSubmit(data.$submit);

       if (_question()) _doQuestion(data);
       else if (_proposal()) _doProposal(data);
     });

  }

  function _bindMenu(data) {
    var $ps = data.$ps;

    $ps.find("ul.menu li a").click(function(e) {

      //if (submitting) return;

      e && e.preventDefault();
      _hideExtraFields();

      sectionID = $(this).parent().index();
      $section  = $(this).parents(".content").find(".container .section:nth-child(" + (sectionID + 1) + ")");


      if (_sectionName($section) != _sectionName($currentSection)) {
        _resetSection($section);
      }

      _selectOption($(this));

      if ($currentSection) {

        _resizeSection($ps, $currentSection, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;
          var height = $section.find(".form").outerHeight(true) + 20;
          $ps.find(".container").animate({scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
          _changeSubmitTitle(data.$submit, "Continuar");
        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $ps.find(".container").animate({scrollTop: 0, scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
      }

    });
  }

   function _showMessage($ps, kind, callback) {
     IrekiaSpinner.spin(spin_element);

     var currentHeight = $currentSection.find(".form").outerHeight(true);
     var $success      = $currentSection.find(".message.success");
     var $error        = $currentSection.find(".message.error");

     if (kind == "success") {
       $error.hide();
       $success.show();
     } else {
       $error.show();
       $success.hide();
     }

     var successHeight = $success.outerHeight(true);

     $ps.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, speed * 2, "easeInOutQuad", function() {
       IrekiaSpinner.stop();
       callback && callback();
     });
   }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    $ps.css({"top":(top + 100) + "px", "left": left + "px"});

    $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  function _clearInfo($ps) {
    $ps.find("textarea").val("");
    $ps.find(".counter").html(140);
    disableSending($ps);
  }

  function enableSending($ps) {
    if ($ps) {
      $ps.find("input[type='submit']").removeAttr("disabled");
      $ps.find("input[type='submit']").removeClass("disabled");
    }
  }

  function disableSending($ps) {
    if ($ps) {
      $ps.find("form input[type='submit']").attr("disabled", "true");
      $ps.find("form input[type='submit']").addClass("disabled");
    }
  }

  function _close2(data, hideLockScreen, callback) {

    data.$ps.animate({opacity:.5, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).remove();
      _clearInfo(data.$ps);
      hideLockScreen && LockScreen.hide();
      callback && callback();
    }});
  }
  // Close popover
  function _close(data, hideLockScreen, callback) {

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).css("top", "-900px");
      _clearInfo(data.$ps);
      hideLockScreen && LockScreen.hide();
      callback && callback();
    }});
  }

  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
  }

  function _addSubmitAction(data) {
    data.$ps.find("form").die();

    data.$ps.find("form").submit(function(e) {
      spinner.spin(spin_element);
      disableSending(data.$ps);
    });

    data.$ps.find("form").live('ajax:success', function(event, xhr, status) {
      spinner.stop();
      enableSending(data.$ps);
      _close(data, false, function() {
        _gotoSuccess(data);
      });
    });

    data.$ps.find("form").live('ajax:error', function(event, xhr, status) {
      spinner.stop();
      enableSending(data.$ps);
    });

  }

  function _addCloseAction2(data) {
    data.$ps.find(".close").unbind("click");
    data.$ps.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close2(data, true);
    });
  }

  function _addCloseAction(data) {
    data.$ps.find(".close").unbind("click");
    data.$ps.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data, true);
    });
  }

  function _addDefaultAction(data){
    data.$ps.unbind("click");
    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  $(function() { });

})(jQuery, window, document);






// jQuery.fn.enableUserPublish = function(opt){
//
//   if (this.length < 1) return;
//
//   var
//   sectionID     = 0,
//   speed         = 150,
//   sectionWidth  = 687,
//   $article      = $(this),
//   currentHeight = 0,
//   $currentSection,
//   $currentMenuOption,
//   $menu,
//   questionStep = 0,
//   proposalStep = 0,
//   $submit = $article.find("footer .publish"),
//   spin_element = document.getElementById('publish_spinner'),
//   submitting = false;
//
//   // Initialize the initial section
//   $currentSection    = $article.find(".container .section:nth-child(1)");
//   $menu              = $article.find(".menu");
//   $currentMenuOption = $menu.find("li.selected");
//
//   function textCounter($input, $submit) {
//     var count = $input.val().length;
//     (count <= 0) ? _disableSubmit($submit) : _enableSubmit($submit);
//   }
//
//   function _setupUpload(id) {
//
//     if ($article.find("#" + id).length > 0) {
//
//       var uploader = new qq.FileUploader({
//         element: document.getElementById(id),
//         action: '',
//         debug: true,
//         text:"sube una nueva",
//         onSubmit: function(id, fileName){
//           $currentSection.find(".holder").fadeOut(speed);
//         },
//         onProgress: function(id, fileName, loaded, total){},
//         onComplete: function(id, fileName, responseJSON){},
//         onCancel: function(id, fileName){ }
//       });
//     }
//   }
//
//   function _enableInputCounter() {
//     $article.find(":text, textarea").keyup(function(e) {
//       textCounter($(this), $submit);
//     });
//
//     $article.find(":text, textarea").keydown(function(e) {
//       textCounter($(this), $submit);
//     });
//   }
//
//   function _bindActions() {
//
//     _setupUpload("upload_proposal");
//     _setupUpload("upload_image");
//
//     $article.find(".section .open_upload").click(function(e) {
//       e && e.preventDefault();
//       $(this).closest("input[type='file']").click();
//     });
//
//     $article.find(".section.video li").click(function(e) {
//       e && e.preventDefault();
//
//       $(this).siblings("li").removeClass("selected");
//       $(this).addClass("selected");
//       $article.find(".radio.selected").removeClass("selected");
//       $(this).find(".radio").addClass("selected");
//     });
//
//     $article.find("a.radio").click(function(e) {
//       e && e.preventDefault();
//       $article.find(".section.video li").toggleClass("selected");
//     });
//   }
//
//   function _showMessage(kind, callback) {
//     IrekiaSpinner.spin(spin_element);
//
//     var currentHeight = $currentSection.find(".form").outerHeight(true);
//     var $success      = $currentSection.find(".message.success");
//     var $error        = $currentSection.find(".message.error");
//
//     if (kind == "success") {
//       $error.hide();
//       $success.show();
//     } else {
//       $error.show();
//       $success.hide();
//     }
//
//     var successHeight = $success.outerHeight(true);
//
//     $article.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, speed * 2, "easeInOutQuad", function() {
//       IrekiaSpinner.stop();
//       callback && callback();
//     });
//   }
//
//   function _resetSection($section) {
//     $section.find(":text, textarea").val("");
//     $section.find(".holder").fadeIn(speed);
//   }
//
//   function _hasContent($section) {
//     return !isEmpty($section.find(":text, textarea").val());
//   }
//
//   function _enableSubmit() {
//     submitting = false;
//     $submit.removeAttr('disabled');
//     $submit.removeClass("disabled");
//   }
//
//   function _disableSubmit() {
//     submitting = true;
//     $submit.attr("disable", "disable");
//     $submit.addClass("disabled");
//   }
//
//   function _selectOption($option) {
//     $menu.find("li.selected").removeClass("selected");
//     $option.parent().addClass("selected");
//   }
//
//   function _resizeSection($section, callback) {
//     height = $section.find(".form").outerHeight(true) + 20;
//     $article.find(".container").animate({ scrollTop: 0, height: height }, speed, function() {
//       callback && callback();
//     });
//   }
//
//   function _hideExtraFields() {
//     $currentSection.find(".extra").fadeOut(speed);
//   }
//   function _showExtraFields() {
//     $currentSection.find(".extra").fadeIn(speed);
//   }
//
//   function _doProposal() {
//     if (proposalStep == 0) {
//       proposalStep++;
//
//       _showExtraFields();
//       _resizeSection($currentSection);
//       _disableSubmit();
//       _changeSubmitTitle("Publicar");
//
//     } else {
//       _showMessage("success", function() {
//         proposalStep = 0;
//         _resetSection($currentSection);
//       });
//     }
//   }
//
//   function _doQuestion() {
//     if (questionStep == 0) {
//       questionStep++;
//
//       _showExtraFields();
//       _resizeSection($currentSection);
//       _disableSubmit();
//       _changeSubmitTitle("Publicar");
//
//     } else {
//       _showMessage("success", function() {
//         questionStep = 0;
//         _resetSection($currentSection);
//       });
//     }
//   }
//
//   function _proposal() {
//     return $currentSection.hasClass("proposal");
//   }
//
//   function _question() {
//     return $currentSection.hasClass("question");
//   }
//
//   function _changeSubmitTitle(title) {
//     $submit.find("span").text(title);
//   }
//
//   function _sectionName($section) {
//     return $section.attr("class").replace(/section/g, "").fulltrim();
//   }
//
//   // Init
//   _bindActions();
//   _enableInputCounter();
//
//   this.each(function(){
//
//       _resizeSection($currentSection);
//     _disableSubmit();
//
//     $submit.click(function(e) {
//       e && e.preventDefault();
//
//       if (!_hasContent($currentSection)) return;
//
//       _disableSubmit();
//
//       if (_question()) _doQuestion();
//       else if (_proposal()) _doProposal();
//     });
//
//     $(this).find("ul.menu li a").click(function(e) {
//
//       //if (submitting) return;
//
//       e && e.preventDefault();
//       _hideExtraFields();
//
//
//       sectionID = $(this).parent().index();
//       $section  = $(this).parents(".content").find(".container .section:nth-child(" + (sectionID + 1) + ")");
//
//
//       if (_sectionName($section) != _sectionName($currentSection)) {
//         _resetSection($section);
//       }
//
//
//       _selectOption($(this));
//
//       if ($currentSection) {
//
//         _resizeSection($currentSection, function() {
//
//           var $success = $currentSection.find(".message.success").hide();
//           var $error   = $currentSection.find(".message.error").hide();
//
//           $currentSection = $section;
//           var height = $section.find(".form").outerHeight(true) + 20;
//           $article.find(".container").animate({scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
//           _changeSubmitTitle("Continuar");
//
//
//         });
//
//       } else {
//         $currentSection = $section;
//         var height = $section.find(".form").outerHeight(true) + 20;
//         $article.find(".container").animate({scrollTop: 0, scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
//       }
//
//     });
//   })
// }
//
