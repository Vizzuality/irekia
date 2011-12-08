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

      // Dont do anything if we've already setup inlineSharePopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$handler = $this;
        data.settings = settings;
        data.$sharebox = $(this).next(".sharebox");
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

      data.$sharebox.find(".share.twitter").bind('click', function(e) {
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


      data.$sharebox.bind('click', function(e) {
        e.stopPropagation();
      });

      $(this).click(_toggle);

      $(window).bind('_close.'+ data.id, function() {
        _close($this);
      });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the inlineSharePopover data onto the <select> element
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
  $.fn.inlineSharePopover = function(method) {
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

    if (!$ps.hasClass("open")) {
      $ps.addClass("open");
      data.$sharebox.css({ left: data.$handler.position().left, top: data.$handler.position().top - data.$sharebox.outerHeight(true) - 15 });
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

  // Close popover
  function _close($this) {
    var data = $this.data(store);

    data.$ps.removeClass("open");
    data.$sharebox.fadeOut(data.settings.transitionSpeed);
  }

  $(function() {});

})(jQuery, window, document);

