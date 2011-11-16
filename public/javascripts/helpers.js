var SPINNER_OPTIONS = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
var IrekiaSpinner = new Spinner(SPINNER_OPTIONS);

function loginInLinks() {
  $(".floating-login").each(function(i, el) {
    $(el).unbind();
    $(el).die();

    if ($(el).hasClass("after_share")) {
      $(el).addClass("share");
      $(el).removeClass("after_share");
      $(el).sharePopover();
    }

    if ($(el).hasClass("after_ask_question")) {
      $(el).addClass("ask_question");
      $(el).removeClass("after_ask_question");
      $(el).questionPopover();
    }

    if ($(el).hasClass("after_create_proposal")) {
      $(el).addClass("create_proposal");
      $(el).removeClass("after_create_proposal");
      $(el).proposalPopover();
    }

    $(el).removeClass("floating-login");
  });
}

String.prototype.trim=function(){return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');};
String.prototype.ltrim=function(){return this.replace(/^\s+/,'');}
String.prototype.rtrim=function(){return this.replace(/\s+$/,'');}
String.prototype.fulltrim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');}

function isEmpty(str) {
  return !str.match(/\S/)
}

function watchHash(opt) {

  var speed  = (opt && opt.speed) || 200;

  function removeHash() {
    if (  $.browser.msie) {
    } else {
      window.history.pushState("", document.title, window.location.pathname);
    }
  }

  if (hash = window.location.hash) {
    if (hash == "#comments") {
      $('html, body').delay(500).animate({scrollTop:$(".comments").offset().top - 10}, speed, function() {
        window.location.hash = '';
        removeHash();
      });
    } else if (hash == "#team" || hash == "#questions" || hash == "#proposals" || hash == "#actions" || hash == "#agenda") {
      $('html, body').delay(500).animate({scrollTop:$("ul.menu").offset().top - 40}, speed, function() {
        removeHash();
      });
    }
  }
}

/* Enables registration process */
jQuery.fn.enableRegistration = function(opt){

  var speed  = (opt && opt.speed) || 200,
  marginBottom = 20,
  $form = $(".cycle form"),
  $container = $(".cycle .inner-cycle");

  var $article, $newArticle, $currentArticle;

  function error($article) {
    ok = false;
    $article.effect("shake", { times:4 }, 100);
  }

  function forward($current, $next) {
    $(".cycle").animate({scrollLeft:$current.position().left + 850}, 350, "easeInOutQuad", function() {
      $container.parent().animate({height:$next.outerHeight(true) + marginBottom}, 350, "easeInOutQuad");
    });
  }

  function step3(evt, xhr, status) {
    var $data = $(xhr);

    $currentArticle.after($data);

    $article        = $currentArticle;
    $currentArticle = $data;
    $form           = $currentArticle.find("form");


    forward($article, $currentArticle);
  }

  function step2(evt, xhr, status) {
    var $data = $($(xhr).find(".inner-cycle").html());

    $currentArticle.after($data);

    $article = $currentArticle;
    $currentArticle = $data;

    forward($article, $currentArticle);
    $form = $currentArticle.find("form");

    $('form .field.born_at select[name="user[birthday(1i)]"]').dropkick({width:-10});
    $('form .field.born_at select[name="user[birthday(2i)]"]').dropkick({width:77});
    $('form .field.born_at select[name="user[birthday(3i)]"]').dropkick({width:-20});

    $form.submit(function() {
      $(this).find(".error").removeClass("error");
    });

    $form.bind('ajax:success', step3);
    $form.bind('ajax:error', validateErrors);
  }

  function step1(data) {
    $currentArticle = $(data);
    $article.after($currentArticle);
    $form = $currentArticle.find("form");
    $form.find('a.checkbox').enableCheckbox();

    $form.submit(function() {
      $(this).find(".error").removeClass("error");
    });

    $form.bind('ajax:success', step2);
    $form.bind('ajax:error', validateErrors);

    forward($article, $currentArticle);
  }

  function validateErrors(evt, xhr, status) {
    var errors = $.parseJSON(xhr.responseText);

    _.each(errors, function(message, field) {
      $currentArticle.find("form ." + field).addClass("error");
    });

    error($currentArticle);
  }

  this.each(function(){
    $article = $container.find("article");

    if ($article.hasClass("step2")) {
      marginBottom = 50;
      $currentArticle = $article;

      $form = $currentArticle.find("form");

      $form.submit(function() {
        $(this).find(".error").removeClass("error");
      });

      $form.bind('ajax:success', step3);
      $form.bind('ajax:error', validateErrors);

    } else {
      $(".advance").click(function(e) {
        e.preventDefault();

        $article = $(this).parents("article");

        $("html, body").animate({scrollTop:"100px"}, 950, "easeInOutQuad");
        $.ajax({ url: "/users/new", data: {}, type: "GET", success: step1});
      })
    }
  });
}

/* Enables checkboxes */
jQuery.fn.enableCheckbox = function(opt){

  this.each(function(){

    $(this).click(function(e){
      e.preventDefault();
      if (!$(this).hasClass('selected')) {
        $(this).addClass('selected');
        $(this).closest('p').find('input[type="checkbox"]').val(1).attr('checked', true);
      } else {
        $(this).removeClass('selected');
        $(this).closest('p').find('input[type="checkbox"]').val(0).attr('checked', false);
      }
    });

  });
}

jQuery.fn.enableOpinion = function(opt){

  this.each(function(){

  $(this).find("input[type='submit'], .my_opinion button").click(function(e) {
      $(".my_opinion .selected").removeClass("selected");
      $(this).addClass("selected");
      console.log($(this));
  });

  $(this).find("form").bind('ajax:success', function(evt, xhr, status) {
    $(this).parents(".my_opinion").find(".result").fadeOut(250, function() {
      $(this).html(xhr);

      $(this).parent().removeClass("in_favor");
      $(this).parent().removeClass("against");
      $(this).parent().addClass($(xhr).attr('class'));

      $(this).fadeIn(250);
    });
  });


  });
}

/* Enables comment submission */
jQuery.fn.enableArguments = function(opt){

  var speed     = (opt && opt.speed) || 200;
  var duration  = (opt && opt.speed) || 3000;
  var maxHeight = 0;

  this.each(function(){
    if (($(this).find("ul").height()) > maxHeight) {
      maxHeight = $(this).find("ul").height();
    }
  });

  this.each(function(){

    $(this).find("ul").animate({height:maxHeight});

    var that = this;

    var spin_element = $(that).hasClass("in_favor") ? document.getElementById('spinner_in_favor') : document.getElementById('spinner_against');
    var spinner      = new Spinner(SPINNER_OPTIONS);

    var $input       = $(this).find('.input_text input[type="text"]');
    var $submit      = $(this).find('.new_argument input[type="submit"]');
    var $icon;

    $submit.click(function(e) {

      if (isEmpty($input.val())) {
        e.preventDefault();
        return false;
      }

      spinner.spin(spin_element);
      $submit.hide();
      $input.addClass("disabled");

      setTimeout(function() {
        $input.attr("disabled", "disabled");
      }, 150);
    });

    function showIcon(noticeType) {

      $(that).append($("#notice_" + noticeType));
      $("#notice_" + noticeType).css("bottom", "75px");
      $("#notice_" + noticeType).css("right", "-42px");
      $("#notice_" + noticeType).fadeIn(250);

      setTimeout(function() {
        $("#notice_" + noticeType).fadeOut(speed);
        $icon.fadeOut(speed, function() {
          $input.removeAttr("disabled");
          $submit.fadeIn(speed);
          $(this).remove();
          $input.val('');
          $input.removeClass('disabled');
        });
      }, duration);
    }

    $(this).find(".new_argument").bind('ajax:error', function(evt, xhr, status) {
      spinner.stop();
      $icon = $("<span class='icon error' />");
      $(that).find(".footer .input_text").append($icon);

      showIcon("against");
    });

    $(this).find(".new_argument").bind('ajax:success', function(evt, xhr, status) {
      spinner.stop();

      $icon = $("<span class='icon success' />");
      $(that).find(".footer .input_text").append($icon);
      showIcon("in_favor");
    });
  });
}

/* Preloading of images */
jQuery.preloadImages = function(){
  for(var i = 0; i < arguments.length; i++){
    jQuery("<img>").attr("src", arguments[i]);
  }
}

/* Autocomplete */
jQuery.fn.autocomplete = function(opt){

  var speed  = (opt && opt.speed) || 200;
  var interval;
  var id = "autocomplete";

  // Autocomplete spinner
  var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
  var spin_element = document.getElementById('autocomplete_spinner');
  var spinner = new Spinner(opts);

  function _close(e) {
    GOD.broadcast('close.' + id);
    $('.autocomplete').fadeOut();
  }

  this.each(function(){
    $(window).bind('close.autocomplete', _close);

    $('.autocomplete').click(function(e){
      e.stopPropagation();
    });

    $(this).bind('ajax:error', function(evt, xhr, status){
      spinner.stop();
      $('#search_submit').show();
    });

    $(this).bind('ajax:success', function(evt, xhr, status){

      var $autocomplete = $(this).find('.autocomplete');
      $autocomplete.addClass("visible");
      $autocomplete.find('div.inner').html(xhr);

      if ($(xhr).length == 0) {
        $autocomplete.addClass("no_result");
        $autocomplete.css("margin-left", 0);
        $autocomplete.css("margin-top", "13px");
      } else {
        $autocomplete.removeClass("no_result");
        $autocomplete.css("margin-left", "-128px");
        $autocomplete.css("margin-top", "23px");
      }

      spinner.stop();
      $('#search_submit').show();
      $autocomplete.fadeIn("fast");
      GOD.subscribe('close.' + id);
    });

    $(this).click(function() {
      // If user types more than 2 letters, submit form
      $(this).find('input[type="text"]').keyup(function(ev){
        clearTimeout(interval);
        if ($(this).val().length>2) {
          if (ev.keyCode == 13) {
            window.location = '/search?' + $(this).closest('form').serialize();
            return;
          }
          spinner.stop();
          interval = setTimeout(function(){
            spinner.spin(spin_element);
            $('#search_submit').hide();
            $('nav form').submit();
          },speed);
        } else {
          var $autocomplete = $(this).closest('form').find('.autocomplete');
          $autocomplete.fadeOut("fast");
        }
      });
    });
  });
}

/* Moves the page to the comments area */
jQuery.fn.enableGotoComments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){
    $(this).click(function(e) {
      e.preventDefault();
      $('html, body').animate({scrollTop:$(".comments").offset().top}, speed);
    });
  });
}

