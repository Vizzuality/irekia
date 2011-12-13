/*
* LockScreen Systems Inc.
*/
var LockScreen = (function() {
  var enableOutsideClickToClose = true;

  function _isLocked() {
    return $("#lock_screen").length != 0;
  }

  function _hide(callback) {
    if (_isLocked()) {
      $("#lock_screen").fadeOut(150, function() {
        $(this).remove();
        callback && callback();
      });
    }
  }

  function _showIfHidden(callback) {
    if (!$("#lock_screen").length) {
      _show(callback);
    }
    else {
      callback && callback();
    }
  }

  function _show(callback) {
    if (!_isLocked()) {
      $("body").append("<div id='lock_screen'></div>");
      $("#lock_screen").height($(document).height());

      if (!enableOutsideClickToClose) {
        $("#lock_screen").unbind()
        $("#lock_screen").click(function(e) {
          e.preventDefault();
          e.stopPropagation();
        });
      }

      $("#lock_screen").fadeIn(150, function() {
        callback && callback();
      });
    }
  }

  function _toggle(callback) {
    $("#lock_screen").length ? _hide(callback) : _show(callback);
  }

  return {
    toggle:_toggle,
    show:_show,
    showIfHidden:_showIfHidden,
    hide:_hide
  };
})();

/*
* GOD sees everything
*/
var GOD = (function() {
  var subscribers = {};
  var debug = true;

  function unsubscribe(event) {
    debug && console.log("Unsubscribe ->", event);
    delete subscribers[event];
  }

  function subscribe(event) {
    debug && console.log("Subscribe ->", event);

    subscribers[event] = event
  }

  function _signal(event) {
    debug && console.log("Signal to ", event);

    $(window).trigger(event);
    unsubscribe(event);
  }

  function _signalAll() {
    if (!_.isEmpty(subscribers)) {
      _.each(subscribers, _signal);
    }
  }

  // send signal to all the other subscribers
  function broadcast(protectedEvent) {
    _.each(subscribers, function(event) {
      protectedEvent != event && _signal(event);
    });
  }

  function _unBindEscKey() {
    $(document).unbind("keyup");
  }

  function _bindEscKey() {
    $(document).keyup(function(e) {
      e.stopPropagation();
      e.keyCode == 27 && _signalAll();
    });
  }

  $(function() {
    _bindEscKey();
    $('html').click(_signalAll);
  });

  return {
    subscribe: subscribe,
    unsubscribe: unsubscribe,
    broadcast: broadcast,
    bindEsc: _bindEscKey,
    unbindEsc: _unBindEscKey
  };
})();

