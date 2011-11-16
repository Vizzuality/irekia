(function($, window, document) {

  var ie6 = false;

  // Help prevent flashes of unstyled content
  if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
    ie6 = true;
  } else {
    document.documentElement.className = document.documentElement.className + ' ps_fouc';
  }

  var
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
      _bindSubmit(data, "Continuar", true, "continue");
      _bindActions(data);
      _enableInputCounter(data, $("#question_question_data_attributes_question_text"), function() { _enableSubmit(data.$submit)} , function() { _disableSubmit(data.$submit)});
      _enableInputCounter(data, $("#proposal_proposal_data_attributes_title"), function() { _enableSubmit(data.$submit)} , function() { _disableSubmit(data.$submit)});

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

    _bindSubmit(data, "Continuar", true, "continue");

    data.questionStep = 0;
    data.proposalStep = 0;

    // Initialize the initial section
    $currentSection    = $ps.find(".container .section:nth-child(1)");
    $currentMenuOption = $ps.find(".menu").find("li:nth-child(" + (data.sectionID + 1) + ")");
    $currentSection    = $ps.find(".container .section:nth-child(" + (data.sectionID + 1) + ")");

    _gotoSection(data);

    _selectOption(data, $currentMenuOption);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation(data);
    $ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }

  function _enableInputCounter(data, $input, on, off) {
    var $ps = data.$ps;

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

  function _resetImageContainer(e, data) {
    e.preventDefault();

    var
    $ps = data.$ps,
    $proposal = $ps.find(".section.proposal"),
    $image_container = $proposal.find(".image_container");

    $image_container.fadeOut(data.settings.transitionSpeed, function() {
      $image_container.find("img").remove();
      $ps.find(".uploader").show();
      $ps.find(".holder").show();
      $ps.find(".loading").hide();
      $ps.find(".percentage").hide();
      $ps.find(".progress").css("width", "0");
    });

  }

  function _bindActions(data) {
    var $ps = data.$ps;

    // Image uploader
    _setupUpload(data, "upload_image");

    // Remove image link
    $ps.find(".image_container a.remove").unbind();
    $ps.find(".image_container a.remove").bind("click", function(e) { _resetImageContainer(e, data); } );

    $ps.find(".section .open_upload").click(function(e) {
      e && e.preventDefault();
      $(this).closest("input[type='file']").click();
    });
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
    var $ps = data.$ps;
    $ps.find(":text, textarea").val("");
    $ps.find(".uploader").show();
    $ps.find(".holder").show();
    $ps.find(".loading").hide();
    $ps.find(".percentage").hide();
    $ps.find(".progress").css("width", "0");
    $ps.find(".counter").html("140");
    $ps.find(".image_container").hide();
    $ps.find(".image_container img").remove();
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

    _enableInputCounter(data, $(".autosuggest_field input"), null, function() { _clearAutosuggest(data); _resetHiddenFields(); } );

    $currentSection.find('.autosuggest_field input').unbind();
    $currentSection.find('.autosuggest_field input').keyup(function(ev){

      if (_.any([8, 13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return ev.keyCode == i} )) { return; }

      clearTimeout(interval);

      if ($(this).val().length > 3) {
        interval = setTimeout(function(){

          var query = $currentSection.find('.extra .autosuggest_field input[type="text"]').val();

          data.spinner.spin(spin_element);

          var params = { name : query };

          if (_getCurrentSectionName() == "proposal") {
            params = $.extend(params, { only_areas : true} );
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
      _resizeSection(data, $currentSection);
      _disableSubmit(data.$submit);
      //data.$submit.unbind();
      _changeSubmitTitle(data.$submit, "Publicar");
    } else {
      var $form = $currentSection.find("form");
      $form.submit();
      data.spinner.spin(spin_element);

      $form.unbind();
      $form.bind('ajax:success', function(event, xhr, status) { _successProposal(data, $form, xhr); })
    }
  }

  function _doQuestion(data) {
    var $ps = data.$ps;

    _showExtraFields(data.settings.transitionSpeed);
    _resizeSection(data, $currentSection);
    _disableSubmit(data.$submit);
    _changeSubmitTitle(data.$submit, "Publicar");
    data.$submit.unbind();
  }

  function _publishQuestion(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successQuestion(data, $form, xhr); })
  }

  function _publishProposal(data) {
    var $ps = data.$ps;
    var $form = $currentSection.find("form");

    $form.submit();
    data.spinner.spin(spin_element);

    $form.unbind();
    $form.bind('ajax:success', function(event, xhr, status) { _successQuestion(data, $form, xhr); })
  }

  function _successProposal(data, $form, xhr) {
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

  function _successQuestion(data, $form, xhr) {
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
    return _question() ? "question" : "proposal";
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

  function _doCallback(name, data) {
    if (name == "continue") _submitContinue(data);
    else if (name == "publish") _submitPublish(data);
  }

  function _submitPublish(data) {
    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _question() ?  _publishQuestion(data) : _publishProposal(data);
  }

  function _submitContinue(data) {
    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _question() ?  _doQuestion(data) : _doProposal(data);
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

  function _setupUpload(data, id) {

    var $ps = data.$ps,
				$span  = $ps.find("#" + id);

    if ($span.length > 0) {

      var speed = data.settings.transitionSpeed;
      var $uploader = $ps.find(".uploader");

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: $span.attr('data-url'),
				params: {
					utf8: $span.closest('form').find('input[name=utf8]').val(),
					authenticity_token: $span.closest('form').find('input[name=authenticity_token]').val()
				},
        debug: true,
        text:"sube una nueva",
        onSubmit: function(id, fileName){
          data.spinner.spin(spin_element);
          $currentSection.find(".holder").fadeOut(speed);
          console.log($ps, $ps.find(".uploader").find(".holder").fadeOut(speed));
					$ps.find(".progress").show();
          $uploader.find(".percentage").css("color", "#FF0066");
					$uploader.find("input").blur();
          $uploader.find(".holder").fadeOut(speed);
          $uploader.find(".loading, .percentage").fadeIn(speed);
        },
        onProgress: function(id, fileName, loaded, total){
					var p = ((parseFloat(arguments[2]) / parseFloat(arguments[3])) * 100);
					var width = parseInt(665 * parseInt(p, 10) / 100, 10);

					console.debug(p, width, arguments, arguments[2], arguments[3]);

					if (parseInt(p) >= 75) $ps.find(".uploader").find(".loading").fadeOut(speed);
					if (parseInt(p) >= 46) $ps.find(".uploader").find(".percentage").css("color", "#fff");

          $uploader.find(".percentage").html(parseInt(p, 10) + "%");
				  $ps.find(".progress").css("width", width);
				},
        onComplete: function(id, fileName, responseJSON){
          data.spinner.stop();

					console.debug(fileName, responseJSON, responseJSON.image_cache_name);
          $uploader.find(".loading").fadeOut(speed);
          $uploader.find(".holder").fadeIn(speed);
          $uploader.find(".percentage").fadeOut(speed);

          var cacheImage = document.createElement('img');
          cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;
					$ps.find('.image_cache_name').val(responseJSON.image_cache_name);

          $(cacheImage).bind("load", function () {
            $ps.find(".image_container").prepend(cacheImage);
            $ps.find(".image_container").fadeIn(speed);
            $ps.find(".image_container img").fadeIn(speed);
            $uploader.fadeOut(speed, function() {
              _resizeSection(data, $currentSection);
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
    $("#question_question_data_attributes_politician_id").val("");
    $("#question_question_data_attributes_area_id").val("");
    $("#proposal_proposal_data_attributes_politician_id").val("");
    $("#proposal_proposal_data_attributes_area_id").val("");
  }

  function _gotoSection(data) {
    var $ps = data.$ps;

    _clearAutosuggest(data);
    _clearSection(data);
    _resetHiddenFields();

    _bindSearch(data);

    var $section  = $ps.find(".container .section:nth-child(" + (data.sectionID + 1) + ")");
    var height    = $section.find(".form").outerHeight(true);
    $ps.find(".container").animate({scrollLeft: data.sectionID * data.settings.sectionWidth, height: height }, data.settings.transitionSpeed, "easeInOutQuad");
  }

  function _bindMenu(data) {
    var $ps = data.$ps;

    $ps.find("ul.menu li a").unbind();
    $ps.find("ul.menu li a").click(function(e) {
      e && e.preventDefault();

      data.questionStep = 0;
      data.proposalStep = 0;

      _hideExtraFields(data.settings.transitionSpeed);

      data.sectionID = $(this).parent().index();
      $section       = $(this).parents(".content").find(".container .section:nth-child(" + (data.sectionID + 1) + ")");

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
          _bindSubmit(data, "Continuar", true, "continue");
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

    $ps.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, data.settings.transitionSpeed * 2, "easeInOutQuad", function() {
      IrekiaSpinner.stop();
      callback && callback();
    });
  }

  function _triggerOpenAnimation(data) {
    var top  = _getTopPosition(data.$ps);
    var left = _getLeftPosition(data.$ps);

    data.$ps.css({"top":(top + 100) + "px", "left": left + "px"});
    data.$ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
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

    _clearAutosuggest(data);

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).css("top", "-900px");
      _clearInfo(data.$ps);

      data.questionStep = 0;
      data.proposalStep = 0;

      data.$ps.find(".extra").hide();
      data.$ps.find(".holder").show();
      _resizeSection(data, $currentSection);
      data.$ps.find(".message").remove();

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
