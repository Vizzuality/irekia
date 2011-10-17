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

  $('nav form').autocomplete();

  // Checkbox binding
  $('a.checkbox').click(function(ev){
    if (!$(this).hasClass('selected')) {
      $(this).addClass('selected');
      $(this).closest('p').find('input[type="checkbox"]').val(1);
    } else {
      $(this).removeClass('selected');
      $(this).closest('p').find('input[type="checkbox"]').val(0);
    }
  });

  if (hash = window.location.hash) {
    if (hash == "#comments") {
      $('html, body').delay(500).animate({scrollTop:$(".comments").offset().top}, 250, function() {
        window.location.hash = '';
      });
    }
  }

  $('form.add_comment').enableComments();
  $(".goto_comments").enableGotoComments();
  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize({width:302, height:125});
  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  $(".share.twitter, .share.facebook").share();
  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".auth a.login").loginPopover();
  $(".share.inline, .share.more, .share.email").sharePopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  var current_filter = "";
  var current_sort_filter = {};

  $(".with_filters").filterWidget();
});
