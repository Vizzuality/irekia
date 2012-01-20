$(function() {

var loading = false,

  function redirectToRoot() {
//    alert('Question answered');
  }

  $("form.publish").bind('ajax:success', redirectToRoot);

  $("textarea").on("blur", function() {
    $("header, .title").css("position", "fixed");
    $(".paper").css({top:0, opacity:0});
    $(".title").css("top", "65px");
    window.scroll(0, 0)

    setTimeout(function() {
      var top = $(".title").position().top + $(".title").outerHeight(true);
      $(".paper").animate({top:top, opacity:1}, 200);
    }, 500);

    if ($(this).val().length == 0) {
      $(".placeholder").show();
    }
  });

  $("textarea").on("focus", function() {
    $(".placeholder").hide();
    window.scroll(0, 50)
    $("header, .title").css("position", "relative");
    $(".paper, .title").css("top", "-70px");
  });

  if ($(".article.comments").length > 0) {

    var height = $(".article.comments").height() + 250;
    $("#main").css("height", height + "px");

    setTimeout(function() {
      var top = $(".title").position().top + $(".title").outerHeight(true) - 40;
      $(".article").animate({top:top, opacity:1}, 350);
    }, 500);
  }
});
