$(function() {

  
	function getGeolocation(){
	  alert('a');
		if (google.loader.ClientLocation) {
			userLatLng = new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
			showRoad(userLatLng,calculateNearOffice(userLatLng));
	  } else {
			bounds.extend(vizzuality_mad);
			bounds.extend(vizzuality_ny);
			map.fitBounds(bounds);
			
			vizz_marker = new google.maps.Marker({
			    position: vizzuality_mad,
					icon: vizz_icon,
			    map: map
			});
			user_marker = new google.maps.Marker({
			    position: vizzuality_ny,
			    icon: vizz_icon,
			    map: map
			});
			 
			window.onresize = function(event) {
			   map.setCenter(bounds.getCenter());
			}      
	  }
	}

  $("a.reload").click(function(e){
    e.preventDefault();
    window.location.reload();
  });

  var headerHeight = $("header").outerHeight(true) + $(".title").outerHeight(true);
    setTimeout(function() {

  $(".paper").animate({top: headerHeight + "px"}, 250);
    }, 200);

  $("form.publish").bind('ajax:success', function() {
    window.location.reload();
  });

  $("textarea").on("blur", function() {

    $("header").show();
    $(".paper").css({top:headerHeight});

    if ($(this).val().length == 0) {
      $(".placeholder").show();
      $("input.publish").hide();
    } else {
      $("input.publish").show();
    }
  });

  $("textarea").on("focus", function() {
    $(".paper .placeholder").hide();
    $("header").hide();
    $(".paper").css({top:0});
    window.scroll(0,0);
  });

  if ($(".article.comments").length > 0) {

    var height = $(".article.comments").height() + 250;
    $("#main").css("height", height + "px");

    setTimeout(function() {
      var top = headerHeight;
      $(".article").animate({top:top, opacity:1}, 350);
    }, 500);
  }
});
