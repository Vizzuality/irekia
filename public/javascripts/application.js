$(function() {
  watchHash(); // this function watches the url hashes and acts accordingly

	$('.home_last_activity').verticalHomeLoop();

  $(".more_proposals").enablePagination({name: "proposals"});
  $(".more_months").enablePagination({name: "months"});
  $(".more_questions").enablePagination({name: "questions"});
  $(".more_actions").enablePagination({name: "actions"});

  $("textarea.grow").autogrow();
  $(".cycle").enableRegistration();
  //$("article.signup").enableSocialRegistration();

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
  $('select.dropkick').dropkick();

  $('form .field.born_at select[name="user[birthday(1i)]"]').dropkick({width:-10});
  $('form .field.born_at select[name="user[birthday(2i)]"]').dropkick({width:77});
  $('form .field.born_at select[name="user[birthday(3i)]"]').dropkick({width:-20});




	// FOLLOW FORMS!!
  $(".follow.basic form").live('ajax:success', function(evt, xhr, status) {
    var $el = $(this).parent();
    $el.fadeOut(150, function() {
      $el.parents("li").toggleClass("selected");
      $(this).html(xhr);
      $(this).fadeIn(150);
    });
  }).live('ajax:error', function(evt, xhr, status) {
		$(this).effect("shake", { times:4 }, 100);
	});


  $("form.follow_button,form.follow_ribbon").live('ajax:success', function(evt, xhr, status) {
    // Button
		var $el1 = $("#follow");
    $el1.fadeOut(150, function() {
      $(this).html(xhr);
			$(this).find('form.follow_ribbon').remove();
      $(this).fadeIn(150);
    });

		// Ribbon
		var $el2 = $('article.summary').find("form.follow_ribbon");
    $el2.fadeOut(150, function() {
      $(this).remove();
			$('article.summary').append(xhr);
			$('article.summary > form.follow_button').remove();
      $(this).fadeIn(150);
    });
		
  }).live('ajax:error', function(evt, xhr, status) {
		$(this).effect("shake", { times:4 }, 100);
	});


	// Grow ribbon
	$('.follow_ribbon .ribbon').live('mouseenter',function(){
		var form_ = $(this).closest('form');
		form_.stop().animate({height:'90px'},300);
	}).live('mouseleave',function() {
		var form_ = $(this).closest('form');
		form_.stop().animate({height:'75px'},300);
	});
	
	// END FOLLOW FORMS!!



  $(".my_opinion input[type='submit'], .my_opinion button").click(function(e) {
      $(".my_opinion .selected").removeClass("selected");
      $(this).addClass("selected");
  });

  $(".my_opinion form").bind('ajax:success', function(evt, xhr, status) {
    $(this).parents(".my_opinion").find(".result").fadeOut(250, function() {
      $(this).html(xhr);

      $(this).parent().removeClass("in_favor");
      $(this).parent().removeClass("against");
      $(this).parent().addClass($(xhr).attr('class'));

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

  $('.proposals .proposal').enableArguments();
  $('form.add_comment').enableComments();
  $(".comment-box form").enableCommentBox();
  $(".notifications").enableNotificationSelector();

  $(".goto_comments").enableGotoComments();
  $('.floating-login').floatingLoginPopover();

  $('.two_columns').columnize({width:302, height:125});
  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  //$(".share.twitter, .share.facebook").share();
  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();
  $(".user_publish").userPublishPopover();
  $(".create_proposal").proposalPopover();

  $(".auth a.login").loginPopover();

  $(".share.inline, .share.more, .share.email").sharePopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  $(".with_filters").filterWidget();
  $(".with_filters").filterWidget();

  // $("article.politician.publish").enablePoliticianPublish();
  // $("article.politician.publish").enablePoliticianPublish();
  $(".areas_selector").areasPopover();
});
