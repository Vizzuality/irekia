/*
* Binds css selectors with javascript plugins.
*/

$(function() {

  watchHash(); // watches the url hashes and acts accordingly

  $('.home_last_activity').verticalHomeLoop();

  /*
  /* Editing tools
  */

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

  /*
  /* Pagination
  */
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

  /*
  /* Form elements
  */
  $('a.checkbox').enableCheckbox();
  $('.radios').enableRadio();
  $('select.dropkick').dropkick();

  $('form .field.born_at select[name="user[birthday(1i)]"]').dropkick({width:-10});
  $('form .field.born_at select[name="user[birthday(2i)]"]').dropkick({width:77});
  $('form .field.born_at select[name="user[birthday(3i)]"]').dropkick({width:-20});

  // FOLLOW FORMS
  var basic_spinner = new Spinner({lines: 12,length: 0,width: 3,radius: 6,color: '#3786C0',speed: 1,trail: 100,shadow: false});
  $(".follow.basic form").live('submit',function(){
    basic_spinner.stop();
    basic_spinner.spin();
    $(basic_spinner.el).css({ bottom:"-8px", position:"absolute", right:'0', height:'15px', width:'15px', 'z-index':'1000'});
    $(this).closest('div.content').append(basic_spinner.el);
  }).live('ajax:success', function(evt, xhr, status) {
    var $el = $(this).parent();
    $el.fadeOut(150, function() {
      $el.parents("li").toggleClass("selected");
      $(this).html(xhr);
      $(this).fadeIn(150);
    });
    basic_spinner.stop();
  }).live('ajax:error', function(evt, xhr, status) {
    $(this).effect("shake", { times:4 }, 100);
    basic_spinner.stop();
  });


  var main_spinner = new Spinner({lines: 12,length: 0,width: 3,radius: 6,color: '#3786C0',speed: 1,trail: 100,shadow: false});;
  $("form.follow_button, form.follow_ribbon").live('submit',function(ev){
    main_spinner.stop();
    main_spinner.spin();
    $(main_spinner.el).css({position:"relative", float:'none', display:'inline', right:'-20px', top:'27px', height:'15px', width:'15px'});

    if ($(this).closest('div.content').find('h1').children().length>0) {
      $(this).closest('div.content').find('h1 a').append(main_spinner.el);
    } else {
      $(this).closest('div.content').find('h1').append(main_spinner.el);
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

    main_spinner.stop();
  }).live('ajax:error', function(evt, xhr, status) {
    $(this).effect("shake", { times:4 }, 100);
    main_spinner.stop();
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


  // WELCOME WINDOW
  //  close welcome window and show user thingy
  $(".close-welcome").submit(function(e) {

    var move_li = $(this).closest('.inner').find('ul > li:last');
    $(this).closest('.inner').find('ul > li:first').after(move_li);

    $(this).closest('.inner').find('ul').animate({marginLeft:'-994px'},500,function(e){
      $('.welcome a.config.first-time').fadeIn(250);
    });

    $(".welcome .close-welcome,.welcome .next-welcome").fadeOut(250, function(){
      $(this).remove();
    });

    $('.welcome > .inner').animate({height:'110px'},500);
  });

  //  move between the differents illustrations
  $(".next-welcome").click(function(e) {
    e.preventDefault();
    $(this).closest('.inner').find('ul').animate({marginLeft:'-994px'},500,function(e){
      var move_li = $(this).find('li:first');
      $(this).find('li:last').before(move_li);
      $(this).removeAttr('style');
    });
  });



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

  // Popovers
  $(".show_event").infoEventPopover();
  $(".ask_question").questionPopover();

  $(".make_question").enableQuestion();

  $(".remove_account").removeAccountPopover();

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
    $(this).closest('.article.areas').find('.bfooter').animate({opacity:0,height:0},500,function(){
      $(this).closest('.article.areas').removeClass('with_footer');
      $(this).remove();
    });
  });


  // TIPSY TOOLTIPS (add here all possible tooltips)
  //  Follow area or politician tooltip
  $('input.ribbon').tipsy({live: true, gravity: 's', offset: 3, title: function() {
    var type = $(this).closest('div.content').find('button.add_to_favorites span').text();
    if (type=='') type = "Seguir a este político"
    return type;
  }});

  //  Follow mail
  $('.share.email').tipsy({live: true, gravity: 's', offset: 3, title: function() {
    return 'Compartir vía email';
  }});

  //  Follow twitter
  $('.share.twitter').tipsy({live: true, gravity: 's', offset: 3, title: function() {
    return 'Compartir vía twitter';
  }});

  //  Follow facebook
  $('.share.facebook').tipsy({live: true, gravity: 's', offset: 3, title: function() {
    return 'Compartir vía facebook';
  }});

  //  Export to iCal
  $('.share.ical').tipsy({live: true, gravity: 's', offset: 3, title: function() {
    return 'Exportar para iCal';
  }});

  //  Notifications
  $('.toggle_notifications').tipsy({gravity: 's', offset: 3, title: function() {
    var count = parseInt($(this).text());
    if (count==0)
      return 'No tienes notificaciones';
    else
      if (count>1)
        return count + ' notificaciones';
      else
        return count + ' notificación';
  }});


  //  Notifications
  $('a.settings').tipsy({gravity: 's', offset: 3, title: function() {
    return 'Tu perfil';
  }});

  //  Log out
  $('.sign_out').tipsy({gravity: 's', offset: 3, title: function() {
    return 'Cerrar sesión';
  }});

});