/*
* =============
* EVENT POPOVER
* =============
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
  store = "event-popover",
  // Public methods exposed to $.fn.infoEventPopover()
  methods = {},
  // Some nice default values
  defaults = {
    transitionSpeed: 250
  };
  // Called by using $('foo').infoEventPopover();
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

      // Dont do anything if we've already setup infoEventPopover on this element
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
      $ps = $("#info-" + data.id);

      $ps.find("a").bind('click', function(e) {
        window.location = $(this).attr('href');
      });

      $ps.bind('click', function(e) {
        e.stopPropagation();
      });

      $(this).click(_toggle);

      $ps.find("span.close").click(function(e) { _close($this) });

      $(window).bind('_close.'+ data.id, function() {
        _close($this);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the infoEventPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
    });
  };

  // Expose the plugin
  $.fn.infoEventPopover = function(method) {
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

    var $this = $(this);
    var data = $this.data(store);
    var $ps = data.$ps;

    _position($this);
    // setup the close event & signal the other subscribers
    var event = "_close."+data.id;
    GOD.subscribe(event);
    GOD.broadcast(event);

    if (!$ps.hasClass("open")) {
      $ps.addClass("open");
      $ps.fadeIn(data.settings.transitionSpeed);
      $('.scroll-pane').jScrollPane();
    } else {

      _close($this);
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
    var $ps = $("#info-" + data.id);
    var $link = data.$this;
    var x = $link.position().left - $ps.width()/2 + $link.width() / 2 - 10;
    var y = $link.position().top - $ps.height() - 38;

    $ps.css("left", x);
    $ps.css("top", y);
  }

  $(function() {});

})(jQuery, window, document);

/*
* =============
* LOGIN POPOVER
* =============
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

      if ($ps.attr('class') == 'error') {
        _open($this);
      }

    });
  };

  // Expose the plugin
  $.fn.loginPopover = function(method) {
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
    }
  };


  function _open($this) {
    var data = $this.data(store);
    var $ps = data.$ps;

    _position($this);

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

  // Close popover
  function _close($this) {
    var data = $this.data(store);
    data.$ps.removeClass("open");
    data.$ps.fadeOut(data.settings.transitionSpeed);
  }

  function _position($this) {
    var data = $this.data(store);
    var $ps = $("#" + data.id);
    var $link = data.$this;
    var x = $link.offset().left - $ps.width()  + 30;
    var y = $link.offset().top + 20;

    $ps.css("left", x);
    $ps.css("top", y);
  }

  $(function() {});

})(jQuery, window, document);

/*
* =============
* SHARE POPOVER
* =============
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
  store = "share-popover",
  // Public methods exposed to $.fn.sharePopover()
  methods = {},
  // Some nice default values
  spinner,
  spin_element,
  defaults = {
    transitionSpeed: 120,
    easing:'easeInExpo'
  };

  // Called by using $('foo').sharePopover();
  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var
      // The current <select> element
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},

      // This gets applied to the 'ps_container' element
      id = $this.attr('class').fulltrim().replace(/ /g, "_");

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup sharePopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$handler = $this;
        data.settings = settings;
        data.$submit = $(this).next(".sharebox.email").find('input[type="submit"]');
        data.$input = $(this).next(".sharebox.email").find('input[type="text"]');
      }

      // Update the reference to $ps
      $ps = $(this);

      data.$submit.unbind("click");

      data.$submit.click(function(e) {
        e.stopPropagation();

        if (isEmpty(data.$input.val())) {
          data.$input.parent().addClass("error");
          return;
        }

        spinner.spin(spin_element);
        _removeOk(data);

        $(this).fadeOut(data.settings.transitionSpeed);
        _shareWith($(this), "email", data.settings.transitionSpeed, data.settings.easing);
      });

      $ps.next(".sharebox .share.twitter").bind('click', function(e) {
        e.stopPropagation();

          var width  = 611,
          height = 400,
          left   = 21,
          top    = 44,
          url    = this.href,
          opts   = 'status=1' + ',width='  + width  + ',height=' + height + ',top='    + top    + ',left='   + left;

          window.open(url, 'twitter', opts);

          return false;
      });


      $ps.next(".sharebox").bind('click', function(e) {
        e.stopPropagation();
      });

      $(this).click(_toggle);

      $(window).bind('_close.'+ data.id, function() {
        _close($this);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the sharePopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
    });
  };

  $(function() {
    var $el  = $(this).parents("li").find(".share.email");
    var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    spin_element = document.getElementById('share_via_email');
    spinner = new Spinner(opts);
  });

  // Expose the plugin
  $.fn.sharePopover = function(method) {
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
    }
  };

  function _shareWith($el, service, speed, easing) {
    var $form;

    function success(argument) {
      spinner.stop();
			$form.fadeOut('fast',function(){
				$form.find('input[type="submit"]').fadeIn(speed);
	      $form.find('input[type="text"]').val("");
	      $form.find('.holder').fadeIn(speed);
			});

      $ok = $('<div class="ok" />');
      $el.parents("li").find(".share.email").append($ok)
      $ok.animate({opacity:1, top:"-2px"}, speed, easing);

      return true;
    }

    function error(event, xhr, status) {
      spinner.stop();
      $form.find(".input_field").addClass("error");
      $form.find('input[type="submit"]').fadeIn(speed);
      return true;
    }

    function removeOk($ok) {
      $ok.animate({ opacity:0, top: "20px" }, speed, easing, function() {
        $(this).remove();
      })
    }

    removeOk($el.parents("li").find(".share.email .ok"), speed, easing);

    $form = $el.parents("li").find("form");
    $form.unbind();
    $form.find(".input_field").removeClass("error");
    $form.bind('ajax:success', success);
    $form.bind('ajax:error', error);
  }

  function _resize($ps) {
    var $sharebox = $ps.next(".sharebox");
    if (!$sharebox.hasClass("email")) {
      var items = $sharebox.find("li").length;
      $sharebox.width(items * 35);
    }
  }

  function _removeOk(data) {
    var $ps = data.$ps;

    $ps.find(".ok").animate({ opacity:0, top: "20px" }, data.settings.transitionSpeed, data.settings.easingMethod, function() {
      $(this).remove();
    })
  }

  // Toggle popover
  function _toggle(e) {
    e.preventDefault();
    e.stopPropagation();

    var $this = $(this);
    var data = $this.data(store);
    var $ps = data.$ps;

    _resize($ps);

    // setup the close event & signal the other subscribers
    var event = "_close."+data.id;
    GOD.subscribe(event);
    GOD.broadcast(event);

    if (!$ps.hasClass("open")) {
      $ps.addClass("open");
      $ps.next(".sharebox").fadeIn(data.settings.transitionSpeed);
      _removeOk(data);
    } else {
      _close($this);
    }
  }

  // Close popover
  function _close($this) {
    var data = $this.data(store);
    data.$ps.removeClass("open");
    data.$ps.next(".sharebox").fadeOut(data.settings.transitionSpeed);
  }

  $(function() {});

})(jQuery, window, document);





/* FILTER WIDGET */
(function($, window, document) {

  var ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9);

  var
  store = "filter-widget",
  // Public methods exposed to $.fn.filterWidget()
  methods = {},
  // Some nice default values
  defaults = {
    transitionSpeed: 250
  };

  // Called by using $('foo').filterWidget();
  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var $this = $(this);

      var id = $this.attr('id');
      var data = $this.data(store + "_" + id) || {};

      // Dont do anything if we've already setup filterWidget on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.filter = "";
        data.url = "";
        data.sort = {};
      }

      var $ps = $(this);

      // Let's create the spinner dom element
      if ($(this).find('div.right ul.selector').length > 0) {
        var filter_spinner = new Spinner({lines: 12,length: 0,width: 3,radius: 6,color: 'white',speed: 1,trail: 100,shadow: false});
        var switch_spinner = new Spinner({lines: 12,length: 0,width: 3,radius: 6,color: '#3786C0',speed: 1,trail: 100,shadow: false});
      }

      $(this).find(".filter").unbind("click");
      $(this).find(".filter").bind('click', function(e) {
        e.preventDefault();

        // Place spinner and show it (if exists)
        filter_spinner.stop();
        switch_spinner.stop();

        if ($(this).closest('ul.switch').length==0) {
          filter_spinner.spin();
          var top = $(this).position().top;
          var right = 3;
          if (ie) right = 10;
          $(filter_spinner.el).css({ top:top+8+"px", position:"absolute", right:right + 'px', height:'15px', width:'15px', 'z-index':'1000'});
          $(this).closest('div.right').append(filter_spinner.el);
        } else {
          switch_spinner.spin();
          var left = $(this).position().left;
          $(switch_spinner.el).css({ top:"16px", position:"absolute", left:'5px', height:'15px', width:'15px', 'z-index':'1000'});
          $(this).closest('div.right').append(switch_spinner.el);
        }

        var classes = $(this).attr("class");


        if ($(this).hasClass("more_polemic") || $(this).hasClass("more_recent")) {
          data.filter = classes.replace("filter ", "");
        }

        if (data.filter == "more_recent") {
          data.sort = { more_recent:true };
        } else if (data.filter == "more_polemic") {
          data.sort = { more_polemic:true };
        }

        $(this).parents("ul").find("li").removeClass("selected");
        $(this).parent().addClass("selected");
        data.url = $ps.find("ul.selector li.selected a").attr("href");

        var settings = data.settings;

        $.ajax({ url: data.url, data: data.sort, type: "GET", success: function(data){
          $ps.find(".listing").fadeOut(settings.transitionSpeed, function() {

            $ps.find(".listing").html(data);

						if ($ps.find(".listing h2").length>0) {
							var $place = $ps.find('header div.left');
							$place.find('h2').remove();
							$place.append($ps.find(".listing h2"));
						}

            $ps.find(".listing").slideDown(settings.transitionSpeed, function() {
              filter_spinner.stop();
              switch_spinner.stop();
            });

            // Activate
            $ps.find(".placeholder").smartPlaceholder();
            $ps.find(".comment-box form").enableCommentBox();
          });
        }});
      });

      // Save the filterWidget data onto the <select> element
      $this.data(store, data);

    });
  };

  // Expose the plugin
  $.fn.filterWidget = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    }
  };

  $(function() {});

})(jQuery, window, document);





