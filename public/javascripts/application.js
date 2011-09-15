$(function() {
  // Preloading of popover assets
  $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    $(this).find('.autocomplete').html(xhr);
  });

  $('html.ie7 .frame, html.ie8 .frame').append("<div class='ieframe'></div>");
  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize();
  $(".input-counter").smartPlaceholder();
  $(".input_field").smartPlaceholder();
  $(".input-counter").inputCounter();

  // Popovers
  $(".event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".auth a.login").loginPopover();
});
