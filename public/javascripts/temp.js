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
  lng
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

      data.$submit = $ps.find("footer .publish");

      $(this).click(_toggle);

      $(window).unbind();
      $(window).bind(data.event, function() { _close(true); });

      // bindings
      _addCloseAction();
      _addDefaultAction();
      _bindSubmit(, true, "continue");
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

    try {
      lat = miniLat;
      lng = miniLng;
    } catch(err) {
      // Vitoria's coordinates
      lat = 42.85;
      lng = -2.683333;
    }

    var data  = $popover.data(store);

    _initMap("editable_map", { lat:lat, lng: lng});

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
      callback && _doCallback(callback);
    });
  }

  function _doCallback(callback) {

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
    zoom    = (opt && opt.zoom)    || 15,
    lat     = (opt && opt.lat)     || 80,
    lng     = (opt && opt.lng)     || 80;

    var center  = new google.maps.LatLng(opt.lat, opt.lng);

    var latlng = center;
    var myOptions = {
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

    map = new google.maps.Map(document.getElementById(mapID), myOptions);

    // zoomIn
    var zoomInControlDiv = document.createElement('DIV');
    var zoomInControl = new ZoomInControl(zoomInControlDiv, map);
    zoomInControlDiv.index = 1;
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(zoomInControlDiv);

    // zoomOut
    var zoomOutControlDiv = document.createElement('DIV');
    var zoomOutControl = new ZoomOutControl(zoomOutControlDiv, map);
    zoomOutControlDiv.index = 2;
    map.controls[google.maps.ControlPosition.LEFT].push(zoomOutControlDiv);

    var center = new google.maps.LatLng(lat, lng);

    var image = new google.maps.MarkerImage('/images/maps_sprite.png', new google.maps.Size(24, 34), new google.maps.Point(0,67), new google.maps.Point(12, 30));

    var marker = new google.maps.Marker({ position: center, map: map, icon: image, draggable: true });

    google.maps.event.addListener(marker, 'dragend', _dragEnd);

    var mapBounds = new google.maps.LatLngBounds();
    mapBounds.extend(center);
    map.fitBounds(mapBounds);
  }

  function _dragEnd(args) {
    var data = $popover.data(store);
    _enableSubmit(data.$submit);
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