/*
* ================
* AREAS POPOVER
* ================
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
  store = "areas_selector",
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

      // Dont do anything if we've already setup areasPopover on this element
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
      $ps = $('.' + store);

      $(this).click(_toggle);

      $(this).find("ul li a").bind('click', function(e) {
        window.location = $(this).attr('href');
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the areasPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
      $(window).bind(data.event, function() { _close(data); });
    });
  };

  // Expose the plugin
  $.fn.areasPopover = function(method) {
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
    var $ps   = data.$ps;

    if ($ps.hasClass("open")) {
      _close(data);
    } else {
      $ps.addClass("open");
      _open(data);
      GOD.subscribe(data.event);
      GOD.broadcast(data.event);
    }
  }

  function _open(data) {
    var $ps = data.$ps;

    _triggerOpenAnimation($ps, data);
    $ps.find('.scroll-pane').jScrollPane();

    $ps.find(".jspDrag").bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _getTopPosition($ps) {
    return $ps.height() + 27;
  }

  function _getLeftPosition($ps) {
    return ($ps.outerWidth() / 2) - ($ps.find(".popover").outerWidth() / 2) - 1;
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    $ps.find(".popover").css({"top":(top) + "px", "left": left + "px"});
    $ps.find(".popover").fadeIn(data.settings.transitionSpeed, data.settings.easingMethod);
  }

  // Close popover
  function _close(data) {
    var $ps = data.$ps;
    $ps.removeClass("open");
    $ps.find(".popover").fadeOut(data.settings.transitionSpeed, data.settings.easingMethod);
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

  function _gotoSuccess(data) {

    data.$ps = _build(data, "success");
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

/*
* ====================
* NOTIFICATION POPOVER
* ====================
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
  store = "notification_selector",
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

      // Dont do anything if we've already setup notificationPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$handle = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
      }

      // Update the reference to $ps
      $ps = $(".notification_selector");

      $(this).click(_toggle);

      $(this).find("ul li a").bind('click', function(e) {
        window.location = $(this).attr('href');
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the notificationPopover data
      $this.data(store, data);
      $ps.data(store, data);

      $(window).bind(data.event, function() { _close(data); });
    });
  };

  // Expose the plugin
  $.fn.notificationPopover = function(method) {

		// Max height: 235px

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
    var $ps   = data.$ps;

    if ($ps.hasClass("open")) {
      _close(data);
    } else {
      $(".notification_selector").addClass("open");

      // reset the counter
      data.$handle.html(0);
      data.$handle.addClass("empty_count");
      data.$handle.removeClass("count");

      _addDefaultAction(data);
      _open(data);
      GOD.subscribe(data.event);
      GOD.broadcast(data.event);
    }
  }

  function _open(data) {
    var $ps = data.$ps;

		// Check height if it pass 230px nothing
		var h_ = $(".notification_selector ul").height();
		if (h_<230) {
			$(".notification_selector .popover").height(h_);
		}

    _triggerOpenAnimation($ps, data);
    $ps.find('.scroll-pane').jScrollPane();
    $ps.find("li.submit form").submit();

    $ps.find(".jspDrag").bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _getTopPosition($ps) {
    return $ps.height() + 12;
  }

  function _getLeftPosition($ps) {
    return $ps.offset().left;
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = 175;

    $(".notification_selector").css({"top":(top) + "px", "left": left + "px"});
    $(".notification_selector").find(".popover").fadeIn(data.settings.transitionSpeed, data.settings.easingMethod);
  }

  // Close popover
  function _close(data) {
    var $ps = data.$ps;
    $(".notification_selector").removeClass("open");
    $(".notification_selector").find(".popover").fadeOut(data.settings.transitionSpeed, data.settings.easingMethod);
  }

  function _addDefaultAction(data){
    data.$ps.unbind("click");
    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  $(function() { });

})(jQuery, window, document);


/*
* ============
* AREA EDITING
* ============
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
  store = "areas_editable_selector",
  // Public methods
  $popover,
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

      // Dont do anything if we've already setup enableAreaEditing on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
      }

      $popover = $(this);

      // Update the reference to $ps
      $ps = $('.' + store);

      $(this).find(".add_area a").click(_toggle);

      $popover.find('li form.remove').live('submit', function(e) {
        $(this).parent().fadeOut(250);
      });

      $popover.find('li input.remove').live('click', function(e) {
        var areaID = $(this).parents("li").attr("data-id");
        $ps.find("li[data-id='" + areaID + "']").removeClass("selected");
      });

      $ps.find('li form').bind('submit', function(e) {
        $(this).parent().addClass("selected");
      });

      $ps.find('li form').bind('ajax:success', function(e, response) {
        var $tag = $(response);
        $tag.hide();
        $popover.find(".add_area").before($tag);
        $tag.fadeIn(250);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the enableAreaEditing data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
      $(window).bind(data.event, function() { _close(data); });
    });
  };

  // Expose the plugin
  $.fn.enableAreaEditing = function(method) {
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

    var data  = $popover.data(store);
    var $ps   = data.$ps;

    if ($ps.hasClass("open")) {
      _close(data);
    } else {
      $ps.addClass("open");
      _open(data);
      GOD.subscribe(data.event);
      GOD.broadcast(data.event);
    }
  }

  function _open(data) {
    var $ps = data.$ps;


		// Check height if it pass 230px nothing
		var h_ = $ps.find("ul").height();

		if (h_ < 230) {
      $ps.find(".popover").height(h_);
		}

    _triggerOpenAnimation($ps, data);
    $ps.find('.scroll-pane').jScrollPane();

    $ps.find(".jspDrag").bind('click', function(e) {
      e.stopPropagation();
    });
  }

  function _getTopPosition(data) {
    return data.$this.find(".add_area").position().top + 25;
  }

  function _getLeftPosition(data) {
    return data.$this.find(".add_area").position().left - 45;
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition(data);
    var left = _getLeftPosition(data);

    $ps.css({"top":(top) + "px", "left": left + "px"});
    $ps.fadeIn(data.settings.transitionSpeed, data.settings.easingMethod);
  }

  // Close popover
  function _close(data) {
    var $ps = data.$ps;
    $ps.removeClass("open");
    $ps.find(".popover").fadeOut(data.settings.transitionSpeed, data.settings.easingMethod);
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





(function($, window, document) {

  var ie6 = false;

  // Help prevent flashes of unstyled content
  if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
    ie6 = true;
  } else {
    document.documentElement.className = document.documentElement.className + ' ps_fouc';
  }

  var
  $popover,
  spin_element = document.getElementById('publish_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  submitting = false,
  store = "event-popover",
  // Public methods
  methods = { },
  interval,
  lat,
  lng,
  geocoder,
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
        data.id = store;
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
        data.spinner = spinner;
      }

      $popover = $(this);

      // Update the reference to $ps
      $ps = $('#' + data.id);

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the enableLocationEditing data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      data.$submit = $ps.find(".bfooter .publish");

      $(this).click(_toggle);

      $(window).unbind();
      $(window).bind(data.event, function() { _close(true); });

      // bindings
      _addCloseAction();
      _addDefaultAction();
      _bindSubmit("Continuar", true, "continue");
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

    var data  = $popover.data(store);

    _initMap("editable_map", { lat: miniLat, lng: miniLng});

    LockScreen.show(function(){
      data.$ps.length ?  _open() : null;
    });
  }

  function _open() {
    var data = $popover.data(store);

    _bindSubmit("Continuar", true, "continue");

    _subscribeToEvent(data.event);
    _triggerOpenAnimation();
  }

  function textCounter($input, on, off) {
    var count = $input.val().length;

    if (count <= 0) {
      off && off();
    } else {
      on && on();
    }
  }

  function _resetSection($section) {
    var data = $popover.data(store);

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

  function _submitPublish() {
    var data = $popover.data(store);

    if (!_hasContent($currentSection)) return;
    _disableSubmit(data.$submit);
    _question() ?  _publishQuestion(data) : _publishProposal(data);
  }

  function _bindSubmit(title, initiallyDisabled, callback) {
    var data = $popover.data(store);

    _changeSubmitTitle(data.$submit, title);

    initiallyDisabled && _disableSubmit(data.$submit);

    data.$submit.unbind("click");
    data.$submit.click(function(e) {
      e.preventDefault();
      if (!$(this).hasClass('disabled')) {
        callback && _doCallback(callback);
      }
    });
  }

  function _doCallback(callback) {
    var data = $popover.data(store);

    var center = new google.maps.LatLng($('#event_location_latitude').val(),$('#event_location_longitude').val());

    // Change map
    editMiniMap(center);

    // Change text
    $('ul.location div.footer span.where').text($('#event_location_text').val());

    // Submit form
    $('#event_location').submit();

    // Close popover
    _close(true);
  }

  function _showMessage(kind, callback) {
    var data = $popover.data(store);

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
          _close(true);
        });

      });
    } else {
      $error.show();
      $success.hide();
    }

    var successHeight = $success.outerHeight(true);

    data.$ps.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, data.settings.transitionSpeed * 2, "easeInOutQuad", function() {
      IrekiaSpinner.stop();
      callback && callback();
    });
  }

  function _triggerOpenAnimation() {
    var data = $popover.data(store);

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

  function _initMap(mapID, opt) {
    var data = $popover.data(store);

    var
    maxZoom = (opt && opt.maxZoom) || 16,
    zoom    = (opt && opt.zoom)    || 12,
    lat     = (opt && opt.lat),
    lng     = (opt && opt.lng);

    var center  = new google.maps.LatLng(opt.lat, opt.lng);

    var latlng = center;
    var mapOptions = {
      maxZoom: maxZoom,
      zoom: zoom,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoomControl:       false,
      navigationControl: false,
      disableDefaultUI:  false,
      streetViewControl: false,
      mapTypeControl:    false,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.SMALL
      },
    };


    var addresspicker = data.$ps.find('.input_field input');
    var addresspickerMap = addresspicker.addresspicker({
      elements: {map: "#"+mapID},
      mapOptions: mapOptions,
      defaultAddress: $('#event_location_text').val() || ''
    });

    addresspicker.bind('autocompleteselect reversegeocode',function(ev,ui){
      ev.stopPropagation();
      ev.preventDefault();

      var position = addresspickerMap.addresspicker('marker').getPosition(),
          location = '';
      if (ui) {
        location = ui.item.formatted_address;
      } else {
        location = data.$ps.find('.input_field input').val();
      }

      $('#event_location_text').val(location);
      $('#event_location_latitude').val(position.lat());
      $('#event_location_longitude').val(position.lng());

      _enableSubmit(data.$submit);
    });

  }


  // Close popover
  function _close(hideLockScreen, callback) {
    var data = $popover.data(store);

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

  function _addCloseAction() {
    var data = $popover.data(store);
    data.$ps.find(".close").unbind("click");
    data.$ps.find(".close").bind('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      _close(true);
    });
  }

  function _addDefaultAction(){
    var data = $popover.data(store);
    data.$ps.unbind("click");
    data.$ps.bind('click', function(e) {
      e.stopPropagation();
    });
  }

  $(function() { });

})(jQuery, window, document);


/*
* Inline share popover
*/

