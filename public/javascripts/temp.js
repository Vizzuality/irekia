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
  store = "event-popover",
  // Public methods
  methods = { },
  interval,
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    sectionWidth: 687,
    transitionSpeed: 200,
    closeTransitionSpeed: 100,
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

      // Dont do anything if we've already setup enableLocationEditing on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
        data.spinner = spinner;
      }

      // Update the reference to $ps
      $ps = $('#' + store);

      $(this).click(_toggle);

      $(window).unbind();
      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the enableLocationEditing data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      data.$submit = $ps.find("footer .publish");

      // bindings
      _addCloseAction(data);
      _addDefaultAction(data);
      _bindSubmit(data, "Continuar", true, "continue");
    });
  };

  // Expose the plugin
  $.fn.enableLocationEditing = function(method) {
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

    startMiniMap("editable_map", miniLat, miniLng, true);

    var data  = $(this).data(store);
    var $ps   = $('#' + data.id);

    LockScreen.show(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _open(data) {
    var $ps = data.$ps;

    _bindSubmit(data, "Continuar", true, "continue");

    _subscribeToEvent(data.event);
    _triggerOpenAnimation(data);
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

  function _changeSubmitTitle($submit, title) {
    $submit.find("span").text(title);
  }

  function _submitPublish(data) {
    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _question() ?  _publishQuestion(data) : _publishProposal(data);
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

  // Close popover
  function _close(data, hideLockScreen, callback) {

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.closeTransitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).css("top", "-900px");

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
