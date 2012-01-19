$(function() {
  $("textarea").on("blur", function() {
    $("header, .header").css("position", "fixed");
    $(".paper").css("top", "215px");
    $(".header").css("top", "65px");
    window.scroll(0, 0)

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
});
