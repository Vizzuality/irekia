/*
* ================
* PROPOSAL POPOVER
* ================
*/

(function($, window, document) {

  var ie = ($.browser.msie && $.browser.version.substr(0, 1) < 9);

  var spin_element = document.getElementById('proposal_spinner'),
  spinner      = new Spinner(SPINNER_OPTIONS),
  templates = {
   success: ['<div id="<%= name %>_<%= id %>" class="article mini with_icon popover with_footer">',
   '  <div class="inner">',
   '    <span class="close"></span>',
   '    <%= content %> ',
   '  </div>',
   '  <div class="bfooter">',
   '  <div class="separator"></div>',
   '  <div class="inner">',
   '    <a href="#" class="white_button pink close right"><span>Aceptar</span></a>',
   '  </div>',
   '  </div>',
   '  <div class="t"></div><div class="f"></div>',
   '</div>'].join(' ')
  },
  store = "proposal-popover",
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
      // The current element
      $this = $(this),

      // We store lots of great stuff using jQuery data
      data = $this.data(store) || {},

      // This gets applied to the 'ps_container' element
      id = $this.attr('id') || $this.attr('name'),

      // This gets updated to be equal to the longest <option> element
      width = settings.width || $this.outerWidth(),

      // The completed ps_container element
      $ps = false;

      // Dont do anything if we've already setup proposalPopover on this element
      if (data.id) {
        return $this;
      } else {
        data.id = id;
        data.$this = $this;
        data.settings = settings;
        data.templates = templates;
        data.name = store;
        data.event = "_close." + store + "_" + id;
        data.spinner = spinner;
      }

      // Update the reference to $ps
      $ps = $('#' + store + "_" + id);

      $(this).click(_toggle);

      !ie && $(window).bind(data.event, function() { _close(data, true); });

      // Save the updated $ps reference into our data object
      data.$ps = $ps;

      // Save the proposalPopover data
      $this.data(store, data);
      $ps.data(store, data);

      // Autolaunch of the widget
      if (settings.open == true) {
        data.id = data.name;
        _open(data);
      }

    });
  };

  // Expose the plugin
  $.fn.proposalPopover = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    }
  };

  function _build(data, response, templateName, extraParams) {
    var params = _.extend({id:data.id + "_success", name:data.name, content:response }, extraParams);
    var $ps = $(_.template(data.templates[templateName], params ));
    return $ps;
  }

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

  function _setupBindings(data) {
    _addCloseAction(data);
    _addSubmitAction(data);
    !ie && _addDefaultAction(data);
    _setupUpload(data, "upload_image");
    _subscribeToEvent(data.event);

    _bindSearch(data);

    // Remove image link
    data.$ps.find(".image_container a.remove").unbind();
    data.$ps.find(".image_container a.remove").bind("click", function(e) { _resetImageContainer(e, data); } );

    data.$ps.find("textarea.grow").autogrow();
    data.$ps.find(".input-counter").inputCounter({limit:data.settings.maxLimit});
  }

  function _open(data) {
    data.$ps = $(document).find(".article#" + data.id);
    _setupBindings(data);
    _triggerOpenAnimation(data.$ps, data);
  }

  function _resetImageContainer(e, data) {
    e.preventDefault();

    var
    $ps = data.$ps,
    $image_container = $ps.find(".image_container");

    $image_container.fadeOut(data.settings.transitionSpeed, function() {
      $image_container.find("img").remove();
      $ps.find(".uploader").show();
      $image_container.find(".holder").show();
      $ps.find(".loading").hide();
      $ps.find(".percentage").hide();
      $ps.find(".progress").css("width", "0");
      _center(data);
    });
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

      $ps.css({"top":(top + 100) + "px", "left": left + "px"});

      $ps.animate({opacity:1, top:top}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function() {
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

  function _afterClosingSetup($ps) {
    $ps.find("textarea").val("");
    $ps.find(".counter").html(140);
    if ($ps.find("input.search").length > 0 &&  isEmpty($ps.find("input.search").val())) $ps.find(".holder").fadeIn(100);
    _disableSending($ps);
    $ps.find(".extra").fadeOut(100);
    $ps.find(".bfooter .action").unbind();
  }

  function _enableSending($ps) {
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

  function _close2(data, hideLockScreen, callback) {
    if (ie) {
      data.$ps.fadeOut(data.settings.transitionSpeed, function() {
        $(this).remove();
        _afterClosingSetup(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {

      data.$ps.animate({opacity:.5, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $(this).remove();
        _afterClosingSetup(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }

  // Close popover
  function _close(data, hideLockScreen, callback) {
    if (ie) {
      data.$ps.fadeOut(data.settings.transitionSpeed, function() {
        _afterClosingSetup(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      });
    } else {
      data.$ps.animate({opacity:0, top:data.$ps.position().top - 100}, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }, complete: function(){
        $(this).css("top", "-900px");
        _afterClosingSetup(data.$ps);
        hideLockScreen && LockScreen.hide();
        callback && callback();
      }});
    }
  }


  // setup the close event & signal the other subscribers
  function _subscribeToEvent(event) {
    GOD.subscribe(event);
    GOD.broadcast(event);
  }

  function _center(data) {
    var top  = _getTopPosition(data.$ps);
    data.$ps.animate({ top:top }, { duration: data.settings.transitionSpeed, specialEasing: { top: data.settings.easingMethod }});
  }

  function _enableSubmitAction(data) {
    data.$ps.find("form").die();

    data.$ps.find(".bfooter .action").click(function(e) {
      spinner.spin(spin_element);
      data.$ps.find("form").submit();
      _disableSending(data.$ps);
    });

    data.$ps.find("form").live('ajax:success', function(event, response, status) {
      spinner.stop();
      _enableSending(data.$ps);
      _close(data, false, function() {
        _gotoSuccess(data, response);
      });
    });

    data.$ps.find("form").live('ajax:error', function(event, response, status) {
      spinner.stop();
      _enableSending(data.$ps);
    });
  }

  function _addSubmitAction(data) {
    data.$ps.find(".bfooter .action").click(function(e) {
      e.preventDefault();
      data.$ps.find(".extra").slideDown(data.settings.transitionSpeed, function() {
        _center(data);
        _enableSubmitAction(data); // After the user shows the extra options, we enable the real submit
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

  function _clearAutosuggest($ps) {
    $ps.find(".autosuggest").fadeOut(100, function() {
      $(this).remove();
    });
  }

  function _resetHiddenFields($ps) {
    $("#proposal_proposal_data_attributes_area_id").val("");
    _disableSending($ps);
  }

  function _bindSearch(data) {
    var $ps = data.$ps;

    _enableInputCounter(data, $(".autosuggest_field input"), null, function() { _clearAutosuggest($ps); _resetHiddenFields($ps); } );

    $ps.find('.autosuggest_field input').keyup(function(ev){

      if (_.any([8, 13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return ev.keyCode == i} )) { return; }

      clearTimeout(interval);

      if ($(this).val().length > 3) {
        interval = setTimeout(function(){

          var query = $ps.find('.extra .autosuggest_field input[type="text"]').val();

          data.spinner.spin(spin_element);

          var params = { name : query };

          params = $.extend(params, { only_areas : true} );

          $.ajax({ url: "/search/politicians_and_areas", data: { search: params }, type: "GET", success: function(response) {

            var $response = $(response);

            data.spinner.stop();

            // When the user clicks on a result…
            $response.find("li").unbind();
            $response.find("li").bind("click", function(e) {
              var id = $(this).attr("id");
              var name = $(this).find(".name").html();

              $ps.find('.autosuggest_field input[type="text"]').val(name);
              $ps.find('#proposal_proposal_data_attributes_area_id').val(id.replace("item_", ""))

              if (!isEmpty($ps.find("textarea.title").val())) {
                _enableSending(data.$ps);
              }

              _clearAutosuggest($ps);
            });

            $ps.find(".autosuggest").fadeOut(150, function() {
              $(this).remove();
            });

            if ($response.find("li").length > 0) {
              $response.hide();
              $response.addClass("small");

              $response.css("top", 0);

              $ps.find('.content').append($response);

              $response.fadeIn(150);

               var h_ = $response.find("ul").height();

               if (h_< 160) {
                 $response.find(".popover").height(h_);
               } else {
                 $ps.find('.scroll-pane').jScrollPane();
                 $ps.find(".jspDrag").bind('click', function(e) {
                   e.stopPropagation();
                 });
               }
            }
          }});

        }, 500);
      }
    });
  }



  function _setupUpload(data, id) {

    var $ps = data.$ps,
				$span  = $ps.find("#" + id);

    if ($span.length > 0) {

      var speed = data.settings.transitionSpeed;
      var $uploader = $ps.find(".uploader");

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: $span.attr('data-url'),
				params: {
					utf8: $span.closest('form').find('input[name=utf8]').val(),
					authenticity_token: $span.closest('form').find('input[name=authenticity_token]').val()
				},
        debug: true,
        text:$span.html(),
        onSubmit: function(id, fileName){
          data.spinner.spin(spin_element);
          //console.log($ps, $ps.find(".uploader").find(".holder").fadeOut(speed));
					$ps.find(".progress").show();
          $uploader.find(".percentage").css("color", "#FF0066");
          $uploader.find(".holder").fadeOut(speed);
          $uploader.find(".loading, .percentage").fadeIn(speed);
        },
        onProgress: function(id, fileName, loaded, total){
					var p = ((parseFloat(arguments[2]) / parseFloat(arguments[3])) * 100);
					var width = parseInt(534 * parseInt(p, 10) / 100, 10);

					console.debug(p, width, arguments, arguments[2], arguments[3]);

					if (parseInt(p) >= 75) $ps.find(".uploader").find(".loading").fadeOut(speed);
					if (parseInt(p) >= 46) $ps.find(".uploader").find(".percentage").css("color", "#fff");

          $uploader.find(".percentage").html(parseInt(p, 10) + "%");
				  $ps.find(".progress").css("width", width);
				},
        onComplete: function(id, fileName, responseJSON){
          data.spinner.stop();

					console.debug(fileName, responseJSON, responseJSON.image_cache_name);
          $uploader.find(".loading").fadeOut(speed);
          $uploader.find(".percentage").fadeOut(speed);

          var cacheImage = document.createElement('img');
          cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;
					$ps.find('.image_cache_name').val(responseJSON.image_cache_name);

          $(cacheImage).bind("load", function () {
            $ps.find(".image_container").prepend(cacheImage);
            $ps.find(".image_container").fadeIn(speed);
            $ps.find(".image_container img").fadeIn(speed);
            _center(data);

            $uploader.fadeOut(speed, function() {
              $uploader.find(".holder").fadeIn(speed);
            });
          });

          $uploader.find(".progress").fadeOut(speed, function() {
            $(this).width(0);
          });
				},
        onCancel: function(id, fileName){ }
      });
    }
  }

  function _gotoSuccess(data, response) {

    data.$ps = _build(data, response, "success");
    var $ps  = data.$ps;

    _addCloseAction2(data);
    _addDefaultAction(data);

    LockScreen.showIfHidden();

    $("#container").prepend($ps);
    _subscribeToEvent(data.event);
    _triggerOpenAnimation($ps, data);

    $ps.find(".input-counter").inputCounter();
  }

  $(function() { });

})(jQuery, window, document);
