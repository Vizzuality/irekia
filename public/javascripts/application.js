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

  $(".avatar_uploader_form").enableAvatarUpload();

  $('.tabs').tabs();

  $(".slideshow").enableSlideshow();

  // Pagination
  $(".more_proposals").enablePagination({name: "proposals"});
  $(".more_months").enablePagination({name: "months"});
  $(".more_questions").enablePagination({name: "questions"});
  $(".more_actions").enablePagination({name: "actions"});

  $("textarea.grow").autogrow();
  $(".cycle").enableRegistration();

  // Resize agenda_map container
  $(".article.agenda .agenda_map").animate({height:$(".agenda_map ul.agenda").height() }, 0);

  // Map/Agenda behaviour
  $(".view_calendar").viewCalendar();
  $(".view_map").viewMap();

  $('nav form').autocompleteSearch();

  // Form elements
  $('a.checkbox').enableCheckbox();
  $('.radios').enableRadio();
  $('select.dropkick').dropkick();

  $('.area_filter').dropkick({ filterEvents: true });

  // Dropboxes
  $('form .field.born_at select[name="user[birthday(1i)]"]').dropkick({width:-10});
  $('form .field.born_at select[name="user[birthday(2i)]"]').dropkick({width:77});
  $('form .field.born_at select[name="user[birthday(3i)]"]').dropkick({width:-20});

  // Simple triggers
  $("a.see_all_areas").enableSeeAllAreas();
  $(".welcome-slideshow").enableWelcomeSlideshow();

  // Comments, opinions and arguments
  $('.my_opinion').enableOpinion();
  $('.article.proposal .proposals .proposal').enableArguments();
  $('form.add_comment').enableComments();
  $(".comment-box form").enableCommentBox();
  $(".goto_comments").enableGotoComments();

  $(".notifications").enableNotificationSelector();
  $('.floating-login').floatingLoginPopover();

  $(".placeholder").smartPlaceholder();
  $(".input-counter").inputCounter();

  // Sharing
  $(".share.more, .share.email").sharePopover();
  $(".share.inline").inlineSharePopover();

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();

  $(".make_question").enableQuestion();

  $(".remove_account").removeAccountPopover();

  $(".user_publish").userPublishPopover();
  $(".politician_publish").politicianPublishPopover();
  $(".create_proposal").proposalPopover();
  $(".auth a.login").loginPopover();

  $(".with_filters").enableFiltering();
  $(".with_filters").enableFiltering();

  $(".areas_selector").areasPopover();
  $(".toggle_notifications").notificationPopover();

  // Tipsy
  $('input.ribbon, .toggle_notifications, .after_share.email, .share.email, .share.twitter, .share.facebook, .share.ical, a.settings, .sign_out').tipsy({gravity: 's', offset: 3, title: 'data-label'});

  // Follow forms

  $(".follow.basic form").live('submit', function(){
    IrekiaSpinner.stop();
    IrekiaSpinner.spin();
    $(IrekiaSpinner.el).css({ bottom:"-8px", position:"absolute", right:'0', height:'15px', width:'15px', 'z-index':'1000'});
    $(this).closest('div.content').append(IrekiaSpinner.el);
  }).live('ajax:success', function(evt, xhr, status) {
    var $el = $(this).parent();
    $el.fadeOut(150, function() {
      $el.parents("li").toggleClass("selected");
      $(this).html(xhr);
      $(this).fadeIn(150);
    });
    IrekiaSpinner.stop();
  }).live('ajax:error', function(evt, xhr, status) {
    $(this).effect("shake", { times:4 }, 100);
    IrekiaSpinner.stop();
  });

  $("form.follow_button, form.follow_ribbon").live('submit',function(ev){
    IrekiaSpinner.stop();
    IrekiaSpinner.spin();
    $(IrekiaSpinner.el).css({position:"relative", float:'none', display:'inline', right:'-20px', top:'27px', height:'15px', width:'15px'});

    if ($(this).closest('div.content').find('h1').children().length>0) {
      $(this).closest('div.content').find('h1 a').append(IrekiaSpinner.el);
    } else {
      $(this).closest('div.content').find('h1').append(IrekiaSpinner.el);
    }

  }).live('ajax:success', function(evt, xhr, status) {
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
    var $el2 = $('.article').find("form.follow_ribbon");
    $el2.fadeOut(150, function() {
      var parent = $(this).parent();
      $(this).remove();
      parent.append(xhr);
      parent.find('form.follow_button').last().remove();
      $(this).fadeIn(150);
    });

    // Hide tooltip in any case
    $('input.ribbon').tipsy("hide");

    IrekiaSpinner.stop();
  }).live('ajax:error', function(evt, xhr, status) {
    $(this).effect("shake", { times:4 }, 100);
    IrekiaSpinner.stop();
  });

  // Grow ribbon
  $('.follow_ribbon .ribbon').live('mouseenter',function(){
    var form_ = $(this).closest('form');
    form_.stop(true).animate({height:'90px'},300);
  }).live('mouseleave',function() {
    var form_ = $(this).closest('form');
    form_.stop(true).animate({height:'75px'},300);
  });

  // Answer form
  $('div.answering form').live('ajax:success',function(evt, xhr, status) {
    var parent = $(this).closest('div.answering');
    var response = $(xhr);
    response.hide();

    console.log("Response", evt, xhr, status);

    parent.fadeOut(function(){
      parent.before(response);
      response.fadeIn();
    });
  });

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


  // After requesting an answer, reload the text
  $(".answer_placeholder form").bind('ajax:success', function(evt, xhr, status) {
    var $ps = $(this).parents(".answer_placeholder").find(".has_requested_answer");

    $(this).fadeOut(150);
    $ps.fadeOut(150, function() {
      $ps.html(xhr);
      $ps.fadeIn(150);
    });
  });

});
