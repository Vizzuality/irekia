function isEmpty(str) {
  return !str.match(/\S/)
}

function watchHash(opt) {

  var speed  = (opt && opt.speed) || 200;

  if (hash = window.location.hash) {
    if (hash == "#comments") {
      $('html, body').delay(500).animate({scrollTop:$(".comments").offset().top}, speed, function() {
        window.location.hash = '';
      });
    }
  }
}


/* Enables registration process */
jQuery.fn.enableRegistration = function(opt){

  var speed  = (opt && opt.speed) || 200,
  ok = true,
  $form = $(".cycle form"),
  $container = $(".cycle .inner-cycle");

  var $article, $newArticle, $currentArticle;


  function error($article) {
    ok = false;
    $article.effect("shake", { times:4 }, 100);
  }

  function forward($current, $next) {
    $container.animate({height:$next.height() + 45}, 350, "easeInOutQuad");
    $(".cycle").animate({scrollLeft:$current.position().left + 850}, 350, "easeInOutQuad");
  }

  function step3(evt, xhr, status) {
    var $data = $(xhr);

    $currentArticle.after($data);

    $article = $currentArticle;
    $currentArticle = $data;

    forward($article, $currentArticle);
    $form = $currentArticle.find("form");
  }

  function step2(evt, xhr, status) {
    var $data = $(xhr);

    $currentArticle.after($data);

    $article = $currentArticle;
    $currentArticle = $data;

    forward($article, $currentArticle);
    $form = $currentArticle.find("form");

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
    $(".advance").click(function(e) {
      e.preventDefault();

      $article = $(this).parents("article");
      $("html, body").animate({scrollTop:"100px"}, 950, "easeInOutQuad");
      $.ajax({ url: "/users/new", data: {}, type: "GET", success: step1});
    });
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

/* Enables comment submission */
jQuery.fn.enableArguments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    //var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    //var spin_element = document.getElementById('comment_spinner');
    //var spinner = new Spinner(opts);

    //$(this).submit(function(e) {
    //  spinner.spin(spin_element);
    //});

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).parent().siblings("ul");
      var $argument = $(xhr);
      $argument.hide();
      $el.append($argument);
      $argument.slideDown(250);
      // spinner.stop();

      // Reset input
      $(this).find('.input_text input[type="text"]').val("");
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

    $(this).bind('ajax:error', function(e){
      spinner.stop();
      $('#search_submit').show();
    });

    $(this).bind('ajax:success', function(evt, xhr, status){
      var $autocomplete = $(this).find('.autocomplete');
      $autocomplete.addClass("visible");
      $autocomplete.find('div.inner').html(xhr);
      $autocomplete.css("margin-left", "-158px");
      $autocomplete.css("margin-top", "23px");
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

/* Enables comment submission */
jQuery.fn.enableArguments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    //var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    //var spin_element = document.getElementById('comment_spinner');
    //var spinner = new Spinner(opts);

    //$(this).submit(function(e) {
    //  spinner.spin(spin_element);
    //});

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).parent().siblings("ul");
      var $argument = $(xhr);
      $argument.hide();
      $el.append($argument);
      $argument.slideDown(250);
      // spinner.stop();

      // Reset input
      $(this).find('.input_text input[type="text"]').val("");
    });
  });
}


/* Enables comment submission */
jQuery.fn.enableComments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
    var spin_element = document.getElementById('comment_spinner');
    var spinner = new Spinner(opts);

    $(this).submit(function(e) {
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
      $(this).parent().toggleClass("selected");
      $(".view_map").parent().toggleClass("selected");

      $(".agenda_map .map").animate({opacity:0}, speed);
      $(".agenda_map").animate({height:$(".agenda_map .agenda").height()}, speed);
      $(".agenda_map .agenda").fadeIn("fast");
    });
  });
}

/* Click binding for the 'view map' link */
jQuery.fn.viewMap = function(opt){

  var speed      = (opt && opt.speed) || 150;
  var mapHeight  = (opt && opt.mapHeight) || 454;

  this.each(function(){
    $(this).click(function(e) {
      e.preventDefault();
      $(this).parent().toggleClass("selected");
      $(".view_calendar").parent().toggleClass("selected");
      $(".agenda_map").animate({height:mapHeight}, speed);
      $(".agenda_map .map").delay(50).animate({opacity:1}, speed);
      $(".agenda_map .agenda").fadeOut("fast");
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
      setTimeout(function() { (e && e.keyCode == 8 || $input.val()) ?  $span.fadeOut(speed) : $span.fadeIn(speed); }, 0);
    });

    $span.click(function() { $input.focus(); });
    $input.blur(function() { !$input.val() && $span.fadeIn(speed); });
  });
}

/* Allow to count characters in a input à la Twitter */
jQuery.fn.enableCommentBox = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    $(this).submit(function(e) {
      var count = $input.val().length;
      if (count <= 0) {
        return false;
      }
    });

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).siblings("ul");
      var $comment = $(xhr);
      $comment.hide();
      $el.append($comment);
      //  spinner.stop();

      // Reset textarea
      $(this).find('input[type="text"]').val("");
      $(this).find(".holder").fadeIn(speed);
      $comment.slideDown(speed);
      $submit.fadeOut(speed);
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

    var $input = $(this).find(":text, textarea");
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

/* Adds sharing capabilities */
jQuery.fn.share = function(opt){

  var speed  = (opt && opt.speed) || 200;
  var easing = (opt && opt.easing) || 'easeInExpo';

  this.each(function(){
    $(this).bind('click', function(e) {
      e.preventDefault();
      e.stopPropagation();

      var service = $(this).attr('class').replace('share ', '');
      shareWith($(this), service, speed, easing);
    });
  });
}

function shareWith($el, service, speed, easing) {
  var $ok = $el.find(".ok");
  if ($ok) $ok.animate({opacity:0, top:"20px"}, speed, easing, function() { $(this).remove(); })

  $el.append('<div class="ok" />');
  $ok = $el.find(".ok");
  $ok.animate({opacity:1, top:"-2px"}, speed, easing);
}


(function($) {

/*
* Auto-growing textareas; technique ripped from Facebook
*/
  $.fn.autogrow = function(options) {

    var resizing = false;
    this.filter('textarea').each(function() {

      var $this       = $(this),
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
        .replace(/ {2,}/g, function(space) { return times('&nbsp;', space.length -1) + ' ' });

        shadow.html(val);
        if (!resizing) {
          resizing = true;
          var height= Math.max(shadow.height() + 20, minHeight);
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

})(jQuery);

