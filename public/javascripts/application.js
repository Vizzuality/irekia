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
		var $el1 = $("div.column form.follow_button");
    $el1.fadeOut(150, function() {
			var parent = $(this).parent();
      $(this).remove();
			parent.append(xhr);
			parent.find('form.follow_ribbon').remove();
      parent.find('form.follow_button').fadeIn(150);
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
		form_.stop(true).animate({height:'90px'},300);
	}).live('mouseleave',function() {
		var form_ = $(this).closest('form');
		form_.stop(true).animate({height:'75px'},300);
	});

	// END FOLLOW FORMS!!


	// ANSWER FORM
	$('div.answering form').live('ajax:success',function(evt, xhr, status) {
		var parent = $(this).closest('div.answering');
		var response = $(xhr);
		response.hide();

		parent.fadeOut(function(){
			parent.before(response);
			response.fadeIn();
		});
	});
	// END ANSWER FORM


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

  $('.my_opinion').enableOpinion();
  $('.proposals .proposal').enableArguments();
  $('form.add_comment').enableComments();
  $(".comment-box form").enableCommentBox();
  $(".notifications").enableNotificationSelector();

  $(".goto_comments").enableGotoComments();
  $('.floating-login').floatingLoginPopover();




	// If is politicians - 105 | areas - 140 >> HACK
	// var h_ = 0;
	// if ($('div#main').hasClass('politicians')) {
	// 	h_ = (7 * 18) + 5;
	// } else {
	// 	h_ = $('.two_columns').height() + 30;
	// }
	//
	//   $('.two_columns').columnize({width:282, height:h_, columns:2});

  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  //$(".share.twitter, .share.facebook").share();

  $(".share.twitter").click(function() {
    var width  = 611,
        height = 400,
        left   = 21,
        top    = 44,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left;

    window.open(url, 'twitter', opts);

    return false;
  });

  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();


jQuery.fn.enableQuestion = function(opt){

  if (this.length < 1) return;

  var speed  = (opt && opt.speed) || 200;

  var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
  var spin_element = document.getElementById("politician_question_spinner");
  var spinner = new Spinner(opts);

  this.each(function(){
    $(this).submit(function(e) {
      spinner.spin(spin_element);
      $("#notice_success").fadeOut(150);


    });

    $(this).bind('ajax:success', function(evt, xhr, status) {
      spinner.stop();
      $(this).find(".notice_success").fadeIn(220);

      $icon = $("<span class='icon success' />");
      $(this).find(".input-counter").append($icon);


      $("#notice_success").css("left", "447px");
      $("#notice_success").css("bottom", "70px");
      $(this).find('input[type="text"]').val("");
      $(this).find(".holder").fadeIn(150);

      $(this).find(".counter").val(140);
      var $that = $(this);

      setTimeout(function() {
        $("#notice_success").fadeOut(150);
        $that.find(".icon").fadeOut(150, function() { $(this).remove();});
      }, 2000);

    });
  });
};

$(".make_question").enableQuestion();

$(".user_publish").userPublishPopover();
$(".politician_publish").politicianPublishPopover();

$(".create_proposal").proposalPopover();

$(".auth a.login").loginPopover();

$(".share.inline, .share.more, .share.email").sharePopover();

//$('.avatar').prepend("<div class='ieframe'></div>");
$(".with_filters").filterWidget();
$(".with_filters").filterWidget();

// $("article.politician.publish").enablePoliticianPublish();
// $("article.politician.publish").enablePoliticianPublish();

$(".areas_selector").areasPopover();
$(".toggle_notifications").notificationPopover();

// After requesting an answer, reload the text
$(".answer_placeholder form").bind('ajax:success', function(evt, xhr, status) {
  var $ps = $(this).parents(".answer_placeholder").find(".has_requested_answer");

  $(this).fadeOut(150);
  $ps.fadeOut(150, function() {
    $ps.html(xhr);
    $ps.fadeIn(150);
  });
});

// HOME, grow all areas
$("a.see_all_areas").click(function(ev){
  ev.preventDefault();
  $(this).closest('article.areas').find('div.areas_list').animate({height:'635px'},500);
  $(this).closest('article.areas').find('div.all_areas').show();
  $(this).closest('article.areas').find('footer').animate({opacity:0,height:0},500,function(){
    $(this).closest('article.areas').removeClass('with_footer');
    $(this).remove();
  });
});

});
