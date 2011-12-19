(function($, window, document) {

  var
  ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9),
  $popover,
  currentHeight = 0,
  $currentSection,
  $currentMenuOption,
  $menu,
  spin_element = document.getElementById('publish_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  store = "publish-popover",
  // Public methods
  methods = { },
  interval,
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    sectionWidth: 687,
    transitionSpeed: 200
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

      // Dont do anything if we've already setup politicianPublishPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
        data.sectionID = 0;
        data.spinner = spinner;
      }

      $popover = $(this);

      // Update the reference to $ps
      $ps = $('#' + store);

      $(this).click(_toggle);

      $(window).unbind();
      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the politicianPublishPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      data.$submit = $ps.find(".bfooter .publish");

      if ($(this).hasClass("publish_proposal")) data.sectionID = 1;

    });
  };

  // Expose the plugin
  $.fn.politicianPublishPopover = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
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

    // bindings
    _addCloseAction(data);
    _addDefaultAction(data);
    _bindMenu(data);
    _bindSubmit(data, "Publicar", true, "publish");
    _bindActions(data);
    _bindTextInputs(data);

    _bindSubmit(data, "Publicar", true, "publish");
    data.$ps.find("input,:text,textarea").attr("tabindex", "-1");

    // Initialize the initial section
    $currentSection    = $ps.find(".container .section:nth(0)");
    $currentMenuOption = $ps.find(".menu").find("li:eq(" + (data.sectionID) + ")");
    $currentSection    = $ps.find(".container .section:eq(" + (data.sectionID) + ")");

    _gotoSection(data);
    _bindSearch(data);

    _selectOption(data, $currentMenuOption);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation(data);
    $ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }

  function _enableInputCounter($input, on, off) {

    $input.keyup(function(e) {
      textCounter($(this), on, off);
    });

    $input.keydown(function(e) {
      textCounter($(this), on, off);
    });
  }

  function textCounter($input, on, off) {
    var count = $input.val().length;

    if (count <= 0) {
      off && off();
    } else {
      on && on();
    }
  }

  function _resetSection(data, $section) {
    $section.find(":text, textarea").val("");
    $section.find(".holder").fadeIn(data.settings.transitionSpeed);
  }

  function _hasContent($section) {
    if (_video()) {
      return $section.find("input").val();
    } else return !isEmpty($section.find(":text, textarea").val());
  }

  function _enableSubmit($submit) {
    $submit.removeClass("disabled");
    $submit.removeAttr("disabled");
  }

  function _disableSubmit($submit) {
    $submit.addClass("disabled");
    $submit.attr("disabled", "disabled");
  }

  function _selectOption(data, $option) {
    var
    $ps   = data.$ps,
    $menu = $ps.find(".menu");

    $menu.find("li.selected").removeClass("selected");
    $option.addClass("selected");
  }

  // Empties the image preview container
  function _resetImageContainer(e, data) {
    e.preventDefault();

    var $image_container = data.$ps.find(".image_container");

    $image_container.fadeOut(data.settings.transitionSpeed, function() {
      data.$ps.find(".uploader").fadeIn(data.transitionSpeed, function() {
        $image_container.find(".holder").fadeIn(data.transitionSpeed);
      });

      $image_container.find("img").fadeOut(data.transitionSpeed, function() { $(this).remove(); });

      data.$ps.find(".loading").hide();
      data.$ps.find(".percentage").hide();
      data.$ps.find(".progress").css("width", "0");

      _resizeSection(data, $currentSection, function() {
        _center(data);
      });
    });
  }

  function _bindTextInputs(data) {
    _enableInputCounter(data.$ps.find("#status_message_status_message_data_attributes_message"), function() { _enableSubmit(data.$submit)} , function() { _disableSubmit(data.$submit)});
    _enableInputCounter(data.$ps.find("#proposal_proposal_data_attributes_title"), function() { _enableSubmit(data.$submit)} , function() { _disableSubmit(data.$submit)});
    _enableInputCounter(data.$ps.find(".autosuggest_field input"), null, function() { _clearAutosuggest(data); _resetHiddenFields(); } );
    _enableInputCounter(data.$ps.find(".section.video .input_field.vimeo input"), function() { _enableSubmit(data.$submit); }, function() { _disableSubmit(data.$submit); } );
    _enableInputCounter(data.$ps.find(".section.video .input_field.youtube input"), function() { _enableSubmit(data.$submit); }, function() { _disableSubmit(data.$submit); } );
    _enableInputCounter(data.$ps.find(".section.photo .input_field input"), function() { _enableSubmit(data.$submit); }, function() { _disableSubmit(data.$submit); } );
  }

  function _bindActions(data) {
    var $ps = data.$ps;

    // Image uploader
    _setupUpload(data, "proposal", "upload_proposal_image");
    _setupUpload(data, "photo", "upload_photo", function() { _enableSubmit(data.$submit); });

    // Remove image link
    $ps.find(".image_container a.remove").unbind();
    $ps.find(".image_container a.remove").bind("click", function(e) { _resetImageContainer(e, data); } );

    $ps.find(".section .open_upload").click(function(e) {
      e && e.preventDefault();
      $(this).closest("input[type='file']").click();
    });

    // Video section binding
    $ps.find(".section.video li").click(_changeVideoSource);
    $ps.find("a.radio").click(_toggleVideoSourceClass);
  }

  function _changeVideoSource(e) {
    e && e.preventDefault();

    var data = $popover.data(store);

    $(this).siblings("li").removeClass("selected");
    $(this).addClass("selected");
    data.$ps.find(".radio.selected").removeClass("selected");
    $(this).find(".radio").addClass("selected");
  }

  function _toggleVideoSourceClass(e) {
    e && e.preventDefault();
    var data = $popover.data(store);
    data.$ps.find(".section.video li").toggleClass("selected");
  }

  function _resizeSection(data, $section, callback) {
    var $ps = data.$ps;
    height = $section.find(".form").outerHeight(true);
    $ps.find(".container").animate({ scrollTop: 0, height: height }, data.settings.transitionSpeed, function() {
      callback && callback();
    });
  }

  function _hideExtraFields(speed) {
    $currentSection.find(".extra").fadeOut(speed);
  }

  function _showExtraFields(speed) {
    $currentSection.find(".extra").fadeIn(speed);
  }

  function _clearSection(data) {
    data.$ps.find(":text, textarea").val("");
    data.$ps.find(".uploader").show();
    data.$ps.find(".holder").show();
    data.$ps.find(".loading").hide();
    data.$ps.find(".percentage").hide();
    data.$ps.find(".progress").css("width", "0");
    data.$ps.find(".image_container").hide();
    data.$ps.find(".image_container img").remove();
  }

  function _clearAutosuggest(data) {
    var $ps = data.$ps;

    $ps.find(".autosuggest").fadeOut(100, function() {
      $(this).remove();
    });
  }

  // Update target depending on the selected element
  function _updateHiddenTarget(targetClass, id) {
    var id = id.replace("item_", "");
    var otherTarget =  (targetClass == "user") ? "area" : "user";
    var name = _getCurrentSectionName();

    $currentSection.find('#' + name + '_' + name + '_data_attributes_' + targetClass + '_id').val(id)
    $currentSection.find('#' + name + '_' + name + '_data_attributes_' + otherTarget + '_id').val("");
  }

  function _bindSearch(data) {
    var $ps = data.$ps;


    $currentSection.find('.autosuggest_field input').keyup(function(ev){

      if (_.any([13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return ev.keyCode == i} )) { return; }

      clearTimeout(interval);

      if ($(this).val().length > 3) {
        interval = setTimeout(function(){

          var query = $currentSection.find('.extra .autosuggest_field input[type="text"]').val();

          data.spinner.spin(spin_element);

          var params = { name : query };

          if (_getCurrentSectionName() == "proposal") {
            params = $.extend(params, { only_areas : true } );
          }

          $.ajax({ url: "/search/politicians_and_areas", data: { search: params }, type: "GET", success: function(response) {

            var $response = $(response);

            data.spinner.stop();

            // When the user clicks on a result…
            $response.find("li").unbind();
            $response.find("li").bind("click", function(e) {
              var id = $(this).attr("id");

              var name = $(this).find(".name").html();

              $currentSection.find('.autosuggest_field input[type="text"]').val(name);
              $(this).hasClass("user") ? _updateHiddenTarget("user", id) : _updateHiddenTarget("area", id);

              _bindSubmit(data, "Publicar", true, "publish");
              _clearAutosuggest(data);
              _enableSubmit(data.$submit);
            });

            $currentSection.find(".autosuggest").fadeOut(150, function() {
              $(this).remove();
            });

            if ($response.find("li").length > 0) {
              $response.hide();
              $response.css("top", $currentSection.find(".autosuggest_field").position().top + 220);
              $ps.find('.content').append($response);
              $response.fadeIn(150);
            }
          }});

        }, 500);
      }
    });
  }

  function _doProposal(data) {
    var $ps = data.$ps;
    if (data.proposalStep == 0) {
      data.proposalStep++;

      _showExtraFields(data.settings.transitionSpeed);
      _resizeSection(data, $currentSection, function() {
        _center(data);
      });

      _disableSubmit(data.$submit);
      _changeSubmitTitle(data.$submit, "Publicar");
    } else {
      var $form = $currentSection.find("form");
      $form.submit();
      data.spinner.spin(spin_element);

      $form.unbind();
      $form.bind('ajax:success', function(event, xhr, status) { _successProposal(data, $form, xhr); })
    }
  }

  function _publishPhoto(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successMessage(data, $form, xhr); })
  }

  function _publishVideo(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successMessage(data, $form, xhr); })
  }

  function _publishMessage(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successMessage(data, $form, xhr); })
  }

  function _publishProposal(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successMessage(data, $form, xhr); })
  }

  function _successProposal(data, $form, xhr) {
    var $ps = data.$ps;
    var $response = $(xhr);

    data.spinner.stop();
    $response.hide();
    $currentSection.append($response);

    data.$ps.find(".extra").hide();
    data.$ps.find(".holder").show();
    data.$ps.find(":text, textarea").val("");

    _showMessage(data, "success");
  }

  function _successMessage(data, $form, xhr) {
    var $ps = data.$ps;
    var $response = $(xhr);

    data.spinner.stop();
    $response.hide();
    $form.after($response);
    data.$ps.find(".extra").hide();
    data.$ps.find(".holder").show();
    data.$ps.find(":text, textarea").val("");
    _showMessage(data, "success");
  }

  function _getCurrentSectionName() {
    if ($currentSection.hasClass("dashboard")) return "dashboard";
    if ($currentSection.hasClass("question"))  return "question";
    if ($currentSection.hasClass("proposal"))  return "proposal";
    if ($currentSection.hasClass("video"))     return "video";
    if ($currentSection.hasClass("photo"))     return "photo";
  }

  function _video() {
    return $currentSection.hasClass("video");
  }

  function _message() {
    return $currentSection.hasClass("dashboard");
  }

  function _changeSubmitTitle($submit, title) {
    $submit.find("span").text(title);
  }

  function _sectionName($section) {
    return $section.attr("class").replace(/section/g, "").fulltrim();
  }

  function _doCallback(name, data) {
    if (name == "continue") _submitContinue(data);
    else if (name == "publish") _submitPublish(data);
  }

  function _submitPublish(data) {
    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _submit(data);
  }

  function _do(data) {
    switch(_getCurrentSectionName()) {
      case 'dashboard':
        _doMessage(data);
      break;

      case 'proposal':
        _doProposal(data);
      break;
    }
  }

  function _submit(data) {
    switch(_getCurrentSectionName()) {
      case 'dashboard':
        _publishMessage(data);
      break;

      case 'proposal':
        _publishProposal(data);
      break;

      case 'photo':
        _publishPhoto(data);
      break;

      case 'video':
        _publishVideo(data);
      break;
    }
  }

  function _submitContinue(data) {
    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _do(data);
  }

  function _bindSubmit(data, title, initiallyDisabled, callback) {
    var $ps = data.$ps;

    _changeSubmitTitle(data.$submit, title);

    initiallyDisabled && _disableSubmit(data.$submit);

    data.$submit.unbind("click");
    data.$submit.click(function(e) {
      e.preventDefault();
      callback && _doCallback(callback, data);
    });
  }

  function _setupUpload(data, section, id, callback) {

    var $ps = data.$ps,
    $span  = $ps.find("#" + id);

    if ($span.length > 0) {

      var speed     = data.settings.transitionSpeed;
      var $section  = data.$ps.find(".section." + section);
      var $uploader = $section.find(".uploader");

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: $span.attr('data-url'),
        params: {
          utf8: $span.closest('form').find('input[name=utf8]').val(),
          authenticity_token: $span.closest('form').find('input[name=authenticity_token]').val()
        },
        debug: true,
        text: $span.html(),
        onSubmit: function(id, fileName){
          data.spinner.spin(spin_element);

          //console.log("Submit", $section);

          $section.find(".progress").show();
          $uploader.find(".percentage").css("color", "#FF0066");
          $uploader.find("input").blur();
          $uploader.find(".holder").fadeOut(speed);
          $uploader.find(".loading, .percentage").fadeIn(speed);
        },
        onProgress: function(id, fileName, loaded, total){
          var p = ((parseFloat(arguments[2]) / parseFloat(arguments[3])) * 100);
          var width = parseInt(665 * parseInt(p, 10) / 100, 10);

          console.log("uploading…");
          //console.debug(p, width, arguments, arguments[2], arguments[3]);

          if (parseInt(p) >= 75) $section.find(".uploader").find(".loading").fadeOut(speed);
          if (parseInt(p) >= 46) $section.find(".uploader").find(".percentage").css("color", "#fff");

          $uploader.find(".percentage").html(parseInt(p, 10) + "%");
          $section.find(".progress").css("width", width);
        },
        onComplete: function(id, fileName, responseJSON){
          data.spinner.stop();

          console.log("complete", $section);
          //console.debug(fileName, responseJSON, responseJSON.image_cache_name);

          $uploader.find(".loading").fadeOut(speed);
          $uploader.find(".holder").fadeIn(speed);
          $uploader.find(".percentage").fadeOut(speed);

          var cacheImage = document.createElement('img');
          cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;

          $section.find('.image_cache_name').val(responseJSON.image_cache_name);

          $(cacheImage).bind("load", function () {

            $section.find(".image_container").prepend(cacheImage);
            $section.find(".image_container").fadeIn(speed);
            $section.find(".image_container img").fadeIn(speed);

            $uploader.fadeOut(speed, function() {
              _resizeSection(data, $section);
              _center(data);
              callback && callback();
            });

          });

          $uploader.find(".progress").fadeOut(speed, function() {
            $(this).width(0);
          });
        },
        onCancel: function(id, fileName){ }
      });
    }
  }

  function _resetHiddenFields() {
  }

  function _gotoSection(data) {
    var $ps = data.$ps;

    _clearAutosuggest(data);
    _clearSection(data);
    _resetHiddenFields();

    var $section  = $ps.find(".container .section:eq(" + (data.sectionID) + ")");
    var height    = $section.find(".form").outerHeight(true);
    $ps.find(".container").animate({scrollLeft: data.sectionID * data.settings.sectionWidth, height: height }, data.settings.transitionSpeed, "easeInOutQuad");
  }

  function _bindMenu(data) {
    var $ps = data.$ps;

    $ps.find("ul.menu li a").unbind();
    $ps.find("ul.menu li a").click(function(e) {
      e && e.preventDefault();

      _hideExtraFields(data.settings.transitionSpeed);

      data.sectionID = $(this).parent().index();
      $section       = $(this).parents(".content").find(".container .section:eq(" + (data.sectionID) + ")");

      if (_sectionName($section) != _sectionName($currentSection)) {
        _resetSection(data, $section);
      }

      _selectOption(data, $(this).parent());

      if ($currentSection) {

        _resizeSection(data, $currentSection, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;

          _gotoSection(data);
          _bindSubmit(data, "Publicar", true, "publish");
          _center(data);
        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $ps.find(".container").animate({scrollTop: 0, scrollLeft: data.sectionID * data.settings.sectionWidth, height: height }, data.settings.transitionSpeed, "easeInOutQuad");
      }
    });
  }

  function _showMessage(data, kind, callback) {
    var $ps = data.$ps;
    IrekiaSpinner.spin(spin_element);

    var currentHeight = $currentSection.find(".form").outerHeight(true);
    var $success      = $currentSection.find(".message.success");
    var $error        = $currentSection.find(".message.error");

    if (kind == "success") {
      $error.hide();
      $success.show(0, function() {
        _changeSubmitTitle(data.$submit, "Cerrar");
        _enableSubmit(data.$submit);

        data.$submit.unbind("click");
        data.$submit.bind("click", function() {
          _close(data, true);
        });

      });
    } else {
      $error.show();
      $success.hide();
    }

    var successHeight = $success.outerHeight(true);

    $ps.find(".container").animate({scrollTop: $success.position().top + 20, height: successHeight }, data.settings.transitionSpeed * 2, "easeInOutQuad", function() {
      IrekiaSpinner.stop();
      callback && callback();
    });
  }

  function _center(data) {
    setTimeout(function() {
      var top  = _getTopPosition(data.$ps);
      data.$ps.animate({ top:top }, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
    }, 200);
  }

  function _triggerOpenAnimation(data) {
    var top  = _getTopPosition(data.$ps);
    var left = _getLeftPosition(data.$ps);

    if (ie) {
      data.$ps.removeClass("initialy_hidden");
      data.$ps.css({top: top + "px", left: left + "px"});

      data.$ps.fadeIn(data.settings.transitionSpeed, function() {
        $(this).find("textarea.title").focus();
      });
    } else {
      data.$ps.css({"top":(top + 100) + "px", "left": left + "px"});
      data.$ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
    }
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  function _clearInfo(data) {
    data.$ps.find("textarea").val("");
    _disableSubmit(data.$submit);
  }

  function _afterClose(data, hideLockScreen, callback) {
    _clearInfo(data);

    data.$ps.find(".extra").hide();
    data.$ps.find(".holder").show();
    _resizeSection(data, $currentSection);
    data.$ps.find(".message").fadeOut(150);

    hideLockScreen && LockScreen.hide();
    callback && callback();
  }

  // Close popover
  function _close(data, hideLockScreen, callback) {

    _clearAutosuggest(data);

    if (ie) {
      data.$ps.fadeOut(data.settings.transitionSpeed, function() {
        _afterClose(data, hideLockScreen, callback);
      });
    } else {
      data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $(this).css("top", "-900px");
        _afterClose(data, hideLockScreen, callback);
      }});
    }
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
