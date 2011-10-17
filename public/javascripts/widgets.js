/*
* GOD sees everything
*/
var GOD = (function() {
  var subscribers = {};
  var debug = false;

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
    GOD.unsubscribe("_close."+data.id);
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
      id = "sign_in"

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

      // Save the loginPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);
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
    } else {

      _close($this);
    }
  }

  // Close popover
  function _close($this) {
    var data = $this.data(store);
    GOD.unsubscribe("_close."+data.id);
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
* ================
* QUESTION POPOVER
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
  var templates = {
    main:['<article id="<%= name %>_<%= id %>" class="mini popover with_footer" >',
   '  <form action="">',
   '    <div class="inner">',
   '      <header><h2><%= title %></h2></header>',
   '      <div class="content">',
   '        <p><%= description %></p>',
   '        <h3><%= your_question %></h3>',
   '        <div id="<%= id %>" class="input-counter">',
   '          <span class="counter"><%= maxLimit %></span>',
   '          <textarea name=""></textarea>',
   '        </div>',
   '       </div>',
   '      <span class="close"></span>',
   '    </div>',
   '    <footer>',
   '    <div class="separator"></div>',
   '    <div class="inner">',
   '      <input type="submit" value="Enviar pregunta" id="submit-<%= id %>" class="disabled white_button right" disabled="disabled" />',
   '    </div>',
   '    </footer>',
   '    <div class="t"></div><div class="f"></div>',
   '  </form>',
   '  </article>'].join(''),
   success: ['<article id="<%= name %>_<%= id %>" class="mini with_icon popover with_footer">',
   '  <div class="inner">',
   '    <div class="icon success"></div>',
   '    <div class="content">',
   '      <h2>Tu pregunta ha sido enviada</h2>',
   '      <p>En cuanto nuestros moderadores la aprueben, te notificaremos su publicación mediante email.</p>',
   '    </div>',
   '    <span class="close"></span>',
   '  </div>',
   '  <footer>',
   '  <div class="separator"></div>',
   '  <div class="inner">',
   '    <a href="#" class="white_button close right">Aceptar</a>',
   '  </div>',
   '  </footer>',
   '  <div class="t"></div><div class="f"></div>',
   '</article>'].join(' ')
  };

  var
  store = "question-popover",
  // Public methods
  methods = { },
  // Default values
  defaults = {
    easingMethod:'easeInOutQuad',
    transitionSpeed: 200,
    maxLimit: 140
  };

  // Called by using $('foo').questionPopover();
  //
  //


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

      $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the questionPopover data onto the <select> element
      $this.data(store, data);

      // Do the same for the dropdown, but add a few helpers
      $ps.data(store, data);

      // Autolaunch of the widget
      if (settings.open == true) {
        var $ps   = $('#' + data.name + "_" + data.id);
        _open(data);
      }

    });
  };

  // Expose the plugin
  $.fn.questionPopover = function(method) {
    if (!ie6) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === 'object' || !method) {
        return methods.init.apply(this, arguments);
      }
    }
  };

  function _build(data, templateName, extraParams) {
    var params = _.extend({id:data.id + "_success", name:data.name}, extraParams);

    var $ps = $(_.template(data.templates[templateName], params ));

    return $ps;
  }

  function _toggleLockScreen(callback) {
    var $lock_screen = $("#lock_screen");

    if ($lock_screen.length) {
      $lock_screen.fadeOut(150, function() { $(this).remove(); });
    } else {
      $("body").append("<div id='lock_screen'></div>");
      $("#lock_screen").height($(document).height());
      $("#lock_screen").fadeIn(150, function() {
        callback();
      });
    }
  }

  // Toggle popover
  function _toggle(e) {
    if (e) {
      e.preventDefault();
      e.stopPropagation();
    }

    var data  = $(this).data(store);
    var $ps   = $('#' + data.name + "_" + data.id);

    _toggleLockScreen(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _open(data) {
    data.$ps = $(document).find("article#" + data.id);
    var $ps = data.$ps;

    // bindings
    _addCloseAction(data);
    _addSubmitAction(data);
    _addDefaultAction(data);

    //$("#container").prepend($ps);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
    $ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }

  function _triggerOpenAnimation($ps, data) {
    var top  = _getTopPosition($ps);
    var left = _getLeftPosition($ps);

    console.log("open", data, $ps);
    $ps.css({"top":(top + 100) + "px", "left": left + "px"});

    $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
  }

  function _getTopPosition($ps) {
    return (($(window).height() - $ps.height()) / 2) + $(window).scrollTop();
  }

  function _getLeftPosition($ps) {
    return (($(window).width() - $ps.width()) / 2);
  }

  function _close2(data, hideLockScreen, callback) {
    GOD.unsubscribe(data.event);

    data.$ps.animate({opacity:.5, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      $(this).remove();
      hideLockScreen && _toggleLockScreen();
      callback && callback();
    }});
  }
  // Close popover
  function _close(data, hideLockScreen, callback) {
    GOD.unsubscribe(data.event);

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      hideLockScreen && _toggleLockScreen();
      callback && callback();
    }});
  }

  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
    GOD.broadcast(event);
  }

  function _addSubmitAction(data) {

    data.$ps.find("form").die();
    data.$ps.find("form").live('ajax:success', function(event, xhr, status) {
      //$(this).append(xhr.responseText)
      _close(data, false, function() {
        _gotoSuccess(data);
      });
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
    GOD.unsubscribe("_close."+data.id);
    data.$ps.removeClass("open");
    data.$ps.next(".sharebox").fadeOut(data.settings.transitionSpeed);
  }

  $(function() {});

})(jQuery, window, document);


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
  var templates = {
    main:['<article id="<%= name %>_<%= id %>" class="micro popover with_footer" >',
      '    <form accept-charset="UTF-8" action="/users/sign_in" class="user_new" id="user_new" method="post" novalidate="novalidate"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="mOoFPTs9xQUTOTplStCotWba1+xiF4SX6/vYt12YNPY=" /></div>',
      '      <div class="inner">',
      '        <div class="content">',
      '          <h2>Accede a Irekia</h2>',
      '          <p>¿Olvidaste tu contraseña? <a href="#" class="recover-password">Recupérala aquí</a></p>',
      '          <p><label for="user_email">Email</label><br />',
      '            <input class="mInput" id="user_email" name="user[email]" size="30" type="email" value="" /></p>',
      '          <p><label for="user_password">Contraseña</label><br />',
      '            <input class="mInput" id="user_password" name="user[password]" size="30" type="password" /></p>',
      '          <p class="remember_me"><input name="user[remember_me]" type="hidden" value="0" /><a class="selected checkbox">Recordar mis datos</a></p>',
      '        </div>',
      '      </div>',
      '      <span class="close"></span>',
      '      <footer>',
      '      <div class="separator"></div>',
      '      <div class="inner">',
      '        <div class="left">',
      '          <a href="/users/auth/facebook" class="facebook" id="facebook_signin">Facebook</a>',
      '          <a href="/users/auth/twitter" class="twitter" id="twitter_signin">Twitter</a>',
      '        </div>',
      '        <div class="right">',
      '          <input type="submit" value="Entra" id="login" class="login white_button right" />',
      '        </div>',
      '      </div>',
      '      </footer>',
      '      <div class="t"></div><div class="f"></div>',
      '    </form>',
      '   </article>'].join(''),
      password: ['<article id="<%= name %>_<%= id %>" class="micro popover with_footer">',
        '  <form accept-charset="UTF-8" action="/users/sign_in" class="user_new" id="user_new" method="post" novalidate="novalidate">',
        '    <div class="inner">',
        '      <div class="content">',
        '        <h2>Introduce tu email</h2>',
        '        <p>y te mandaremos instrucciones para recuperar tu contraseña</p>',
        '        <p><label for="user_email">Tu email</label><br />',
        '        <input class="mInput email" id="user_email" name="user[email]" size="30" type="email" value="" /></p>',
        '      </div>',
        '    </div>',
        '    <span class="close"></span>',
        '    <footer>',
        '    <div class="separator"></div>',
        '    <div class="inner">',
        '      <input type="submit" value="Recuperar contraseña" class="white_button right" />',
        '    </div>',
        '    </footer>',
        '    <div class="t"></div><div class="f"></div>',
        '  </form>',
        '</article>'].join(' ')
  };

  var
  store = "question-popover",
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
        data.templates = templates;
        data.name = store;
        data.event = "_close." + store + "_" + id;
      }

      // Update the reference to $ps
      $ps = $('#' + store + "_" + id);

      _setupCallback(data, $this.attr('class'));

      $(this).click(_toggle);
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

  function _build(data, templateName, extraParams) {
    var params = _.extend({id:data.id, name:data.name}, extraParams);

    var $ps = $(_.template(data.templates[templateName], params ));
    return $ps;
  }

  function _toggleLockScreen(callback) {
    var $lock_screen = $("#lock_screen");

    if ($lock_screen.length) {
      $lock_screen.fadeOut(150, function() { $(this).remove(); });
    } else {
      $("body").append("<div id='lock_screen'></div>");
      $("#lock_screen").height($(document).height());
      $("#lock_screen").fadeIn(150, function() {
        callback();
      });
    }
  }

  // Toggle popover
  function _toggle(e) {
    e.preventDefault();
    e.stopPropagation();

    var data  = $(this).data(store);
    var $ps   = $('#' + data.name + "_" + data.id);

    _toggleLockScreen(function(){
      $ps.length ?  null : _open(data);
    });
  }

  function _setupCallback(data, classes) {
    if (classes.indexOf("question") != -1) {
      data.callback = "question";
    }
  }

  function _open(data) {
    data.$ps = _build(data, "main", {title:"Haz una pregunta", description:"Recuerda ser breve y conciso. Así te asegurarás una respuesta en menos tiempo.", your_question:"Tu pregunta", maxLimit:data.settings.maxLimit});
    var $ps = data.$ps;

    // bindings
    _addCloseAction(data);
    _addSubmitAction(data);
    _addPassworRecoverAction(data);
    _addDefaultAction(data);

    $("#container").prepend($ps);

    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);
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

  // Close popover
  function _close(data, hideLockScreen, callback) {
    GOD.unsubscribe(data.event);

    data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
      data.$ps.remove();
      hideLockScreen && _toggleLockScreen();
      callback && callback();
    }});
  }

  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
    GOD.broadcast(event);
  }

  function _addSubmitAction(data) {
    data.$ps.find('input[type="submit"]').bind('click', function(e) {
      e.preventDefault();
      e.stopPropagation();

      var $el = $(this);

      if (data.callback) {
        _close(data, false, function() {
          $el.questionPopover({open:true});
        });

      } else {
        _close(data, true);
      }

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

    data.$ps = _build(data, template);
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
        data.sort = {};
      }

      var $ps = $(this);


      // Let's create the spinner dom element
      if ($(this).find('div.right ul.selector').length>0) {
        var filter_spinner = new Spinner({lines: 12,length: 0,width: 3,radius: 6,color: 'white',speed: 1,trail: 100,shadow: false});
      }


      $(this).find(".filter").bind('click', function(e) {
        e.preventDefault();

        // Positionate spinner and show it (if exists)
        filter_spinner.stop();
        filter_spinner.spin();
        var top = $(this).position().top;
        $(filter_spinner.el).css({top:top+8+"px",position:"absolute",right:'3px',height:'15px',width:'15px'});
        $(this).closest('div.right').append(filter_spinner.el);


        var classes = $(this).attr("class");
          data.filter = $(this).attr("href");

        if (classes.indexOf("recent") != -1) {
          data.sort = {};
        }
        else if (classes.indexOf("polemic") != -1) {
          data.sort = { more_polemic:true };
        }
        else if (classes.indexOf("type") != -1) {
          data.filter = $(this).attr("href");
        }

        $(this).parents("ul").find("li").removeClass("selected");
        $(this).parent().addClass("selected");

        $.ajax({ url: data.filter, data: data.sort, type: "GET", success: function(data){
          $ps.find("#listing").slideUp(250, function() {
            if (data.length<12) {
              $ps.find("#listing").html('<span class="empty">No hay contenido en este area</span>');
            } else {
              $ps.find("#listing").html(data);
            }
            $ps.find("#listing").slideDown(250, function() {
              filter_spinner.stop();
            });
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

