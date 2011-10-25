$(function() {
  watchHash(); // this function watches the url hashes and acts accordingly


    $("textarea").autogrow();

  $(".cycle").enableRegistration();
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

  // Radio binding
  $('a.radio').click(function(e){
    e.preventDefault();
    $("a.radio").removeClass("selected");
    $(this).addClass('selected');
    $(this).closest('input[type="radio"]').val(0);

    if (!$(this).hasClass('selected')) {
      $(this).addClass('selected');
      $(this).closest('input[type="radio"]').val(1);
    }
  });

  $('a.checkbox').enableCheckbox();
  $('.default').dropkick();

  $(".follow.basic form").live('ajax:success', function(evt, xhr, status) {
    var $el = $(this).parent();
    $el.fadeOut(250, function() {
      $el.parents("li").toggleClass("selected");
      $(this).html(xhr);
      $(this).fadeIn(250);
    });
  });

  $("#follow form").live('ajax:error', function(evt, xhr, status) {
    $(this).effect("shake", { times:4 }, 100);
  });

  $("#follow form").live('ajax:success', function(evt, xhr, status) {
    var $el = $(this).parents("#follow");
    $el.fadeOut(250, function() {
      $(this).html(xhr);
      $(this).fadeIn(250);
    });
  });

  $(".my_opinion form").bind('ajax:success', function(evt, xhr, status) {
    $(this).parents(".my_opinion").find("form").fadeOut(250);
    $(this).parents(".my_opinion").find(".result").fadeOut(250, function() {
      $(this).html(xhr);
      $(this).fadeIn(250);
    });
  });

  // This button close welcome message for new users
  $(".close-welcome").submit(function(e) {
    $(".welcome .close-welcome").fadeOut(250, function(){
			$(this).remove();
		});
    $(".welcome ul.actions").slideUp(250, function(){
			$(this).remove();
			$('.welcome a.config.first-time').fadeIn(250);
		});
  });

  $('.proposal .new_argument').enableArguments();
  $('form.add_comment').enableComments();
  $(".comment-box form").enableCommentBox();

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
  $(".create_proposal").proposalPopover();
  $(".auth a.login").loginPopover();
  $(".share.inline, .share.more, .share.email").sharePopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  $(".with_filters").filterWidget();
});
