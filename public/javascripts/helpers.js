// general spinner configuration
var SPINNER_OPTIONS = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
var IrekiaSpinner = new Spinner(SPINNER_OPTIONS);

// String methods
String.prototype.trim=function(){return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');};
String.prototype.ltrim=function(){return this.replace(/^\s+/,'');}
String.prototype.rtrim=function(){return this.replace(/\s+$/,'');}
String.prototype.fulltrim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');}

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

function isEmpty(str) {
  if (str) {
    return !str.match(/\S/)
  } else { return true; }
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
      $('html, body').delay(500).animate({scrollTop:$("div.comments").offset().top - 10}, speed, function() {
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

  function redirectToRoot(evt, xhr, status) {
    window.location.href = '/';
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

    $form.bind('ajax:success', redirectToRoot);
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
    $article = $container.find(".article");

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

        $article = $(this).parents(".article");

        $("html, body").animate({scrollTop:"100px"}, 950, "easeInOutQuad");
        $.ajax({ url: "/users/new", data: {}, type: "GET", success: step1});
      })
    }
  });
}

jQuery.fn.enableSlideshow = function(opt){

  var
  speed        = (opt && opt.speed) || 100,
  controlSpeed = (opt && opt.speed) || 250,
  $this        = $(this),
  width        = 610,
  pos          = 0,
  section      = 0,
  sectionNum,
  disabledControls = false;

  sectionNum = $this.find(".section").length;

  function _updateHeight(s, callback) {
    var height = $this.find(".section:eq(" + s + ")").height();

    $this.find(".inner_slideshow").animate({ height:height }, speed, function() {
      callback && callback();
    });
  }

  function _positionControls() {
    var h  = $this.outerHeight(true);
    var ah = $this.find(".slideshow_controls a").height();
    $this.find(".slideshow_controls a").css("top", (h / 2) - (ah)  + "px");
  }

  function _enableControls() {
    disabledControls = false;
    _showControls();
    _showVideoControls();
  }

  function _disableControls() {
    disabledControls = true;
    _hideVideoControls();
    _hideControls();
  }

  function _toggleVideoControls() {
    if (disabledControls) return;

    if ($this.find(".section:eq(" + section + ") .options").length > 0) {
      _showVideoControls();
    } else {
      _hideVideoControls();
    }
  }

  function _showVideoControls() {
    if (disabledControls) return;
    if ($this.find(".section:eq(" + section + ") .options").length > 0) {
      $this.find(".options").fadeIn(controlSpeed);
    }
  }

  function _hideVideoControls(force) {
    $this.find(".options").fadeOut(controlSpeed);
  }

  function _showControls() {
    if (disabledControls) return;
    _showVideoControls();
    $this.find(".slideshow_controls").fadeIn(controlSpeed);
  }

  function _hideControls() {
    _hideVideoControls(true);
    $this.find(".slideshow_controls").fadeOut(controlSpeed);
  }

  function _toggleControls(s) {
    if (s + 1 >= sectionNum) {
      _hideControl("next");
      _showControl("prev");
    } else  if (s <= 0) {
      _hideControl("prev");
      _showControl("next");
    } else {
      _showControl("prev");
      _showControl("next");
    }
  }

  function _hideControl(name) {
    $this.find(".slideshow_controls ." + name).addClass("disabled");
  }

  function _showControl(name) {
    if (disabledControls) return;
    $this.find(".slideshow_controls ." + name).removeClass("disabled");
  }

  function _positionNavigation(s) {
    var p = $this.find(".section:eq(" + s + ") .caption").position().top + 13;

    $this.find(".navigation").hide(10, function() {
      $this.find(".navigation").css({top: p + "px"});
    });
  }

  function _setupNavigation() {
    var b = $this.find(".section:eq(0)").height() - $this.find(".section:eq(0) .caption").height();

    for (var i = 0; i <= sectionNum - 1; i++) {
      $this.find(".navigation").append('<li><a href="#"></a></li>');
    }

    $this.find(".navigation li:first-child").addClass("selected");
    $this.find(".navigation").css({top: b + 7 + "px"});
    $this.find(".navigation").fadeIn(speed);
  }

  function _updateNavigation() {
    $this.find(".navigation li").removeClass("selected");
    $this.find(".navigation li:eq(" + section + ")").addClass("selected");
  }

  function _move(s) {
    //$this.find(".navigation").hide();

    _updateHeight(s, function() {
      $this.find(".section:eq(" + s + ") .caption").fadeOut(speed, function() {
        $this.find(".inner_slideshow").animate({scrollLeft: s * width}, speed, function() {
          _toggleVideoControls();
          _toggleControls(s);
          _updateNavigation();
          $this.find(".section:eq(" + s + ") .caption").fadeIn(speed, function() {
            //_positionNavigation(section);
            $this.find(".navigation").show();
          });
        });
      });
    });
  }

  $this.find(".next").click(function(e) {
    e.preventDefault();
    if ($(this).hasClass("disabled")) return;
    if (section + 1 < sectionNum) section++;
    _move(section);
  });

  $this.find(".prev").click(function(e) {
    e.preventDefault();
    if ($(this).hasClass("disabled")) return;
    if (section - 1 >= 0) section--;
    _move(section);
  });

  $this.find(".navigation li a").live("click", function(e) {
    e.preventDefault();
    section = $this.find(".navigation li").index($(this).parent());
    _move(section);
  });

  $this.find(".embed_window a.close").click(function(e) {
    e.preventDefault();
    $this.find(".embed_window").fadeOut(speed);
    _enableControls();
  });

  $this.find(".options li.embed a").click(function(e) {
    e.preventDefault();

    _disableControls();

    var h  = $this.outerHeight(true);
    var w  = $this.outerWidth(true);
    var l  = (w / 2) - ($this.find(".embed_window").width() / 2);

    var embed_code = $this.find(".section:eq(" + section + ") textarea").html();
    $this.find(".embed_window textarea").html(embed_code);
    $this.find(".embed_window").css({ top: 20 + "px", left: l });
    $this.find(".embed_window").fadeIn(speed);
  });

  $this.find(".options .handle").click(function(e) {
    e.preventDefault();
  });

  $this.find(".options").bind("mouseenter", function() {
    if (disabledControls) return;
    $(this).find("> a").fadeOut(speed);
    $(this).find(".inner_options").fadeIn(speed);
  });

  $this.find(".options").bind("mouseleave", function() {
    $(this).find("> a").fadeIn(speed);
    $(this).find(".inner_options").fadeOut(speed);
  });

  $this.bind("mouseenter", function() {
    _showControls();
  });

  $this.bind("mouseleave", function() {
    _hideControls();
  });

  _positionControls();
  _setupNavigation();
  _updateHeight(0);
}

