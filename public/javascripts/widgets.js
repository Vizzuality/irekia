/*
* LockScreen Systems Inc.
*/
var LockScreen = (function() {

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

  function _show(callback) {
    if (!_isLocked()) {
      $("body").append("<div id='lock_screen'></div>");
      $("#lock_screen").height($(document).height());
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

  $(function() {
    $(document).keyup(function(e) {
      e.keyCode == 27 && _signalAll();
    });

    $('html').click(_signalAll);
  });

  return {
    subscribe: subscribe,
    unsubscribe: unsubscribe,
    broadcast: broadcast
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
      $ps.fadeIn(data.settings.transitionSpeed);
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
  defaults = {
    transitionSpeed: 200,
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
      id = $this.attr('class').replace(" ", "_");

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup sharePopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
      }

      // Update the reference to $ps
      $ps = $(this);

      $ps.next(".sharebox.email").find('input[type="submit"]').click(function(e) {
        e.stopPropagation();
        var $el = $(this).parents("li").find(".share.email");
        shareWith($el, "email", data.settings.transitionSpeed, data.settings.easing);
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

  function _resize($ps) {
    var $sharebox = $ps.next(".sharebox");
    if (!$sharebox.hasClass("email")) {
      var items = $sharebox.find("li").length;
      $sharebox.width(items * 35);
    }
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

  var ie6 = false;

  // Help prevent flashes of unstyled content
  if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
    ie6 = true;
  } else {
    document.documentElement.className = document.documentElement.className + ' ps_fouc';
  }

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
      }

      $(this).find(".filter").unbind("click");
      $(this).find(".filter").bind('click', function(e) {
        e.preventDefault();

        // Place spinner and show it (if exists)
        filter_spinner.stop();
        filter_spinner.spin();

        var top = $(this).position().top;
        $(filter_spinner.el).css({ top:top+8+"px", position:"absolute", right:'3px', height:'15px', width:'15px' });
        $(this).closest('div.right').append(filter_spinner.el);

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
        console.log(data.url, data.sort, data.filter);

        var settings = data.settings;

        $.ajax({ url: data.url, data: data.sort, type: "GET", success: function(data){
          $ps.find("#listing").fadeOut(settings.transitionSpeed, function() {

            if ($(data).find("li").length < 1) {
              $ps.find("#listing").html('<span class="empty">No hay contenido en este area</span>'); // TODO: We shouldn't use non localized strings here
            } else {
              $ps.find("#listing").html(data);
            }

            $ps.find("#listing").slideDown(settings.transitionSpeed, function() {
              filter_spinner.stop();
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
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
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
    }
  }

  function _open(data) {
    var $ps = data.$ps;

    _triggerOpenAnimation($ps, data);
    $ps.find('.scroll-pane').jScrollPane();

    console.log($ps.find(".jspDrag"));
    $ps.find(".jspDrag").bind('click', function(e) {
      e.stopPropagation();
    });

    // $ps.find('.scroll-pane .jspPane').animate({top:"-300px"}, 500);
    // $ps.find('.scroll-pane .jspDrag').animate({top:"100px"}, 500);
  }

  function _getTopPosition($ps) {
    return $ps.height() + 17;
  }

  function _getLeftPosition($ps) {
    return $ps.width() - 180;
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

