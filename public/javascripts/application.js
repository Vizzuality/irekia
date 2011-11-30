$(function() {

  watchHash(); // this function watches the url hashes and acts accordingly

  // Preloading of popover assets
  // $.preloadImages("/images/box_mini_bkg.png", "/images/box_micro_bkg.png");

  $('.home_last_activity').verticalHomeLoop();



  function _setupUpload(id, callback) {

    $span  = $("#" + id);

    if ($span.length > 0) {

      var speed     = 100;
      var $uploader = $(".uploader");

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: $span.attr('data-url'),
				params: {
					utf8: $span.closest('form').find('input[name=utf8]').val(),
					authenticity_token: $span.closest('form').find('input[name=authenticity_token]').val()
				},
        debug: true,
        text:"sube una nueva",
        onSubmit: function(id, fileName){
          //data.spinner.spin(spin_element);

					$(".progress").show();
          $uploader.find(".percentage").css("color", "#FF0066");
					$uploader.find("input").blur();
          $uploader.find(".holder").fadeOut(speed);
          $uploader.find(".loading, .percentage").fadeIn(speed);
        },
        onProgress: function(id, fileName, loaded, total){
					var p = ((parseFloat(arguments[2]) / parseFloat(arguments[3])) * 100);
					var width = parseInt(665 * parseInt(p, 10) / 100, 10);

          console.log("uploading…");
					//console.debug(p, width, arguments, arguments[2], arguments[3]);

					if (parseInt(p) >= 75) $uploader.find(".loading").fadeOut(speed);
					if (parseInt(p) >= 46) $uploader.find(".percentage").css("color", "#fff");

          $uploader.find(".percentage").html(parseInt(p, 10) + "%");
				  $(".progress").css("width", width);
				},
        onComplete: function(id, fileName, responseJSON){
          //data.spinner.stop();

          console.log("complete");
					//console.debug(fileName, responseJSON, responseJSON.image_cache_name);

          $uploader.find(".loading").fadeOut(speed);
          $uploader.find(".holder").fadeIn(speed);
          $uploader.find(".percentage").fadeOut(speed);

          var cacheImage = document.createElement('img');
          cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;

					$('.image_cache_name').val(responseJSON.image_cache_name);

          $(cacheImage).bind("load", function () {

            $(".image_container").prepend(cacheImage);
            $(".image_container").fadeIn(speed);
            $(".image_container img").fadeIn(speed);

            $uploader.fadeOut(speed, function() {
              callback && callback();
            });

          });

          $uploader.find(".progress").fadeOut(speed, function() {
            $(this).width(0);
          });
				},
        onCancel: function(id, fileName){ }
      });
    }
  }

      _setupUpload("upload_new_image");

  // Editing tools
  $(".editable.text").enableTextEditing();
  $(".editable.date").enableDateEditing();
  $(".editable.image").enableImageEditing();
  $(".editable.location .footer").enableLocationEditing();

  $(".right .tags.editable").enableEditTags();
  $(".people.editable").enablePoliticianTags();
  $(".context ul.editable.tags").enableAreaEditing();

  $('.tabs').tabs();

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

  $(".make_question").enableQuestion();

  $(".user_publish").userPublishPopover();
  $(".politician_publish").politicianPublishPopover();
  $(".create_proposal").proposalPopover();
  $(".auth a.login").loginPopover();
  $(".share.inline, .share.more, .share.email").sharePopover();

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