/* Enables politician taggin */
jQuery.fn.enablePoliticianTags = function(opt){
  var
  serviceURL = "/search/politicians_and_areas",
  speed     = (opt && opt.speed) || 100,
  interval,
  spin_element   = document.getElementById('politician_spinner'),
  spinner        = new Spinner(SPINNER_OPTIONS),
  fadeInSpeed    = (opt && opt.speed) || 10,
  $ul            = $(this),
  $add           = $ul.find(".add"),
  $remove        = $ul.find("input.remove"),
  $addLink       = $add.find("a"),
  $addInputField = $add.find(".input_field"),
  $addInput      = $add.find('input[type="text"]');

  $(window).bind('_close.politician_suggest', function() {
    _hidePopover();
  });

  function _onSuccess(response) {
    GOD.subscribe("_close.politician_suggest");
    GOD.broadcast("_close.politician_suggest");

    _hidePopover();
    _appendPopover(response);
  }

  function _hidePopover() {
    spinner.stop();

    if ($(".autosuggest.mini").length > 0 ) {
      $(".autosuggest.mini").fadeOut(speed, function() { $(this).remove(); });
    }
  }

  function _centerPopover($response) {
    var left =  $add.position().left - ($response.outerWidth(true) / 2) + ($add.outerWidth(true) / 2);
    var top  =  $add.position().top  + $add.outerHeight(true) + 8;

    $response.css({left: left + "px", top: top + "px"});
  }

  function _appendPopover(response) {

    var $response = $(response);

    if ($response.find("ul li").length > 0) {

      $response.addClass("mini");
      $ul.after($response);
      _centerPopover($response);
      $response.hide();
      $response.fadeIn(speed, function() {
        spinner.stop();
      });
    } else {
      spinner.stop();
    }
  }

  function _observeInput($input) {

    function _do(e) {

      if ($input.val().length <= 0) {
        _hidePopover();
      } else {

        if (_.any([13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return e.keyCode == i } ) && (e.keyCode == 65 && (e.metaKey || e.ctrlKey))) { return; }
        if ($addInput.val().length > 3) _onKeyUp(e);
      }
    }

    $input.keyup(_do);
    $input.keydown(_do);
  }

  function _onKeyUp(e){

    clearTimeout(interval);

    interval = setTimeout(function(){
      if ($addInput.val().length > 0) spinner.spin(spin_element);

      var query = $addInput.val();
      var params = { name : query, only_politicians : true };

      $.ajax({ url: serviceURL, data: { search: params }, type: "GET", success: _onSuccess});
    }, 500);
  }

  $remove.live("click", function (e) {
    $(this).parents("li").fadeOut(speed);
  });

  $addLink.click(function(e) {
    e.preventDefault();
    $(this).fadeOut(speed, function() {
      $addInputField.fadeIn(fadeInSpeed, function() {
        $addInput.focus();
      });
    });
  });

  //$addInput.keyup(_onKeyUp);
 _observeInput($addInput);

 $add.find(".add_politician").bind('ajax:success', function(evt, xhr, status) {
   var $response = $(xhr);
   $response.hide();
   $addInputField.parents("li").before($response);
   $response.fadeIn(speed);
 });

  $(".autosuggest.mini li").live("click", function() {
    var pID = $(this).attr("data-id");

    $addInput.val("");
    _hidePopover();

    $add.find(".add_politician #editable_politician_id").attr("value", pID);
    $add.find(".add_politician").submit();
  });
}

