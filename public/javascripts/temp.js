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
      '          <p class="remember_me"><input name="user[remember_me]" type="hidden" value="0" /><input id="floating_user_remember_me" name="user[remember_me]" type="checkbox" value="1" /> <label class="remember_me" for="floating_user_remember_me">Recordar mis datos</label></p>',
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
      '          <input type="submit" value="Entra" class="white_button right" />',
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
    maxLimit: 140,
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
      _close(data, true);
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