jQuery.fn.enablePagination = function(opt){

  var speed      = (opt && opt.speed) || 200;
  var name       = (opt && opt.name)  || "proposals";
  var cellHeight = (opt && opt.cellHeight)  || 132;
  var currentPage = 1;
  var url, id, $article, spin_element;

  function paginateMonths() {
    $.ajax({url: url, method: 'GET', data:{ next_month: currentPage++ }, success:function(response, xhr, status) {
      IrekiaSpinner.stop();

      var $content = $($(response).html());
      var $ul = $article.find(".agenda_map ul.agenda");

      $content.hide();
      $ul.append($content);
      var height = ($(response).find("li").length / 7) * cellHeight + $ul.parent().height();

      $ul.parent().animate({height: height }, 500);
      $content.slideDown(speed);
      $ul.find(".show_event").infoEventPopover();
    }});
  }

  function paginate() {
    $.ajax({url: url, method: 'GET', data:{ page: ++currentPage }, success:function(response, xhr, status) {

      IrekiaSpinner.stop();

      try {
        var $content = $($(response).html());
        $content.hide();

        var $ul = $article.find(".listing_" + name  + "_" + id + " > ul");
        $ul.append($content);
        $content.slideDown(250);
      } catch(err) { }
    }});
  }

  this.each(function(){

    $(this).click(function(e) {
      e.preventDefault();

      url = window.location.href;
      if (name != "months") {
        id = $(this).attr("id").replace(name + '_', '');
      }
      $article = $(this).parents("article");

      spin_element = document.getElementById(name + '_spinner');
      IrekiaSpinner.spin(spin_element);

      if (name == "months") paginateMonths();
      else paginate();

    });
  })
}