/* Enables text editing */
jQuery.fn.enableTextEditing = function(opt){

  this.each(function(){
    var $form = $(this);

    var speed     = (opt && opt.speed) || 120,
    fadeInSpeed   = (opt && opt.speed) || 80,
    spinner       = new Spinner(SPINNER_OPTIONS),
    content;

    $form.find(".content").click(function() {
      var that = $(this).parent();

      $form.find(".content").slideUp(speed);
      that.find('.input_field').slideDown(speed, function() {
        that.find('.submit').fadeIn(fadeInSpeed);
        that.find('.input_field :text, .input_field textarea').focus();
      });
    });

    $form.bind('ajax:success', function(evt, xhr, status) {
      $form.find(".content").html(content);
      $form.find(".content").slideDown(fadeInSpeed);
      $form.find('.input_field').slideUp(speed);
      $form.find('.submit').fadeOut(speed);
      $form.find('.submit').removeClass("disabled");
      $form.find('.submit').removeAttr("disabled");
    });

    $form.submit(function(e) {
      content = $form.find('.input_field :text, .input_field textarea').val();
      $form.find('.submit').addClass("disabled");
      $form.find('.submit').attr("disabled", "disabled");
    });
  });
}

/* Enables image editing */
jQuery.fn.enableImageEditing = function(opt){
  var
  $this       = $(this),
  speed       = (opt && opt.speed) || 120,
  fadeInSpeed = (opt && opt.speed) || 80,
  spinner     = new Spinner(SPINNER_OPTIONS),
  content;

  $(this).find("form.remove").submit(function(e) {
    $this.find(".image_container form.remove").fadeOut(speed);
    $this.find(".image_container img").fadeOut(speed, function() {
      $(this).remove();
      $this.find(".add_image").fadeIn(speed);
    });
  });

  $(this).find(".add_image a").click(function(e) {
    e.preventDefault();

    _setupUpload("upload_new_image");

    var $form = $(this).parents("form");
    $(this).parent().slideUp(speed);
    $this.find(".input_field").fadeIn(speed);
  });

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
        text: $span.html(),
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
					var width = parseInt(585 * parseInt(p, 10) / 100, 10);

          console.log("uploading…");
					//console.debug(p, width, arguments, arguments[2], arguments[3]);

					if (parseInt(p) >= 75) $uploader.find(".loading").fadeOut(speed);
					if (parseInt(p) >= 46) $uploader.find(".percentage").css("color", "#fff");

          $uploader.find(".percentage").html(parseInt(p, 10) + "%");
				  $(".progress").css("width", width);
				},
        onComplete: function(id, fileName, responseJSON){
          //data.spinner.stop();

					console.debug(fileName, responseJSON, responseJSON.image_cache_name);

          $uploader.find(".loading").fadeOut(speed);
          $uploader.find(".holder").fadeIn(speed);
          $uploader.find(".percentage").fadeOut(speed);

          var cacheImage = document.createElement('img');
          cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;

					$('.image_cache_name').val(responseJSON.image_cache_name);

          //console.log($(".image_cache_name"));

          $(cacheImage).bind("load", function () {

            $this.find(".image_container").prepend(cacheImage);
            $this.find(".image_container").fadeIn(speed);
            $this.find(".image_container img").fadeIn(speed);
            $this.find(".image_container form.remove").fadeIn(speed);

            //$uploader.find("form #image_attributes").val()

            $uploader.fadeOut(speed, function() {
              $uploader.find("form").submit();
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
}

/* Enables date editing */
jQuery.fn.enableDateEditing = function(opt){
  var speed     = (opt && opt.speed) || 120,
  fadeInSpeed   = (opt && opt.speed) || 80,
  spinner       = new Spinner(SPINNER_OPTIONS),
  content;

  $(this).click(function() {

    if ($(this).find(".dk_container").length > 0) {
      $(this).find(".dk_container").slideDown(speed);
    } else {
      $(this).find('select:eq(0)').dropkick({width:-20});
      $(this).find('select:eq(1)').dropkick({width:77});
      $(this).find('select:eq(2)').dropkick({width:-10});
    }

    $(this).find(".content").slideUp(speed);
    $(this).find('.submit').fadeIn(fadeInSpeed);
    //$(this).find('.input_field :text, .input_field textarea').focus();
  });

  $(this).bind('ajax:success', function(evt, xhr, status) {
    // $(this).find(".content").html(content);
    $(this).find('.dk_container').slideUp(speed);
    $(this).find(".content").slideDown(fadeInSpeed);
    $(this).find('.submit').fadeOut(speed);
    $(this).find('.submit').removeClass("disabled");
    $(this).find('.submit').removeAttr("disabled");
  });

  $(this).submit(function(e) {
    //content = $(this).find('.input_field :text, .input_field textarea').val();
    $(this).find('.submit').addClass("disabled");
    $(this).find('.submit').attr("disabled", "disabled");
  });
}

/* Enables tag editing */
jQuery.fn.enableEditTags = function(opt){
  var speed     = (opt && opt.speed) || 100,
  fadeInSpeed   = (opt && opt.speed) || 10,
  $ul  = $(this),
  $new = $ul.find(".new"),
  $add = $(this).find(".add");

  // submit tag

  $new.bind('ajax:success', function(e, response) {
    var $tag = $(response);
    $tag.hide();
    $add.before($tag);
    $tag.fadeIn(250);
  });

  $new.find("form").submit(function(e) {
    $new.fadeOut(speed, function() {
      $ul.find(".new").fadeIn(fadeInSpeed, function() {
        $(this).find('input[type="text"]').val("");
        $(this).find('input[type="text"]').focus();
      });
    });
  });

  // add tag
  $add.find("a").live("click", function(e){
    e.preventDefault();
    $new.find('input[type="text"]').val("");
    $(this).parent().fadeOut(speed, function() {
      $ul.find(".new").fadeIn(fadeInSpeed, function() {
        $(this).find('input[type="text"]').focus();
      });
    });
  });

  // remove tag
  $(this).find("form.remove").live("submit", function(e){
    $(this).parent().fadeOut(speed, function() {
      $(this).remove();
    });
  });
}

/* Enables radio buttons */
jQuery.fn.enableRadio = function(opt){
  this.each(function(){
    var $this = $(this);

    $this.find("a.radio").click(function(e){
      console.log($(this));
      e.preventDefault();
      $this.find("a.radio").removeClass("selected");
      $(this).addClass('selected');
      $this.find('input[type="radio"]').val(0).attr('checked', false);
      $(this).find('input[type="radio"]').val(1).attr('checked', true);
    });
  });
}
/* Enables radio buttons */
jQuery.fn.enableRadio = function(opt){
  this.each(function(){
    var $this = $(this);

    $this.find("a.radio").click(function(e){
      console.log($(this));
      e.preventDefault();
      $this.find("a.radio").removeClass("selected");
      $(this).addClass('selected');
      $this.find('input[type="radio"]').val(false).attr('checked', false);
      $(this).find('input[type="radio"]').val(true).attr('checked', true);
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
        $(this).closest('p, div').find('input[type="checkbox"]').val(1).attr('checked', true);
      } else {
        $(this).removeClass('selected');
        $(this).closest('p, div').find('input[type="checkbox"]').val(0).attr('checked', false);
      }
    });
  });
}

jQuery.fn.enableOpinion = function(opt){

  this.each(function(){

    $(this).find("input[type='submit'], .my_opinion button").click(function(e) {
      $(".my_opinion .selected").removeClass("selected");
      $(this).addClass("selected");
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

  var $plugin = $(this);
  var speed     = (opt && opt.speed) || 200;
  var duration  = (opt && opt.speed) || 3000;
  var maxHeight = 0;

  this.each(function(){
    if (($plugin.find("ul").height()) > maxHeight) {
      maxHeight = $plugin.find("ul").height();
    }
  });

  function updateHeight(maxHeight) {
    $plugin.find("ul").animate({ height:maxHeight}, speed);
  }

  this.each(function(){
    $(this).find("ul").animate({height:maxHeight});

    var that = this;
    var $el = $(this);

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

    $(this).find(".placeholder").smartPlaceholder();

    $(this).find(".new_argument").bind('ajax:error', function(evt, xhr, status) {
      spinner.stop();
      $icon = $("<span class='icon error' />");
      $(that).find(".footer .input_text").append($icon);

      showIcon("against");
    });

    $(this).find(".new_argument").bind('ajax:success', function(evt, xhr, status) {
      spinner.stop();

      if (!$(xhr).hasClass("empty")) {
        var $response = $(xhr);
        $response.hide();
        $el.find("ul").append($response);

        $response.fadeIn(speed);

        var c = 0;
        $el.find("ul li").each(function(i, el) { c+= $(el).outerHeight(true) });
        console.log($el.find("ul").outerHeight(true), $el.find("ul").height(), c);

        if (c > $el.find("ul").outerHeight(true)) {
          updateHeight(c);
        }

        $input.removeAttr("disabled");
        $submit.fadeIn(speed);
        $input.val('');
        $input.removeClass('disabled');

      } else {
        $icon = $("<span class='icon success' />");
        $(that).find(".footer .input_text").append($icon);
        showIcon("in_favor");
      }
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
jQuery.fn.autocompleteSearch = function(opt){

  var speed  = (opt && opt.speed) || 200;
  var interval;
  var id = "autocomplete";

  // Autocomplete spinner
  var opts = {lines: 12,length: 0,width: 3,radius: 6,color: '#333',speed: 1,trail: 100,shadow: false};
  var spin_element = document.getElementById('autocomplete_spinner');
  var spinner = new Spinner(opts);

  function _close(e) {
    GOD.broadcast('minimize.' + id);
    $('.autocomplete').fadeOut();
  }

  this.each(function(){
    $(window).bind('minimize.autocomplete', _close);

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
      GOD.subscribe('minimize.' + id);
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
      $('html, body').animate({scrollTop:$("div.comments").offset().top}, speed);
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

      url = $(this).attr("href");

      if (name != "months") {
        id = $(this).attr("id").replace(name + '_', '');
      }

      $article = $(this).parents(".article");

      spin_element = document.getElementById(name + '_spinner');
      IrekiaSpinner.spin(spin_element);

      if (name == "months") paginateMonths();
      else paginate();

    });
  })
}

jQuery.fn.enableTargetEditing = function(opt){

  this.each(function(){
    var
    $this          = $(this),
    interval,
    $add           = $this.find(".add_target");
    $addInput      = $this.find('.input_field input[type="text"]'),
    $addInputField = $this.find(".input_field"),
    serviceURL     = "/search/politicians_and_areas",
    speed          = (opt && opt.speed) || 100,
    spin_element   = document.getElementById('target_spinner'),
    spinner        = new Spinner(SPINNER_OPTIONS),
    fadeInSpeed    = (opt && opt.speed) || 10;

    function _setup() {

      $addInputField.click(function(e) {
        e.preventDefault();
        e.stopPropagation();
      });

      $addInput.click(function(e) {
        e.preventDefault();
        e.stopPropagation();
      });

      $this.find(".content").click(function(e) {
        e.preventDefault();
        e.stopPropagation();

        GOD.subscribe("_close.target_popover");
        GOD.broadcast("_close.target_popover");

        $(this).fadeOut(speed, function() {
          $this.find(".add_target").fadeIn(speed, function() {
            $this.find(".add_target").addClass("open");
            $this.find('.add_target input[type="text"]').focus();
          });
        });
      });

      $(window).bind('_close.target_popover', function() {
        _close();
      });

    }

    function _onSuccess(response) {
      _hidePopover();
      _appendPopover(response);
    }
    function _hidePopover() {

      spinner.stop();

      if ($(".autosuggest.small").length > 0 ) {
        $(".autosuggest.small").fadeOut(speed, function() { $(this).remove(); });
      }
    }

    function _close() {
      _hidePopover();

      $this.find(".add_target").fadeOut(speed, function() {
        $this.find(".content").fadeIn(fadeInSpeed);
        $this.find(".holder").fadeIn(fadeInSpeed);
        $this.find(".add_target").find("input").val("");
        $this.find(".add_target").removeClass("open");
      });
    }

    function _centerPopover($response) {
      var left =  $addInputField.position().left + 72;
      var top  =  $addInputField.position().top  + $addInputField.outerHeight(true) + 15;

      $response.css({left: left + "px", top: top + "px"});
    }

    function _resizePopover($popover) {
      var h_ = $popover.find("ul").height();

      if (h_< 160) {
        $popover.find(".popover").height(h_);
      } else {
        $popover.find('.scroll-pane').jScrollPane();
        $popover.find(".jspDrag").bind('click', function(e) {
          e.stopPropagation();
        });
      }
    }

    function _appendPopover(response) {

      var $response = $(response);

      if ($response.find("ul li").length > 0) {

        // Append and configure the popover
        $response.addClass("small");
        $response.hide();

        $this.after($response);
        _centerPopover($response);

        if (!$this.find(".add_target").hasClass("open")) return;

        // Show the popover
        $response.fadeIn(speed, function() {
          spinner.stop();
          _resizePopover($response);

          $response.find("li").click(function(e) {
            e.preventDefault();
            e.stopPropagation();

            _hidePopover();

            var name = $(this).attr("data-content");

            if ($(this).attr("data-type") == "area") {
              $this.find("#editable_target_area_id").val($(this).attr("data-id"));
              $this.find("#editable_target_user_id").val();
            } else if ($(this).attr("data-type") == "politician") {
              $this.find("#editable_target_area_id").val();
              $this.find("#editable_target_user_id").val($(this).attr("data-id"));
            }

            $this.find("span.target").html($this.attr("data-addressed-to") + " " + name);
            $this.submit();

            _close();
          });
        });
      } else {
        spinner.stop();
      }
    }

    function _observeInput($input) {

      function _do(e) {

        if (e.keyCode == 27) return;

        if ($input.val().length <= 0) {
          _hidePopover();
        } else {

          if (_.any([13, 16, 17, 18, 20, 27, 32, 37, 38, 39, 40, 91], function(i) { return e.keyCode == i } ) && (e.keyCode == 65 && (e.metaKey || e.ctrlKey))) { return; }
          if ($addInput.val().length > 3) _onKeyUp(e);
        }
      }

      $input.keyup(_do);
      $input.keydown(_do);
    }

    function _onKeyUp(e){

      clearTimeout(interval);

      interval = setTimeout(function(){
        if ($addInput.val().length > 0) spinner.spin(spin_element);

        var query = $addInput.val();
        var params = { name : query };

        if ($this.attr("data-search") == 'areas') {
          params = $.extend(params, { only_areas : true} );
        }

        $.ajax({ url: serviceURL, data: { search: params }, type: "GET", success: _onSuccess});
      }, 500);
    }

    _observeInput($addInput);
    _setup();
  });
} // jQuery.fn.enableTargetEditing







jQuery.fn.enableNotificationSelector = function(opt){

  var speed  = (opt && opt.speed) || 200;

  this.each(function(){

    $(this).find("li").click(function(e) {
      e.preventDefault();
      $(this).siblings("li.selected").removeClass("selected")
      $(this).addClass("selected")
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

    // Check textarea at the begining
    textCounter($input, $submit);

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

      //TODO: check for ie
      if (e.metaKey && e.keyCode == 88) { // command+x
        setTimeout(function() {
          isEmpty($input.val()) && $span.fadeIn(speed);
        }, 100);
      } else if (e.metaKey && e.keyCode == 86) { // command+v
        setTimeout(function() {
          !isEmpty($input.val()) && $span.fadeOut(speed);
        }, 100);
      } else {
        setTimeout(function() { ($input.val()) ?  $span.fadeOut(speed) : $span.fadeIn(speed); }, 0);
      }
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

  var limit  = (opt && opt.limit) || $(this).attr("data-limit") || 140;

  if (limit == -1) limit = 999999;

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

  $(ele).find('div.left').hover(function(){
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
      $(this).find('input[type="submit"]').addClass("disabled");
      $(this).find('input[type="submit"]').attr("disabled", "disabled");
    });

    $(this).bind('ajax:success', function(evt, xhr, status) {
      spinner.stop();
      $(this).find(".notice_success").fadeIn(220);

      $icon = $("<span class='icon success' />");
      $(this).find(".input-counter").append($icon);

      $("#notice_success").css("left", "447px");
      $("#notice_success").css("bottom", "80px");
      $(this).find('input[type="text"]').val("");
      $(this).find(".holder").fadeIn(150);
      $(this).find(".counter").html(140);

      var $that = $(this);

      setTimeout(function() {
        $("#notice_success").fadeOut(150);

        $that.find('input[type="submit"]').removeClass("disabled");
        $that.find('input[type="submit"]').removeAttr("disabled");

        $that.find(".icon").fadeOut(150, function() { $(this).remove();});
      }, 2000);

    });
  });
};

/* Enables image editing */
jQuery.fn.enableAvatarUpload = function(opt){
  var
  $this       = $(this),
  speed       = (opt && opt.speed) || 120,
  fadeInSpeed = (opt && opt.speed) || 80,
  t,
  content;

  this.each(function(){

    var uploader = new qq.FileUploader({
      element: document.getElementById("avatar_uploader"),
      action: $("#avatar_uploader").attr("data-url"),
      params: {
        utf8: $("#avatar_uploader").closest("form").find('input[name=utf8]').val(),
        authenticity_token: $("#avatar_uploader").closest("form").find('input[name=authenticity_token]').val()
      },
      debug: true,
      template: '<span class="qq-uploader">' +
        '<span class="qq-upload-drop-area"></span>' +
          '<span class="qq-upload-button"><span class="title">'+$("#avatar_uploader span").html()+'</span></span>' +
            '<span class="qq-upload-list"></span>' +
              '</span>',
      text: $("#avatar_uploader span").html(),
      onSubmit: function(id, fileName){
        console.log("Submit");
        var w = $("#avatar_uploader .qq-upload-button").outerWidth(true);
        t = $("#avatar_uploader span.title").html();
        $("#avatar_uploader .qq-upload-button").css("width", w);
        $("#avatar_uploader span.title").html("");
      },
      onProgress: function(id, fileName, loaded, total){
        console.log("Progress");
      },
      onComplete: function(id, fileName, responseJSON){
        console.debug(fileName, responseJSON, responseJSON.image_cache_name);

        $("#avatar_uploader span.title").html(t);
        var cacheImage = document.createElement('img');
        cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;

        $('.image_cache_name').val(responseJSON.image_cache_name);

        console.log($(".image_cache_name"));

        $(cacheImage).bind("load", function () {
          console.log(cacheImage, responseJSON);
          $(".avatar_uploader_form").submit();
          var src = $(cacheImage).attr("src");
          $(".avatar_box a img").attr("src", src);
        });


      },
      onCancel: function(id, fileName){
        console.log("Cancel");
      }
    });
  })
}
