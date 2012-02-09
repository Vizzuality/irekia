$(function() {

  $("a.reload").click(function(e){
    e.preventDefault();
    window.location.reload();
  });

  var headerHeight = $("header").outerHeight(true) + $(".title").outerHeight(true);
    setTimeout(function() {

  $(".paper").animate({top: headerHeight + "px"}, 250);
    }, 200);

  $("form.new_event").bind('ajax:success', function() {
    alert($(this).attr("data-success"));
    window.location = '/?datalogger=true';
  });

  $("form.new_status_message").bind('ajax:success', function() {
    alert($(this).attr("data-success"));
    window.location = '/?datalogger=true';
  });

  $("form.publish").bind('ajax:success', function() {
    window.location.reload();
  });

  $(".publish").click(function() {
    $(this).parents("form").append("<div class='mamufas'/>");
  });
    
  $("textarea.toggle_header").on("blur", function() {

    $("header").show();
    $(".paper").css({top:headerHeight});

    if ($(this).val().length == 0) {
      $(".placeholder").show();
      $("input.publish").hide();
    } else {
      $("input.publish").show();
    }
  });

  $("textarea.toggle_header").on("focus", function() {
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
