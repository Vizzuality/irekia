/* Preloading of images */
jQuery.preloadImages = function(){
  for(var i = 0; i < arguments.length; i++){
    jQuery("<img>").attr("src", arguments[i]);
  }
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
jQuery.fn.enableComments = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    $(this).bind('ajax:success', function(evt, xhr, status) {
      var $el = $(this).parents("ul").find("li.comment");
      var $comment = $('<li style="display:none">' + xhr + '</li>');
      $el.before($comment);
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

    $input.keydown(function(e) {
      setTimeout(function() { (e && e.keyCode == 8 || $input.val()) ?  $span.fadeOut(speed) : $span.fadeIn(speed); }, 0);
    });

    $span.click(function() { $input.focus(); });
    $input.blur(function() { !$input.val() && $span.fadeIn(speed); });
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

