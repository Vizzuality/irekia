$(function() {

  function redirectToRoot() {
    alert('Question answered');
  }

  $("form.publish").bind('ajax:success', redirectToRoot);

  $("textarea").on("blur", function() {
    $("header, .header").css("position", "fixed");
    $(".paper").css({top:0, opacity:0});
    $(".header").css("top", "65px");
    window.scroll(0, 0)

    setTimeout(function() {
      var top = $(".header").position().top + $(".header").outerHeight(true);
      $(".paper").animate({top:top, opacity:1}, 200);
    }, 500);

    if ($(this).val().length == 0) {
      $(".placeholder").show();
    }
  });

  $("textarea").on("focus", function() {
    $(".placeholder").hide();
    window.scroll(0, 50)
    $("header, .header").css("position", "relative");
    $(".paper, .header").css("top", "-70px");
  });

  if ($(".paper").length > 0) {
    setTimeout(function() {
      var top = $(".header").position().top + $(".header").outerHeight(true);
      $(".paper").animate({top:top, opacity:1}, 350);
    }, 500);
  }

  if ($(".article.comments").length > 0) {
    setTimeout(function() {
      var top = $(".header").position().top + $(".header").outerHeight(true) - 40;
      $(".article").animate({top:top, opacity:1}, 350);
    }, 500);
  }
});
