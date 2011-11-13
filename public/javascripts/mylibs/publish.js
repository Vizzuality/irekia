jQuery.fn.enableUserPublish = function(opt){

  if (this.length < 1) return;

  var
  sectionID     = 0,
  speed         = 150,
  sectionWidth  = 687,
  $article      = $(this),
  currentHeight = 0,
  $currentSection,
  $currentMenuOption,
  $menu,
  questionStep = 0,
  proposalStep = 0,
  $submit = $article.find("footer .publish"),
  spin_element = document.getElementById('publish_spinner'),
  submitting = false;

  // Initialize the initial section
  $currentSection    = $article.find(".container .section:nth-child(1)");
  $menu              = $article.find(".menu");
  $currentMenuOption = $menu.find("li.selected");

  function textCounter($input, $submit) {
    var count = $input.val().length;
    (count <= 0) ? _disableSubmit($submit) : _enableSubmit($submit);
  }

  function _setupUpload(id) {

    if ($article.find("#" + id).length > 0) {

      var uploader = new qq.FileUploader({
        element: document.getElementById(id),
        action: '',
        debug: true,
        text:"sube una nueva",
        onSubmit: function(id, fileName){
          $currentSection.find(".holder").fadeOut(speed);
        },
        onProgress: function(id, fileName, loaded, total){},
        onComplete: function(id, fileName, responseJSON){},
        onCancel: function(id, fileName){ }
      });
    }
  }

  function _enableInputCounter() {
    $article.find(":text, textarea").keyup(function(e) {
      textCounter($(this), $submit);
    });

    $article.find(":text, textarea").keydown(function(e) {
      textCounter($(this), $submit);
    });
  }

  function _bindActions() {

    _setupUpload("upload_proposal");
    _setupUpload("upload_image");

    $article.find(".section .open_upload").click(function(e) {
      e && e.preventDefault();
      $(this).closest("input[type='file']").click();
    });

    $article.find(".section.video li").click(function(e) {
      e && e.preventDefault();

      $(this).siblings("li").removeClass("selected");
      $(this).addClass("selected");
      $article.find(".radio.selected").removeClass("selected");
      $(this).find(".radio").addClass("selected");
    });

    $article.find("a.radio").click(function(e) {
      e && e.preventDefault();
      $article.find(".section.video li").toggleClass("selected");
    });
  }

  function _showMessage(kind, callback) {
    IrekiaSpinner.spin(spin_element);

    var currentHeight = $currentSection.find(".form").outerHeight(true);
    var $success      = $currentSection.find(".message.success");
    var $error        = $currentSection.find(".message.error");

    if (kind == "success") {
      $error.hide();
      $success.show();
    } else {
      $error.show();
      $success.hide();
    }

    var successHeight = $success.outerHeight(true);

    $article.find(".container").animate({scrollTop: currentHeight + 20, height:successHeight + 20 }, speed * 2, "easeInOutQuad", function() {
      IrekiaSpinner.stop();
      callback && callback();
    });
  }

  function _resetSection($section) {
    $section.find(":text, textarea").val("");
    $section.find(".holder").fadeIn(speed);
  }

  function _hasContent($section) {
    return !isEmpty($section.find(":text, textarea").val());
  }

  function _enableSubmit() {
    submitting = false;
    $submit.removeAttr('disabled');
    $submit.removeClass("disabled");
  }

  function _disableSubmit() {
    submitting = true;
    $submit.attr("disable", "disable");
    $submit.addClass("disabled");
  }

  function _selectOption($option) {
    $menu.find("li.selected").removeClass("selected");
    $option.parent().addClass("selected");
  }

  function _resizeSection($section, callback) {
    height = $section.find(".form").outerHeight(true) + 20;
    $article.find(".container").animate({ scrollTop: 0, height: height }, speed, function() {
      callback && callback();
    });
  }

  function _hideExtraFields() {
    $currentSection.find(".extra").fadeOut(speed);
  }
  function _showExtraFields() {
    $currentSection.find(".extra").fadeIn(speed);
  }

  function _doProposal() {
  }

  function _doQuestion() {
    if (questionStep == 0) {
      _showExtraFields();
      _resizeSection($currentSection);
      _disableSubmit();
      questionStep++;
      _changeSubmitTitle("Publicar");
    } else {
      _showMessage("success", function() {
        questionStep = 0;
        _resetSection($currentSection);
      });
    }
  }

  function _proposal() {
    return $currentSection.hasClass("proposal");
  }

  function _question() {
    return $currentSection.hasClass("question");
  }

  function _changeSubmitTitle(title) {
    $submit.text(title);
  }

  function _sectionName($section) {
    return $section.attr("class").replace(/section/g, "").fulltrim();
  }

  // Init
  _bindActions();
  _enableInputCounter();

  this.each(function(){

    _disableSubmit();

    $submit.click(function(e) {
      e && e.preventDefault();

      if (!_hasContent($currentSection)) return;

      _disableSubmit();

      if (_question()) _doQuestion();
      else if (_proposal()) _doProposal();
    });

    $(this).find("ul.menu li a").click(function(e) {

      //if (submitting) return;

      e && e.preventDefault();
      _hideExtraFields();


      sectionID = $(this).parent().index();
      $section  = $(this).parents(".content").find(".container .section:nth-child(" + (sectionID + 1) + ")");


          if (_sectionName($section) != _sectionName($currentSection)) {
            _resetSection($section);
          }


      _selectOption($(this));

      if ($currentSection) {

        _resizeSection($currentSection, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;
          var height = $section.find(".form").outerHeight(true) + 20;
          $article.find(".container").animate({scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
          _changeSubmitTitle("Continuar");


        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $article.find(".container").animate({scrollTop: 0, scrollLeft: sectionID * sectionWidth, height: height }, speed, "easeInOutQuad");
      }

    });
  })
}

