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

  $('nav form').bind('ajax:success', function(evt, xhr, status){
    var $autocomplete = $(this).find('.autocomplete');
    $autocomplete.addClass("visible");

    if ($autocomplete.length > 0) {
      $autocomplete.fadeOut("fast", function(){});
    }

    $autocomplete.html(xhr);
    $autocomplete.css("margin-left", "-158px");
    $autocomplete.css("margin-top", "23px");
    $autocomplete.fadeIn("fast");
  });

  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize();
  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  $(".share.twitter, .share.facebook").share();
  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".auth a.login").loginPopover();
  $(".share.more, .share.email").sharePopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  var current_filter = "";
  var current_sort_filter = {};

  $(".with_filters").filterWidget();

//   $(".sort-filter").click(function(e) {
//     e.preventDefault();
//
//
//     if ($(this).attr('class').indexOf("more_polemic") != -1) {
//       current_sort_filter = { more_polemic: true };
//     } else {
//       current_sort_filter = { more_recent: true };
//     }
//
//     $(this).parents("ul").find("li").removeClass("selected");
//     $(this).parent().addClass("selected");
//
//     if (current_filter) {
//       href = current_filter;
//     } else {
//     href = $(this).attr("href");
//     current_filter = href;
//
//     }
//
//     console.log(current_filter, current_sort_filter);
//
//     $.ajax({ url: href, data: current_sort_filter, type: "GET", success: function(data){
//       $("#actions").slideUp(250, function() {
//         $("#actions").html(data);
//         $("#actions").slideDown(250);
//       });
//     }});
//   });
//
//   $(".filter").click(function(e) {
//     e.preventDefault();
//
//     $(this).parents("ul").find("li").removeClass("selected");
//     $(this).parent().addClass("selected");
//
//     href = $(this).attr("href");
//     current_filter = href;
//
//     console.log(current_filter, current_sort_filter);
//
//     $.ajax({ url: href, data: current_sort_filter, type: "GET", success: function(data){
//       $("#actions").slideUp(250, function() {
//         $("#actions").html(data);
//         $("#actions").slideDown(250);
//       });
//     }});
//   });
});
