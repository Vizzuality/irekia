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
        data.$this = $this;
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
    return $ps.height() + 17;
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
jQuery.fn.enablePoliticianPublish = function(opt){

  if (this.length < 1) return;

  var
  section       = 0,
  speed         = 250,
  sectionWidth  = 687,
  $article      = $(this),
  currentHeight = 0,
  $currentSection,
  $submit = $article.find("footer .publish"),
  spin_element = document.getElementById('publish_spinner'),
  submitting = false;

  // Initialize the initial section
  $currentSection = $article.find(".container .section:nth-child(1)");


  function _setupUpload(id) {
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

  function _bindActions() {

    _setupUpload("upload_proposal");
    _setupUpload("upload_image");

    $article.find(".section .open_upload").click(function(e) {
      e && e.preventDefault();
      $(this).closest("input[type='file']").click();
    });

    $article.find(".section.video li").click(function(e) {
      e && e.preventDefault();

      $(this).siblings("li").removeClass("selected");
      $(this).addClass("selected");
      $article.find(".radio.selected").removeClass("selected");
      $(this).find(".radio").addClass("selected");
    });

    $article.find("a.radio").click(function(e) {
      e && e.preventDefault();
      $article.find(".section.video li").toggleClass("selected");
    });
  }

  function _showMessage(kind) {
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

    $article.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, speed * 2, "easeInOutQuad", function() {
      IrekiaSpinner.stop();
      _enableSubmit();
    });
  }

  function _enableSubmit() {
    submitting = false;
    $submit.removeAttr('disabled');
    $submit.removeClass("disabled");
  }

  function _disableSubmit() {
    submitting = true;
    $submit.attr("disable", "disable");
    $submit.addClass("disabled");
  }


  // Initi
  _bindActions();

  this.each(function(){
    $submit.click(function(e) {
      e && e.preventDefault();
      _disableSubmit();
      _showMessage("success");
    });

    $(this).find("ul.menu li a").click(function(e) {
      if (submitting) return;

      e && e.preventDefault();

      $(this).parents("ul").find("li").removeClass("selected");
      $(this).parent().addClass("selected");

      section  = $(this).parent().index();
      $section = $(this).parents(".content").find(".container .section:nth-child(" + (section + 1) + ")");

      if ($currentSection) {

        currentHeight = $currentSection.find(".form").outerHeight(true) + 20;

        $article.find(".container").animate({scrollTop: 0, height:currentHeight}, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;
          var height = $section.find(".form").outerHeight(true) + 20;
          $article.find(".container").animate({scrollLeft:section * sectionWidth, height:height}, speed, "easeInOutQuad");
        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $article.find(".container").animate({scrollTop: 0, scrollLeft:section * sectionWidth, height:height}, speed, "easeInOutQuad");
      }

    });
  })
}
*/




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
        data.$this = $this;
        data.settings = settings;
        data.name = store;
        data.event = "_close." + store;
      }

      // Update the reference to $ps
      $ps = $(this);

      $(this).click(_toggle);

      $(this).find("ul li a").bind('click', function(e) {
        window.location = $(this).attr('href');
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the notificationPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
      $(window).bind(data.event, function() { _close(data); });
    });
  };

  // Expose the plugin
  $.fn.notificationPopover = function(method) {
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
    console.log($ps);

    if ($(".notification_selector").hasClass("open")) {
      _close(data);
    } else {
      $(".notification_selector").addClass("open");
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
    return $ps.height() + 17;
  }

  function _getLeftPosition($ps) {
    return $ps.offset().left;
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = 213;

    $(".notification_selector").css({"top":(top) + "px", "left": left + "px"});
    $(".notification_selector").find(".popover").fadeIn(data.settings.transitionSpeed, data.settings.easingMethod);
  }

  // Close popover
  function _close(data) {
    var $ps = data.$ps;
    $(".notification_selector").removeClass("open");
    $(".notification_selector").find(".popover").fadeOut(data.settings.transitionSpeed, data.settings.easingMethod);
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
