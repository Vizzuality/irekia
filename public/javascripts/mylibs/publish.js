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
  spin_element = document.getElementById('publish_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  submitting = false,
  store = "publish-popover",
  // Public methods
  methods = { },
  interval,
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    sectionWidth: 687,
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
        data.proposalStep = 0;
        data.questionStep = 0;
        data.sectionID = 0;
        data.spinner = spinner;
      }

      // Update the reference to $ps
      $ps = $('#' + store);

      $(this).click(_toggle);

      $(window).unbind();
      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the userPublishPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      data.$submit = $ps.find("footer .publish");

      // bindings
      _addCloseAction(data);
      _addDefaultAction(data);
      _bindMenu(data);
      _bindSubmit(data);
      _bindActions(data);
      _enableInputCounter(data);
      _bindSearch(data);

      if ($(this).hasClass("publish_proposal")) data.sectionID = 1;

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

    data.questionStep = 0;
    data.proposalStep = 0;

    // Initialize the initial section
    $currentSection    = $ps.find(".container .section:nth-child(1)");
    $currentMenuOption = $ps.find(".menu").find("li:nth-child(" + (data.sectionID + 1) + ")");
    $currentSection    = $ps.find(".container .section:nth-child(" + (data.sectionID + 1) + ")");

    _gotoSection(data);

    _selectOption(data, $currentMenuOption);
    _resizeSection($ps, $currentSection);

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
    $submit.removeClass("disabled");
  }

  function _disableSubmit($submit) {
    submitting = true;
    $submit.addClass("disabled");
  }

  function _selectOption(data, $option) {
    var $ps = data.$ps;
    var $menu = $ps.find(".menu");
    $menu.find("li.selected").removeClass("selected");
    $option.addClass("selected");
  }

  function _bindActions(data) {
    var $ps = data.$ps;

    _setupUpload(data,"upload_image");

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
    height = $section.find(".form").outerHeight(true);
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


  function _bindSearch(data) {
    var $ps = data.$ps;

     $ps.find('.extra input').keyup(function(ev){

       if (_.any([8, 13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return ev.keyCode == i} )) { return; }

       clearTimeout(interval);

       var $related = $ps.find("div.related");
       var $relatedTitle = $ps.find("h3.related");

       if ($(this).val().length > 5) {
         interval = setTimeout(function(){

           var query = $ps.find('.extra input[type="text"]').val();

           $.ajax({ url: "/search/politicians_and_areas", data: { search: { name : query } }, type: "GET", success: function(data){
             console.log(data);
           }});

         }, 500);
       } else {
         // $related.fadeOut(350);
         // $relatedTitle.fadeOut(350);
       }
     });
  }

  function _doProposal(data) {
    var $ps = data.$ps;
    if (data.proposalStep == 0) {
      data.proposalStep++;

      _showExtraFields();
      _resizeSection($ps, $currentSection);
      _disableSubmit(data.$submit);
      _changeSubmitTitle(data.$submit, "Publicar");

    } else {
      _showMessage($ps, "success", function() {
        data.proposalStep = 0;
        _resetSection($currentSection);
      });
    }
  }

  function _doQuestion(data) {
    var $ps = data.$ps;

    if (data.questionStep == 0) {
      data.questionStep++;

      _showExtraFields();
      _resizeSection($ps, $currentSection);
      _disableSubmit(data.$submit);
      _changeSubmitTitle(data.$submit, "Publicar");

    } else {
      var $form = $currentSection.find("form");
      $form.submit();
      data.spinner.spin(spin_element);

      $form.unbind();
      $form.bind('ajax:success', function(event, xhr, status) { _successQuestion(data, $form, xhr); })
    }
  }

  function _successQuestion(data, $form, xhr) {
    var $ps = data.$ps;
    var $response = $(xhr);

    data.spinner.stop();
    $response.hide();
    $form.after($response);
    data.$ps.find(".extra").hide();
    data.$ps.find(".holder").show();
    data.$ps.find(":text, textarea").val("");
    _showMessage($ps, "success");
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

    data.$submit.unbind();
    data.$submit.click(function(e) {
      e && e.preventDefault();

      if (!_hasContent($currentSection)) return;

      _disableSubmit(data.$submit);

      if (_question()) _doQuestion(data);
      else if (_proposal()) _doProposal(data);
    });
  }

  function _setupUpload(data,id) {

    var $ps = data.$ps;
    if ($ps.find("#" + id).length > 0) {

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: '',
        debug: true,
        text:"sube una nueva",
        onSubmit: function(id, fileName){
          $currentSection.find(".holder").fadeOut(speed);
        },
        onProgress: function(id, fileName, loaded, total){},
        onComplete: function(id, fileName, responseJSON){},
        onCancel: function(id, fileName){ }
      });
    }
  }

  function _gotoSection(data) {
    var $ps = data.$ps;

    var $section  = $ps.find(".container .section:nth-child(" + (data.sectionID + 1) + ")");
    var height    = $section.find(".form").outerHeight(true) + 20;
    $ps.find(".container").animate({scrollLeft: data.sectionID * data.settings.sectionWidth, height: height }, data.settings.transitionSpeed, "easeInOutQuad");
  }

  function _bindMenu(data) {
    var $ps = data.$ps;

    $ps.find("ul.menu li a").unbind();
    $ps.find("ul.menu li a").click(function(e) {
      e && e.preventDefault();

      data.questionStep = 0;
      data.proposalStep = 0;

      _hideExtraFields();

      data.sectionID = $(this).parent().index();
      $section       = $(this).parents(".content").find(".container .section:nth-child(" + (data.sectionID + 1) + ")");

      if (_sectionName($section) != _sectionName($currentSection)) {
        _resetSection($section);
      }

      _selectOption(data, $(this).parent());

      if ($currentSection) {

        _resizeSection($ps, $currentSection, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;

          _gotoSection(data);
          _changeSubmitTitle(data.$submit, "Continuar");
        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $ps.find(".container").animate({scrollTop: 0, scrollLeft: data.sectionID * data.settings.sectionWidth, height: height }, speed, "easeInOutQuad");
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
    _disableSubmit($ps);
  }

  // Close popover
  function _close(data, hideLockScreen, callback) {

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).css("top", "-900px");
      _clearInfo(data.$ps);

      data.questionStep = 0;
      data.proposalStep = 0;

      data.$ps.find(".extra").hide();
      data.$ps.find(".holder").show();
      _resizeSection(data.$ps, $currentSection);

      hideLockScreen && LockScreen.hide();
      callback && callback();
    }});
  }

  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
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
