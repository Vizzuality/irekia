$(function() {
  // Preloading of popover assets


  $(".view_calendar").click(function(e){
    e.preventDefault();
    $(".map_agenda").scrollTo("-=1024px", 500);
    $("article.agenda .map_agenda").animate({height:$(".prueba .agenda").height()}, 500);
  });

  $(".view_map").click(function(e){
    e.preventDefault();
    $(".map_agenda").scrollTo("+=1024px", 500);
    console.log($(".map").height());
    $("article.agenda .map_agenda").animate({height:$(".prueba .map").height()}, 500);
  });

  $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  $('.sparkline.positive .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#5E8821', height:"18px", width:"50px"});
  $('.sparkline.negative .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#FF3300', height:"18px", width:"50px"});

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    $(this).find('.autocomplete').html(xhr);
  });

  $('html.ie7 .avatar, html.ie8 .avatar').append("<div class='ieframe'></div>");
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
