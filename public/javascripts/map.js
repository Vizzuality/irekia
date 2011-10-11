var map;

$(function() {
  if ($("#map_canvas").length) startMap();
});

function ZoomInControl(controlDiv, map) {
  controlDiv.setAttribute('class', 'zoom_in');

  google.maps.event.addDomListener(controlDiv, 'mousedown', function() {
    map.setZoom(map.getZoom() + 1);
  });
};

function ZoomOutControl(controlDiv, map) {
  controlDiv.setAttribute('class', 'zoom_out');

  google.maps.event.addDomListener(controlDiv, 'mousedown', function() {
    map.setZoom(map.getZoom() - 1);
  });
};

function toggleBounce() {
  if (marker.getAnimation() != null) {
    marker.setAnimation(null);
  } else {
    marker.setAnimation(google.maps.Animation.BOUNCE);
  }
}


function startMap () {
  var center = new google.maps.LatLng(59.327383, 18.07747);
  var defaultZoom = 15;
  var latlng = center;
  var myOptions = {
    zoom: defaultZoom,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    navigationControl: false,
    disableDefaultUI: false,
    scrollwheel: false,
    streetViewControl: false,
    mapTypeControl: false,
    navigationControlOptions: {
      style: google.maps.NavigationControlStyle.SMALL
    },
    maxZoom: 158
  };

  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

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

	var mapBounds = new google.maps.LatLngBounds();

  function addPoints() {
		for (var i = 0; i < events.length; i++) {
			var event = events[i][0];
			var events_data = events[i];
			var center = new google.maps.LatLng(event.lat, event.lon);
			new IrekiaMarker(center, events_data, map);
			mapBounds.extend(center);
		};
  }

  addPoints();
	map.fitBounds(mapBounds);
}

function IrekiaMarker(_latlng, _info, _map) {
  this.latlng = _latlng;
  this.info = _info;
  this.map = _map;

  this.offsetVertical_ = -12;
  this.offsetHorizontal_ = -13;
  this.width = 25;
  this.height = 34;
  this.setMap(this.map);
}

IrekiaMarker.prototype = new google.maps.OverlayView();

IrekiaMarker.prototype.draw = function() {

  var me = this;
  var num = 0;

  var div = this.div_;
  if (!div) {
    div = this.div_ = document.createElement('DIV');
    $(div).addClass('marker');
    div.style.position = "absolute";
    div.style.width = '25px';
    div.style.height = '25px';

    var templates = {
      marker:[
        '  <a class="marker<%= (count > 1) ? " with_counter" : "" %>">',
        '   <% if (count > 1) {%>',
          '   <div class="counter"><%= count %></div> ',
          ' <% } %>',
          '</a>'].join(''),
          event:[
            '    <li>',
            '      <strong class="date"><%= date %></strong>',
            '      <a href="#" class="event"><%= title %></a>',
            '      <ul class="details">',
            '        <li class="where"><%= where %></li>',
            '        <li class="when"><%= when %></li>',
            '      </ul>',
            '      <% if (separator) { %>',
              '        <div class="separator"></div>',
              '      <% } %>',
              '    </li>',
          ].join(' '),
          infowindow:[
            '<div class="info infowindow<%= (count > 1) ? \" large\" : \"\" %>">',
            '<% if (count > 1) {%>',
              '<div class="scroll-pane">',
              '<% } %>',
              '  <ul class="events">',
              '  <%= events %>',
              '  </ul>',
              '<% if (count > 1) {%>',
                '  </div>',
                '<% } %>',
                '  <span class="close"></span>',
                '</div>'].join(' ')};

                var count = this.info.length;
                var markerTemplate = _.template(templates.marker, {count:count});

                var events = "";
                var event;

                for (var i = 0; i <= this.info.length - 1 ; i++) {
                  event = this.info[i];
                  var addSeparator = (count > 1 && i < count - 1) ? true : false;
                  events +=  _.template(templates.event, {title:event.title, date:event.date, where:event.where, when:event.when, separator:addSeparator});
                }

                var contentTemplate = _.template(templates.infowindow, {count:count, events:events});
                $(div).append(markerTemplate);
                $(div).append(contentTemplate);

                $('.close').live('mousedown',function(ev){
                  ev.stopPropagation();
                  ev.preventDefault();
                  $('div.infowindow').hide();
                });


                $('a.marker').live('mousedown',function(ev){
                  ev.stopPropagation();
                  ev.preventDefault();
                  me.moveMaptoOpen();
                  $('div.infowindow').hide();
                  $(this).parent().children('div.infowindow').show();
                  $('.scroll-pane').jScrollPane();
                });

                var panes = this.getPanes();
                panes.floatPane.appendChild(div);
  }

  var pixPosition = me.getProjection().fromLatLngToDivPixel(me.latlng);

  if (pixPosition) {
    div.style.left = (pixPosition.x + me.offsetHorizontal_) + 'px';
    div.style.top = (pixPosition.y + me.offsetVertical_) + 'px';
  }

  $infowindow = $(div).find(".infowindow");
  var height = $infowindow.height();
  var width = $infowindow.width();
  $infowindow.css("top", (-1*height - 45) + "px");
  $infowindow.css("left", (-1*width/2 - 10)  + "px");
};

IrekiaMarker.prototype.remove = function() {
  if (this.div_) {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
  }
};

IrekiaMarker.prototype.hide = function() {
  if (this.div_) {
    $(this.div_).find('div').fadeOut();
  }
};

IrekiaMarker.prototype.getPosition = function() {
  return this.latlng_;
};

IrekiaMarker.prototype.moveMaptoOpen = function() {
  var infoWindowHeight = 268;
  var infoWindowWidth = 158;
  var left = 0;
  var top  = 0;

  var pixPosition = this.getProjection().fromLatLngToContainerPixel(this.latlng);

  if ((pixPosition.x + this.offsetHorizontal_) < infoWindowWidth) {
    left = (pixPosition.x + this.offsetHorizontal_ - infoWindowWidth);
  }

  if (($('div#map_canvas').width() - pixPosition.x + this.offsetHorizontal_) < infoWindowWidth) {
    left = infoWindowWidth - $('div#map_canvas').width() + pixPosition.x - this.offsetHorizontal_;
  }
  if ((pixPosition.y + this.offsetVertical_) < infoWindowHeight) {
    top = pixPosition.y + this.offsetVertical_ - infoWindowHeight;
  }

  this.map.panBy(left, top);
}

