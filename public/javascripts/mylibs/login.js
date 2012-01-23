/*
* ======================
* FLOATING LOGIN POPOVER
* ======================
*/

(function($, window, document) {

  var ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9);

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

      // Update the reference to $ps and the password popover
      $ps = $('#' + store);
      data.$password = $("#password_reminder");
      data.$response = $("#password_response");

      _setupCallback(data, $this.attr('class'));

      $(this).unbind("click");
      $(this).click(_toggle);

      // Save the updated $ps reference into our data object
      data.$ps = $ps;
      $this.data(store, data);
      $ps.data(store, data);
    });
  };

  // Expose the plugin
  $.fn.floatingLoginPopover = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
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

    $(window).unbind(data.event);
    $(window).bind(data.event, function() { _close($ps, data, true); });

    // bindings
    _addCloseAction(data);
    _addSubmitAction(data);
    _addDefaultAction(data);
    _addRememberPasswordAction(data);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data, function() {
      $ps.find('#user_email').focus()
    });
  }

  function _triggerOpenAnimation($ps, data, callback) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    if (ie) {
      $ps.css({"top": top + "px", "left": left + "px"});

      $ps.fadeIn(data.settings.transitionSpeed, function() {
        callback && callback();
      });

    } else {
      $ps.css({"top":(top + 100) + "px", "left": left + "px"});
      $ps.show();
      $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        callback && callback();
      }
      });
    }
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  // Close popover
  function _close($ps, data, hideLockScreen, callback) {

    if (ie) {
      $ps.fadeOut(data.settings.transitionSpeed, function() {
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {
      $ps.animate({opacity:0, top:$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $ps.hide();
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  // setup the close event
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
  }

  function _addSubmitAction(data) {

    data.$ps.find('form button').unbind();
    data.$ps.find('form button').bind('click', function(e) {
      e.stopPropagation();
      data.$ps.find("p").removeClass("error");
      // data.$ps.find('form').submit();
    });

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
        _close(data.$ps, data, false, function() {
          if (data.callback == "question") {
            $el.questionPopover({open:true});
          } else if (data.callback == "proposal") {
            $el.proposalPopover({open:true});
          }
        });
      } else {
        _close(data.$ps, data, true);
        // If user is in the home reload page!!
        if ($('body').hasClass('home'))
          window.location.reload();
      }

      loginInLinks();
    });

    data.$ps.find("form").bind('ajax:error', function(event, xhr, status) {
      $(this).effect("shake", { times:4 }, 100);
      data.$ps.find("p").addClass("error");
    });
  }

  function _addSubmitRecoverPasswordAction(data) {
    data.$password.find('inder input[type="submit"]').bind('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      if (data.$ps.find("input.email").val().replace(/\s/g,"") == "") {
        data.$ps.effect("shake", { times:4 }, 100);
      } else {
        _close(data.$ps, data, true);
      }
    });
  }

  function _addCloseAction(data) {
    data.$ps.find(".close").unbind();
    data.$ps.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data.$ps, data, true);
    });
  }

  function _addRememberPasswordAction(data){
    data.$ps.find("a.password_reminder").unbind();
    data.$ps.find("a.password_reminder").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data.$ps, data);

      _triggerOpenAnimation(data.$password, data, function() {
        data.$password.find("input[type='email']").focus();
      });

      data.$password.find(".close").bind('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        _close(data.$password, data, true);
      });

      data.$password.find('a.white_button').unbind('click');
      data.$password.find('a.white_button').bind('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        _close(data.$password, data, false);
        data.$password.find('form').submit();
        _triggerOpenAnimation(data.$response, data);
        _addResponsePasswordAction(data);
      });

      $(window).unbind(data.event);
      $(window).bind(data.event, function() {
        _close(data.$password, data, true);
      });
    });
  }

  function _addResponsePasswordAction(data) {
    $(window).unbind(data.event);
    $(window).bind(data.event, function() {
      _close(data.$response, data, true);
    });
  }

  function _addDefaultAction(data){
    data.$password.bind('click', function(e) {
      e.stopPropagation();
    });

    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  $(function() {});

})(jQuery, window, document);

/*
* =============
* LOGIN POPOVER
* =============
*/