jQuery.fn.enableNotificationSelector = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    $(this).find("li").click(function(e) {
      e.preventDefault();
      $(this).siblings("li.selected").removeClass("selected")
      $(this).addClass("selected")
      // TODO: add ajax communication
    });
  });
}

/* Enables comment submission */
jQuery.fn.enableComments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  function disableSubmit($submit) {
    if ($submit) {
      $submit.addClass("disabled");
      $submit.attr("disabled", "disabled");
    }
  }

  function enableSubmit($submit) {
    if ($submit) {
      $submit.removeAttr('disabled');
      $submit.removeClass("disabled");
    }
  }

  function textCounter($input, $submit) {
    var count = $input.val().length;
    (count <= 0) ? disableSubmit($submit) : enableSubmit($submit);
  }

  this.each(function(){

    var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    var spin_element = document.getElementById('comment_spinner');
    var spinner = new Spinner(opts);
    var $input  = $(this).find("textarea");
    var $submit = $(this).find('button');

    disableSubmit($submit);

    $input.keyup(function(e) {
      textCounter($input, $submit);
    });

    $input.keydown(function(e) {
      textCounter($input, $submit);
    });

    $(this).submit(function(e) {
      if (isEmpty($input.val())) {
        e.preventDefault();
        return false;
      }
      disableSubmit();
      spinner.spin(spin_element);
    });

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).parents("ul").find("li.comment");
      var $comment = $(xhr);
      $comment.hide();
      $el.before($comment);
      spinner.stop();

      // Reset textarea
      $(this).find("textarea").val("");
      $(this).find(".holder").fadeIn(speed);
      $comment.slideDown(speed);
      disableSubmit($submit);
    });
  });
}

