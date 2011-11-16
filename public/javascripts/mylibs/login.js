/*
* ======================
* FLOATING LOGIN POPOVER
* ======================
*/

(function($, window, document) {

  var ie6 = false;

  // Help prevent flashes of unstyled content
  if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
    ie6 = true;
  } else {
    document.documentElement.className = document.documentElement.className + ' ps_fouc';
  }

  var
  store = "login",
  // Public methods
  methods = {},
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    transitionSpeed: 200,
    maxLimit: 140
  };

  // Called by using $('foo').floatingLoginPopover();
  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var
      // The current <select> element
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},
      callback = ($this.hasClass("after_create_proposal") || $this.hasClass("after_ask_question")) ? true : false,

      // This gets applied to the 'ps_container' element
      id = $this.attr('id') || $this.attr('name'),

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup floatingLoginPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.callback = callback;
        data.event = "_close." + store + "_" + id;
      }

      // Update the reference to $ps
      $ps = $('#' + store);

      _setupCallback(data, $this.attr('class'));

      $(this).unbind("click");
      $(this).click(_toggle);

      $(window).unbind(data.event);
      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the floatingLoginPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
    });
  };

  // Expose the plugin
  $.fn.floatingLoginPopover = function(method) {
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
    e.preventDefault();
    e.stopPropagation();

    var data  = $(this).data(store);
    var $ps   = $('#' + data.store);

    LockScreen.show(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _setupCallback(data, classes) {
    if (classes.indexOf("question") != -1) {
      data.callback = "question";
    } else if (classes.indexOf("proposal") != -1) {
      data.callback = "proposal";
    }
  }

  function _open(data) {
    var $ps = data.$ps;

    // bindings
    _addCloseAction(data);
    _addSubmitAction(data);
    _addPassworRecoverAction(data);
    _addDefaultAction(data);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    $ps.css({"top":(top + 100) + "px", "left": left + "px"});
    $ps.show();
    $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){$ps.find('#user_email').focus()}});
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  // Close popover
  function _close(data, hideLockScreen, callback) {

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      data.$ps.hide();
      hideLockScreen && LockScreen.hide();
      callback && callback();
    }});
  }

  // setup the close event
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
  }

  function _addSubmitAction(data) {

    data.$ps.find("form").unbind();
    data.$ps.find("form").bind('ajax:success', function(event, xhr, status) {

      GOD.unsubscribe(data.event);

      var $el = $(this);
      var $nav = $(xhr);

      // Let's replace the header
      $("nav .content ul.auth").fadeOut(250, function() {
        $("nav .content ul.auth").replaceWith($(xhr));
        $("nav .content ul.auth").fadeIn(250);
        $(".auth a.login").unbind(); // and we no longer need this binding
      });

      if (data.callback) {
        _close(data, false, function() {
          if (data.callback == "question") {
            $el.questionPopover({open:true});
          } else if (data.callback == "proposal") {
            $el.proposalPopover({open:true});
          }
        });
      } else {
        _close(data, true);
				// If user is in the home reload page!!
				if ($('body').hasClass('home'))
					window.location.reload();
      }

      loginInLinks();
    });

    data.$ps.find("form").bind('ajax:error', function(event, xhr, status) {
      $(this).effect("shake", { times:4 }, 100);
    });
  }

  function _addSubmitRecoverPasswordAction(data) {
    data.$ps.find('input[type="submit"]').bind('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      if (data.$ps.find("input.email").val().replace(/\s/g,"") == "") {
        data.$ps.effect("shake", { times:4 }, 100);
      } else {
        _close(data, true);
      }
    });
  }

  function _addPassworRecoverAction(data) {
    data.$ps.find(".recover-password").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data, false, function(){
        _loadTemplate(data, "password");
      });
    });
  }

  function _addCloseAction(data) {
    data.$ps.find(".close").unbind();
    data.$ps.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data, true);
    });
  }

  function _addDefaultAction(data){
    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _loadTemplate(data, template) {
    var $ps = data.$ps;

    _addCloseAction(data);
    _addDefaultAction(data);
    _addSubmitRecoverPasswordAction(data);

    $("#container").prepend($ps);
    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
  }

  $(function() {});

})(jQuery, window, document);

