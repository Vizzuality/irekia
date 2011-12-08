/*
* Binds css selectors with javascript plugins.
*/

$(function() {

  watchHash(); // watches the url hashes and acts accordingly

  $('.home_last_activity').verticalHomeLoop();

  // Editing tools
  $(".editable.text").enableTextEditing();
  $(".editable.target").enableTargetEditing();
  $(".editable.date").enableDateEditing();
  $(".image_editor").enableImageEditing();
  $(".editable.location .footer").enableLocationEditing();
  $(".right .tags.editable").enableEditTags();
  $(".people.editable").enablePoliticianTags();
  $(".context ul.editable.tags").enableAreaEditing();

  $('.tabs').tabs();

  $(".slideshow").enableSlideshow();

  // Pagination
  $(".more_proposals").enablePagination({name: "proposals"});
  $(".more_months").enablePagination({name: "months"});
  $(".more_questions").enablePagination({name: "questions"});
  $(".more_actions").enablePagination({name: "actions"});

  $("textarea.grow").autogrow();
  $(".cycle").enableRegistration();
  //$(".article.signup").enableSocialRegistration();

  // Resize agenda_map container
  $(".article.agenda .agenda_map").animate({height:$(".agenda_map ul.agenda").height() }, 0);

  // Map/Agenda behaviour
  $(".view_calendar").viewCalendar();
  $(".view_map").viewMap();

  $('nav form').autocompleteSearch();

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

  // Follow forms
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


  $("form.follow_button, form.follow_ribbon").live('ajax:success', function(evt, xhr, status) {

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
    var $el2 = $('.article.summary').find("form.follow_ribbon");
    $el2.fadeOut(150, function() {
      $(this).remove();
      $('.article.summary').append(xhr);
      $('.article.summary > form.follow_button').remove();
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
  $('.article.proposal .proposals .proposal').enableArguments();
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

  $(".share.twitter").live("click", function() {
    var width  = 611,
    height = 400,
    left   = 21,
    top    = 44,
    url    = this.href,
    opts   = 'status=1' + ',width='  + width  + ',height=' + height + ',top='    + top    + ',left='   + left;

    window.open(url, 'twitter', opts);

    return false;
  });

  $(".share.more, .share.email").sharePopover();
  $(".share.inline").inlineSharePopover();

  $(".show-hidden-comments").showHiddenComments();

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();

  $(".make_question").enableQuestion();

  $(".user_publish").userPublishPopover();
  $(".politician_publish").politicianPublishPopover();
  $(".create_proposal").proposalPopover();
  $(".auth a.login").loginPopover();

  //$('.avatar').prepend("<div class='ieframe'></div>");
  $(".with_filters").filterWidget();
  $(".with_filters").filterWidget();

  // $(".article.politician.publish").enablePoliticianPublish();
  // $(".article.politician.publish").enablePoliticianPublish();

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
    $(this).closest('.article.areas').find('div.areas_list').animate({height:'635px'},500);
    $(this).closest('.article.areas').find('div.all_areas').show();
    $(this).closest('.article.areas').find('footer').animate({opacity:0,height:0},500,function(){
      $(this).closest('.article.areas').removeClass('with_footer');
      $(this).remove();
    });
  });
});
