$(function() {

  // Preloading of popover assets
  $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  // Resize agenda_map container
  $("article.agenda .agenda_map").animate({height:$(".agenda_map ul.agenda").height() }, 0);

  // Map/Agenda behaviour
  $(".view_calendar").viewCalendar();
  $(".view_map").viewMap();

  $('.sparkline.positive .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#5E8821', height:"18px", width:"50px"});
  $('.sparkline.negative .graph').sparkline('html', {spotRadius: false, fillColor:false, lineColor: '#FF3300', height:"18px", width:"50px"});

  // If user types more than 2 letters, submit form
  $('nav form input[type="text"]').keyup(function(ev){
    if ($(this).val().length>2) {
      $('nav form').submit();
    } else {
      var $autocomplete = $(this).closest('form').find('.autocomplete');
      $autocomplete.fadeOut("fast");
    }
  });

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    var $autocomplete = $(this).find('.autocomplete');
    $autocomplete.addClass("visible");

    if ($autocomplete.length > 0) {
      $autocomplete.fadeOut("fast");
    }

    $autocomplete.html(xhr);
    $autocomplete.css("margin-left", "-158px");
    $autocomplete.css("margin-top", "23px");
    $autocomplete.fadeIn("fast");
  });

  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize({width:302, height:125});
  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  $(".share.twitter, .share.facebook").share();
  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".auth a.login").loginPopover();
  $(".share.inline, .share.more, .share.email").sharePopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  var current_filter = "";
  var current_sort_filter = {};

  $(".with_filters").filterWidget();
});
