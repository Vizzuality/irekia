/*
* ================
* QUESTION POPOVER
* ================
*/

(function($, window, document) {

  var ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9);

  var spin_element = document.getElementById('question_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  templates = {
   success: ['<div id="<%= name %>_<%= id %>" class="article mini with_icon popover with_footer">',
   '  <div class="inner">',
   '    <%= content %> ',
   '    <span class="close"></span>',
   '  </div>',
   '  <div class="bfooter">',
   '  <div class="separator"></div>',
   '  <div class="inner">',
   '    <a href="#" class="white_button pink close right"><span>Aceptar</span></a>',
   '  </div>',
   '  </div>',
   '  <div class="t"></div><div class="f"></div>',
   '</div>'].join(' ')
  };

  var
  store = "question-popover",
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

      // Dont do anything if we've already setup questionPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.templates = templates;
        data.name = store;
        data.event = "_close." + store + "_" + id;
      }

      // Update the reference to $ps
      $ps = $('#' + store + "_" + id);

      $(this).click(_toggle);

      !ie && $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the questionPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      // Autolaunch of the widget
      if (settings.open == true) {
        data.id = data.name;
        _open(data);
      }

    });
  };

  // Expose the plugin
  $.fn.questionPopover = function(method) {
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
    var $ps   = $('#' + data.name + "_" + data.id);

    LockScreen.show(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _open(data) {
    data.$ps = $(document).find(".article#" + data.id);
    var $ps = data.$ps;

    // bindings
    _addCloseAction(data);
    _addSubmitAction(data);
    !ie && _addDefaultAction(data);

    $ps.find("textarea.grow").autogrow();

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
    $ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    if (ie) {
      $ps.removeClass("initialy_hidden");
      $ps.css({top: top + "px", left: left + "px"});

      $ps.fadeIn(data.settings.transitionSpeed, function() {
        $(this).find("textarea.title").focus();
      });

    } else {
      $ps.css({top:(top + 100) + "px", left: left + "px"});

      $ps.animate({opacity: 1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function() {
        $(this).find("textarea.title").focus();
      }});
    }
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.outerHeight(true)) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  function _clearInfo($ps) {
    $ps.find("textarea").val("");
    $ps.find(".counter").html(140);
    $ps.find(".holder").fadeIn(150);
    _disableSending($ps);
  }

  function enableSending($ps) {
    if ($ps) {
      $ps.find(".bfooter button").removeAttr("disabled");
      $ps.find(".bfooter button").removeClass("disabled");
    }
  }

  function _disableSending($ps) {
    if ($ps) {
      $ps.find(".bfooter button").attr("disabled", "true");
      $ps.find(".bfooter button").addClass("disabled");
    }
  }

  function _build(data, response, templateName, extraParams) {
    var params = _.extend({id:data.id + "_success", name:data.name, content:response }, extraParams);
    var $ps = $(_.template(data.templates[templateName], params ));
    return $ps;
  }

  function _close2(data, hideLockScreen, callback) {
    if (ie) {
      data.$ps.fadeOut(data.settings.transitionSpeed, function() {
        $(this).remove();
        _clearInfo(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {

      data.$ps.animate({opacity:.5, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $(this).remove();
        _clearInfo(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  // Close popover
  function _close(data, hideLockScreen, callback) {
    if (ie) {
      data.$ps.fadeOut(data.settings.transitionSpeed, function() {
        _clearInfo(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {
      data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $(this).css("top", "-900px");
        _clearInfo(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
  }

  function _addSubmitAction(data) {
    data.$ps.find("form").die();

    data.$ps.find("form").live("submit", function(e) {
      spinner.spin(spin_element);
      _disableSending(data.$ps);
    });

    data.$ps.find("form").live('ajax:success', function(event, response, status) {
      spinner.stop();
      enableSending(data.$ps);

      _close(data, false, function() {
        _gotoSuccess(data, response);
      });
    });

    data.$ps.find("form").live('ajax:error', function(event, response, status) {
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
    // data.$ps.unbind("click");
    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _gotoSuccess(data, response) {

    data.$ps = _build(data, response, "success");
    var $ps  = data.$ps;

    _addCloseAction2(data);
    _addDefaultAction(data);

    $("#container").prepend($ps);
    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);

    $ps.find(".input-counter").inputCounter();
  }

  $(function() { });

})(jQuery, window, document);