/* Show previous hidden comments */
jQuery.fn.showHiddenComments = function(opt){

  var delay  = (opt && opt.delay) || 300;
  var speed  = (opt && opt.speed) || 200;

  this.each(function(){
    $(this).click(function(e){
      e.preventDefault();
      $(this).closest("ul").find("li.previous").each(function(i, comment) {
        $(comment).delay(i * delay).slideDown(speed);
      })
    });
  });
}

/* Click binding for the 'view calendar' link */
jQuery.fn.viewCalendar = function(opt){

  var speed  = (opt && opt.speed) || 150;

  this.each(function(){
    $(this).click(function(e){
      e.preventDefault();
      if ($(this).parent().hasClass("selected")) return;

      $(this).parent().toggleClass("selected");
      $(".view_map").parent().toggleClass("selected");

      $(".agenda_map .map").animate({opacity:0, height:"200px"}, speed);
      $(".agenda_map").animate({height:$(".agenda_map .agenda").height()}, speed);
      $(".agenda_map .agenda").fadeIn("fast");
    });
  });
}

/* Click binding for the 'view map' link */
jQuery.fn.viewMap = function(opt){

  var speed      = (opt && opt.speed) || 150;
  var mapHeight  = (opt && opt.mapHeight) || 454;
  var preloaded  = false;

  this.each(function(){
    $(this).click(function(e) {

      e.preventDefault();
      if ($(this).parent().hasClass("selected")) return;

      $(this).parent().toggleClass("selected");
      $(".view_calendar").parent().toggleClass("selected");
      $(".agenda_map .map, .agenda_map").animate({height:mapHeight}, speed);
      $(".agenda_map .map").animate({opacity:1}, speed);
      $(".agenda_map .agenda").fadeOut("fast");
      if (!preloaded) { setTimeout(function() { preloaded = true; startMap(); }, 100); }
    });
  });
}


/* Hides/shows input placeholders */
jQuery.fn.smartPlaceholder = function(opt){

  var speed  = (opt && opt.speed) || 150;

  this.each(function(){

    var $span  = $(this).find("span.holder");
    var $input = $(this).find(":input").not("input[type='hidden'], input[type='submit']");

    if ($input.val()) {
      $span.hide();
    }

    $input.keydown(function(e) {

    //  if (e.keyCode == 86) { // alt-x
    //    $span.fadeOut(speed);
    //  } else if (e.keyCode == 88) { // alt-x
    //    $span.fadeIn(speed);
    //  } else {
        setTimeout(function() { ($input.val()) ?  $span.fadeOut(speed) : $span.fadeIn(speed); }, 0);
     // }
    });

    $span.click(function() { $input.focus(); });
    $input.blur(function() { !$input.val() && $span.fadeIn(speed); });
  });
}

/* Allow to count characters in a input à la Twitter */
jQuery.fn.enableCommentBox = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    var $that = $(this);

    var submitting = false;
    var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    var spin_element = document.getElementById('spinner_' + $(this).attr("id"));
    var spinner = new Spinner(opts);

    var $input = $(this).find(':text, textarea');
    var $submit = $(this).find('input[type="submit"]');
    $(this).submit(function(e) {
      var count = $input.val().length;
      if (count <= 0) {
        return false;
      } else {
        spinner.spin(spin_element);
        setTimeout(function(){
          $input.attr("disabled", "disabled");
        }, 10);
        $input.blur();
        $submit.fadeOut(speed);
      }
    });

    function resetInput() {
      $input.val("");
      $input.removeAttr('disabled');
      $input.blur();
      $input.find(".holder").fadeIn(speed);
    }

    $(this).bind('ajax:error', function(evt, xhr, status) {
      spinner.stop();
      resetInput();
    });

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).siblings("ul");
      var $comment = $(xhr);

      // Add new comment
      $comment.hide();
      $el.append($comment);
      $comment.slideDown(speed);

      spinner.stop();
      resetInput();
    });

    function textCounter($input) {
      var count = $input.val().length;

      if (count <= 0) {
        $submit.fadeOut(speed);
        $submit.attr('disabled', 'disabled');
      } else {
        $submit.removeAttr('disabled');
        $submit.fadeIn(speed);
      }
    }

    var $submit = $(this).find('input[type="submit"]');

    $input.keyup(function(e) {
      textCounter($input);
    });

    $input.keydown(function(e) {
      textCounter($input);
    });

  });
}
/* Allow to count characters in a input à la Twitter */
jQuery.fn.inputCounter = function(opt){

  var limit  = (opt && opt.limit) || 140;

  this.each(function(){

    function textCounter(id, $input, $counter, maxlimit) {
      var count = maxlimit - $input.val().length;

      if (count < 0 || count == limit) {
        if (count < 0) $counter.addClass("error");
        if (count == limit) $counter.removeClass("error");
        $("#submit-" + id).addClass("disabled");
        $("#submit-" + id).attr('disabled', 'disabled');
      } else {
        $counter.removeClass("error");
        $("#submit-" + id).removeClass("disabled");
        $("#submit-" + id).removeAttr('disabled');
      }

      $counter.html(count);
    }

    var id = $(this).attr('id') || $(this).attr('name');
    var $counter  = $(this).find(".counter");
    var $input = $(this).find(":text, textarea");

    $input.keyup(function(e) {
      textCounter(id, $input, $counter, limit);
    });

    $input.keydown(function(e) {
      textCounter(id, $input, $counter, limit);
    });

  });
}

