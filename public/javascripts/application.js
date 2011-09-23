$(function() {
  // Preloading of popover assets


  // reisze agenda_map container
  $("article.agenda .agenda_map").animate({height:$(".agenda_map ul.agenda").height() }, 0);

  $(".view_calendar").viewCalendar();
  $(".view_map").viewMap();

  $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  $('.sparkline.positive .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#5E8821', height:"18px", width:"50px"});
  $('.sparkline.negative .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#FF3300', height:"18px", width:"50px"});

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    var $autocomplete = $(this).find('.autocomplete');

    if ($autocomplete.length > 0) {
      $autocomplete.fadeOut("fast", function(){});
    }

    $autocomplete.html(xhr);
    $autocomplete.css("left", "183px");
    $autocomplete.css("margin-top", "23px");
    $autocomplete.fadeIn("fast");
  });

  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize();
  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  // Popovers
  $(".event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".auth a.login").loginPopover();
  $(".share.more, .share.email").sharePopover();

  $(".share.twitter, .share.facebook").share();

  //$('.avatar').prepend("<div class='ieframe'></div>");
});

