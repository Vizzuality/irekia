/* Preloading of images */
jQuery.preloadImages = function(){
  for(var i = 0; i < arguments.length; i++){
    jQuery("<img>").attr("src", arguments[i]);
  }
}

/* Hides/shows input placeholders */
jQuery.fn.smartPlaceholder = function(opt){

  var speed  = (opt && opt.speed) || 150;

  this.each(function(){

    var $span  = $(this).find("span.holder");
    var $input = $(this).find(":input");

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