// /* Adds sharing capabilities */
// jQuery.fn.share = function(opt){
//
//   var speed   = (opt && opt.speed)  || 200;
//   var easing  = (opt && opt.easing) || 'easeInExpo';
//   var finishedSharing = true;
//
//   this.each(function(){
//     var service = $(this).attr('class').replace('share ', '');
//
//     $(this).bind('click', function(e) {
//       e.preventDefault();
//       e.stopPropagation();
//
//       if (finishedSharing) {
//         //finishedSharing = shareWith($(this), service, speed, easing);
//       }
//     });
//   });
// }

jQuery.fn.autogrow = function(options){

  var resizing = false;
  this.filter('textarea').each(function() {

    var $this   = $(this),
    minHeight   = $this.height(),
    lineHeight  = $this.css('lineHeight');

    var shadow = $('<div></div>').css({
      position:   'absolute',
      top:        -10000,
      left:       -10000,
      width:      $(this).width() - parseInt($this.css('paddingLeft')) - parseInt($this.css('paddingRight')),
      fontSize:   $this.css('fontSize'),
      fontFamily: $this.css('fontFamily'),
      lineHeight: $this.css('lineHeight'),
      resize:     'none'
    }).appendTo(document.body);

    var update = function() {
      var times = function(string, number) {
        var _res = '';
        for(var i = 0; i < number; i ++) {
          _res = _res + string;
        }
        return _res;
      };

      var val = this.value.replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/&/g, '&amp;')
      .replace(/\n$/, '<br/>&nbsp;')
      .replace(/\n/g, '<br/>')
      .replace(/ {2,}/g, function(space) { return times('&nbsp;', space.length - 1) + ' ' });

      shadow.html(val);

      if (!resizing) {
        resizing = true;
        var height= Math.max(shadow.height() + 15, minHeight);
        $(this).animate({height: height}, 50, function() {
          resizing = false;
        });
      }
    }

    $(this).change(update).keyup(update).keydown(update);
    update.apply(this);
  });
  return this;
}


jQuery.fn.verticalHomeLoop = function(opt){

  if (this.length < 1) return;

  var ele = this,
  onElement = false,
	interval = null;

  function loopContent() {
    if ($(ele).find('div.left ul li').size()>0 && !onElement) {
      var last = $(ele).find('div.left ul li.loop').last();
      var list = $(ele).find('div.left ul').first();
      var height = last.height();
      last.css({opacity:0,height:0}).removeClass('loop');
      list.prepend(last);
      last.animate({height:height+'px'},500,function(){
        $(this).animate({opacity:1},300);
      });
      var last_vi = $(ele).find('div.left > div.listing > ul > li').not('.loop').last().addClass();
      last_vi.animate({height:0,opacity:0},500,function(){
        $(this).addClass('loop').removeAttr('style');
      });
    }
  }

  $(ele).find('div.left > ul').hover(function(){
    onElement = true;
  },function(){
    onElement = false;
  });

	$(window).blur(function(){
	  clearInterval(interval);
		interval = null;
	});
	$(window).focus(function(){
		if (!interval) {
		  interval = setInterval(function(){loopContent()},5000);
		}
	});

	interval = setInterval(function(){loopContent()},5000);
}