(function($, window, document) {

  var ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9);

  var
  store = "login-popover",
  // Public methods exposed to $.fn.loginPopover()
  methods = {},
  // Some nice default values
  defaults = {
    transitionSpeed: 250
  };
  // Called by using $('foo').loginPopover();
  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var
      // The current <select> element
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},

      // This gets applied to the 'ps_container' element
      id = "sign_in",

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup loginPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
      }

      // Hide the <select> list and place our new one in front of it
      $this.before($ps);

      // Update the reference to $ps
      $ps = $("#" + data.id);
      $ps.bind('click', function(e) {
        e.stopPropagation();
      });

      $(this).click(_toggle);

      $(window).bind('resize.' + data.id, function() {
        _position($this);
      });

      $(window).bind('_close.'+ data.id, function() {
        _close($this);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;
      $this.data(store, data);
      $ps.data(store, data);

      data.$password = $("#password_reminder");
      data.$response = $("#password_response");

      if ($ps.attr('class') == 'error') {
        _open($this);
      }
    });
  };

  // Expose the plugin
  $.fn.loginPopover = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    }
  };

  function _open($this) {
    var data = $this.data(store);
    var $ps = data.$ps;

    _position($this);

    _addDefaultAction(data);
    _addRememberPasswordAction(data);

    // setup the close event & signal the other subscribers
    var event = "_close."+data.id;
    GOD.subscribe(event);

    if (!$ps.hasClass("open")) {
      $ps.addClass("open");
      $ps.fadeIn(data.settings.transitionSpeed, function(){
				// Focus on email input
				$ps.find('#user_email').focus();
			});
    } else {
      _close($this);
    }
  }

  // Toggle popover
  function _toggle(e) {
    if (e) {
      e.preventDefault();
      e.stopPropagation();
    }
    _open($(this));
  }

  function _addDefaultAction(data){
    data.$password.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  function _triggerOpenAnimation($ps, data, callback) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    if (ie) {
      $ps.css({"top": top + "px", "left": left + "px"});

      $ps.fadeIn(data.settings.transitionSpeed, function() {
        callback && callback();
      });
    } else {
      $ps.css({"top":(top + 100) + "px", "left": left + "px"});
      $ps.show();
      $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        callback && callback();
      }
      });
    }
  }

  function _addRememberPasswordAction(data){
    data.$ps.find("a.password_reminder").unbind();
    data.$ps.find("a.password_reminder").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(data.$this);

      LockScreen.show(function(){
        GOD.subscribe("_close.password_reminder");
        _triggerOpenAnimation(data.$password, data, function() {
          data.$password.find("input[type='email']").focus();
        });
      });

      data.$password.find(".close").bind('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        _closePassword(data.$password, data, true);
      });

      data.$password.find('a.white_button').unbind();
      data.$password.find('a.white_button').bind('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        _closePassword(data.$password, data, false);
        data.$password.find('form').submit();
        _triggerOpenAnimation(data.$response, data);
        _addResponsePasswordAction(data);
      });


      $(window).unbind(data.event);
      $(window).bind("_close.password_reminder", function() {
        _closePassword(data.$password, data, true);
      });
    });
  }

  function _addResponsePasswordAction(data) {

    data.$response.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _closeResponse(data.$response, data, true);
    });

    $(window).unbind(data.event);
    $(window).bind(data.event, function() {
      _close(data.$response, data, true);
    });
  }

  function _closeResponse($ps, data, hideLockScreen, callback) {

    if (ie) {
      $ps.fadeOut(data.settings.transitionSpeed, function() {
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {
      $ps.animate({opacity:0, top:$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $ps.hide();
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  function _closePassword($ps, data, hideLockScreen, callback) {

    GOD.unsubscribe("_close.password_reminder");

    if (ie) {
      $ps.fadeOut(data.settings.transitionSpeed, function() {
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {
      $ps.animate({opacity:0, top:$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $ps.hide();
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  // Close popover
  function _close($this) {
    var data = $this.data(store);
    data.$ps.removeClass("open");
    data.$ps.fadeOut(data.settings.transitionSpeed);
  }

  function _position($this) {
    var data = $this.data(store);
    var $ps = $("#sign_in");

    if (data.$this) {
      var $link = data.$this;
      var x = $link.offset().left - $ps.width()  + 30;
      var y = $link.offset().top + 20;

      $ps.css("left", x);
      $ps.css("top", y);
    }
  }

  $(function() {});

})(jQuery, window, document);