(function($, window, document) {

  var ie6 = false;

  var
  store = "share-popover",
  // Public methods exposed to $.fn.inlineSharePopover()
  methods = {},
  // Some nice default values
  spinner,
  spin_element,
  defaults = {
    transitionSpeed: 120,
    easing:'easeInExpo'
  };

  // Called by using $('foo').inlineSharePopover();
  methods.init = function(settings) {
    settings = $.extend({}, defaults, settings);

    return this.each(function() {
      var
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},

      // This gets applied to the 'ps_container' element
      id = $this.attr('id'),

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup inlineSharePopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings  = settings;
        data.$sharebox = $(this).next(".sharebox");
        data.$submit   = $(this).parent().find(".sharebox.email").find('input[type="submit"]');
        data.$input    = $(this).parent().find(".sharebox.email").find('input[type="text"]');
      }

      // Update the reference to $ps
      $ps = $(this);

      data.$submit.unbind("click");

      data.$submit.click(function(e) {
        e.stopPropagation();

        if (isEmpty(data.$input.val())) {
          data.$input.parent().addClass("error");
          return;
        }

        spinner.spin(spin_element);

        $(this).fadeOut(data.settings.transitionSpeed);
        _shareWith($this.parent().find(".sharebox.email"), "email", data.settings.transitionSpeed, data.settings.easing, function() {
          _open(data);
        });
      });

      // Email sharing
      data.$sharebox.find(".share.email").bind('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        _close($this);
        _openEmail($this);
        _removeOk(data);
      });

      // Facebook sharing
      data.$sharebox.find(".share.facebook").bind('click', function(e) {
        e.stopPropagation();
        _close($this);
      });

      // Twitter sharing
      data.$sharebox.find(".share.twitter").bind('click', function(e) {
        e.stopPropagation();

          var width  = 611,
          height = 400,
          left   = 21,
          top    = 44,
          url    = this.href,
          opts   = 'status=1' + ',width='  + width  + ',height=' + height + ',top='    + top    + ',left='   + left;

          window.open(url, 'twitter', opts);
          _close($this);

          return false;
      });

      data.$sharebox.bind('click', function(e) {
        e.stopPropagation();
      });

      $this.click(_toggle);

      $(window).bind('_close.'+ data.id + '_email', function() {
        _closeEmail($this);
      });

      $(window).bind('_close.'+ data.id, function() {
        _close($this);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;
      $this.data(store, data);
      $ps.data(store, data);
    });
  };

  $(function() {
    var $el  = $(this).parents("li").find(".share.email");
    var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    spin_element = document.getElementById('share_via_email');
    spinner = new Spinner(opts);
  });

  // Expose the plugin
  $.fn.inlineSharePopover = function(method) {
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
    }
  };

  function _shareWith($el, service, speed, easing, callback) {
    var $form;

    function success(argument) {
      spinner.stop();
			$form.parent().fadeOut('fast',function(){
				$form.find('input[type="submit"]').fadeIn(speed);
	      $form.find('input[type="text"]').val("");
	      $form.find('.holder').fadeIn(speed);
	      callback && callback();
			});

      $ok = $('<div class="ok" />');
      $el.parents("li").find(".share.email").append($ok)
      $ok.animate({opacity:1, top:"-2px"}, speed, easing);

      return true;
    }

    function error(event, xhr, status) {
      spinner.stop();
      $form.find(".input_field").addClass("error");
      $form.find('input[type="submit"]').fadeIn(speed);
      return true;
    }

    function removeOk($ok) {
      $ok.animate({ opacity:0, top: "20px" }, speed, easing, function() {
        $(this).remove();
      })
    }

    removeOk($el.parents("li").find(".share.email .ok"), speed, easing);

    $form = $el.find("form");
    $form.unbind();
    $form.find(".input_field").removeClass("error");
    $form.bind('ajax:success', success);
    $form.bind('ajax:error', error);
  }

  function _resize($ps) {
    var $sharebox = $ps.next(".sharebox");
    if (!$sharebox.hasClass("email")) {
      var items = $sharebox.find("li").length;
      $sharebox.width(items * 35);
    }
  }

  function _removeOk(data) {
    var $ps = data.$ps;

    $ps.find(".ok").animate({ opacity:0, top: "20px" }, data.settings.transitionSpeed, data.settings.easingMethod, function() {
      $(this).remove();
    })
  }

  function _open(data) {

    var $ps = data.$ps;

      $ps.addClass("open");
      data.$sharebox.css({ left: data.$this.position().left - 3, top: data.$this.position().top - data.$sharebox.outerHeight(true) - 15 });
      data.$sharebox.fadeIn(data.settings.transitionSpeed);

      // setup the close event & signal the other subscribers
      var event = "_close."+data.id;
      GOD.subscribe(event);
      GOD.broadcast(event);
  }
  // Toggle popover
  function _toggle(e) {
    if (e) {
    e.preventDefault();
    e.stopPropagation();
    }

    var $this = $(this);
    var data = $this.data(store);
    var $ps = data.$ps;

    _resize($ps);

    if (!$ps.hasClass("open")) {
      $ps.addClass("open");
      data.$sharebox.css({ left: data.$this.position().left - 3, top: data.$this.position().top - data.$sharebox.outerHeight(true) - 15 });
      data.$sharebox.fadeIn(data.settings.transitionSpeed);
      _removeOk(data);

      // setup the close event & signal the other subscribers
      var event = "_close."+data.id;
      GOD.subscribe(event);
      GOD.broadcast(event);
    } else {
      _close($this);
    }
  }

  function _removeOk(data) {
    data.$ps.parent().find(".ok").animate({ opacity:0, top: "20px" }, data.settings.transitionSpeed, data.settings.easing, function() {
      $(this).remove();
    })
  }

  function _openEmail($this) {
    var data   = $this.data(store);
    var $email = data.$ps.parent().find(".sharebox.email");

    var event = "_close."+data.id;
    GOD.subscribe(event + "_email");
    GOD.broadcast(event + "_email");

    $email.click(function(e) {
      e.stopPropagation();
    });

    _removeOk(data);

    $email.css({ left: data.$this.offset().left - 82 - ($email.width() / 2) + (data.$this.width() / 2) , top: data.$this.position().top - $email.outerHeight(true) - 15 });
    $email.fadeIn(data.settings.transitionSpeed);
  }

  // Close email popover
  function _closeEmail($this) {
    var data = $this.data(store);

    var $email = data.$ps.parent().find(".sharebox.email");

    $email.fadeOut(data.settings.transitionSpeed);
  }
  // Close popover
  function _close($this) {
    var data = $this.data(store);

    data.$ps.removeClass("open");
    data.$sharebox.fadeOut(data.settings.transitionSpeed);
  }

  $(function() {});

})(jQuery, window, document);
