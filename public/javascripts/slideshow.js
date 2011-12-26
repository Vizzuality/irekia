jQuery.fn.enableSlideshow = function(opt){

  var
  speed        = (opt && opt.speed) || 100,
  controlSpeed = (opt && opt.speed) || 250,
  $this        = $(this),
  width        = 610,
  pos          = 0,
  section      = 0,
  sectionNum,
  disabledControls = false,
  sectionType      = 'video';

  sectionNum = $this.find(".section").length;

  function _updateHeight(s, callback) {
    var height = $this.find(".section." + sectionType + ":eq(" + s + ")").height();

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

  // Enables/disables controls
  function _toggleControls(s) {
    if ($this.find(".section."+sectionType).length == 1) {
      _hideControl("prev");
      _hideControl("next");
    } else if (s + 1 >= sectionNum) {
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

  // Enables/disables a type of section
  function _toggleSections(sectionType) {
    var otherSectionType = (sectionType == 'video') ? 'photo' : 'video';

    $this.find(".section." + otherSectionType).hide();
    $this.find(".section." + sectionType).show();

    sectionNum = $this.find(".section." + sectionType).length;
  }

  function _bindSectionLinks() {
    $this.find(".selector li a").click(function(e) {
      e.preventDefault();
      if ($(this).parent().hasClass('video')) {
        sectionType = 'video';
        _toggleSections("video");
        !$(this).parent().hasClass("selected") && _gotoFirst();
      } else {
        sectionType = 'photo';
        _toggleSections("photo");
        !$(this).parent().hasClass("selected") && _gotoFirst();
      }

      $this.find(".selector li").removeClass('selected');
      $(this).parent().addClass('selected');
    });
  }

  // Initialization
  function _setup() {

    _positionControls();

    var photoCount = $this.find(".section.photo").length;
    var videoCount = $this.find(".section.video").length;

    if (photoCount == 0) {
      $this.find(".selector li.photo").hide();
    } else if (videoCount == 0) {
      sectionType = "photo";
      $this.find(".selector li.video").hide();
      $this.find(".selector li.photo").addClass("selected");
    } else if (videoCount == 1) {
      _hideControl("prev");
      _hideControl("next");
    }

    _updateSelector(0);
    _toggleSections(sectionType);
    _bindSectionLinks();
  }

  // Updates video/photo selector with the number of elements
  function _updateSelector(s) {

    var otherSectionType = (sectionType == 'video') ? 'photo' : 'video';

    var selectedSectionCount = $this.find(".section." + sectionType).length;
    var otherSectionCount    = $this.find(".section." + otherSectionType).length;

    selectedSectionCount && $this.find(".selector li." + sectionType + " sup").html("(" + (s + 1) + "/" + selectedSectionCount + ")");
    otherSectionCount && $this.find(".selector li." + otherSectionType + " sup").html("(" + otherSectionCount + ")");
  }

  // Go to first element
  function _gotoFirst() {
    section = 0;
    _move(0);
  }

  // Moves to section #s
  function _move(s) {

    _updateHeight(s, function() {
      $this.find(".section:eq(" + s + ") .caption").fadeOut(speed, function() {
        $this.find(".inner_slideshow").animate({scrollLeft: s * width}, speed, function() {
          _toggleVideoControls();
          _toggleControls(s);

          _updateSelector(s);

          $this.find(".section:eq(" + s + ") .caption").fadeIn(speed, function() {
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

  _setup();
}
