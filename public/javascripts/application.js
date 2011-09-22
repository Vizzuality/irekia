$(function() {
  // Preloading of popover assets


  $(".view_calendar").click(function(e){
    e.preventDefault();
    $(this).parent().toggleClass("selected");
    $(".view_map").parent().toggleClass("selected");
    $("article.agenda .agenda_map").animate({height:$(".agenda_map ul.agenda").height()}, 250, function(){
      $(".agenda_map .map").fadeOut("fast");
      $(".agenda_map .agenda").fadeIn("fast");
    });
  });

  $(".view_map").click(function(e){
    e.preventDefault();
    $(this).parent().toggleClass("selected");
    $(".view_calendar").parent().toggleClass("selected");
      $(".agenda_map .map").fadeIn("fast");
      $(".agenda_map .agenda").fadeOut("fast");
      $("article.agenda .agenda_map").animate({height:$(".agenda_map .map").height()}, 250);
  });

  $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  $('.sparkline.positive .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#5E8821', height:"18px", width:"50px"});
  $('.sparkline.negative .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#FF3300', height:"18px", width:"50px"});

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    $(this).find('.autocomplete').html(xhr);
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

