jQuery.fn.enableUserPublish = function(opt){

  if (this.length < 1) return;

  var
  section       = 0,
  speed         = 250,
  sectionWidth  = 687,
  $article      = $(this),
  currentHeight = 0,
  $currentSection,
  $submit = $article.find("footer .publish"),
  spin_element = document.getElementById('publish_spinner'),
  submitting = false;

  // Initialize the initial section
  $currentSection = $article.find(".container .section:nth-child(1)");

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

  function _showMessage(kind) {
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
      _enableSubmit();
    });
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

  // Init
  _bindActions();

  this.each(function(){
    $submit.click(function(e) {
      e && e.preventDefault();
      _disableSubmit();
      _showMessage("success");

      $article.find(":text, textarea").keyup(function(e) {
        console.log('a');
        textCounter($(this), $submit);
      });

      $article.find(":text, textarea").keydown(function(e) {
        textCounter($(this), $submit);
      });

    });

    $(this).find("ul.menu li a").click(function(e) {
      if (submitting) return;

      e && e.preventDefault();

      $(this).parents("ul").find("li").removeClass("selected");
      $(this).parent().addClass("selected");

      section  = $(this).parent().index();
      $section = $(this).parents(".content").find(".container .section:nth-child(" + (section + 1) + ")");

      if ($currentSection) {

        currentHeight = $currentSection.find(".form").outerHeight(true) + 20;

        $article.find(".container").animate({scrollTop: 0, height:currentHeight}, function() {

          var $success = $currentSection.find(".message.success").hide();
          var $error   = $currentSection.find(".message.error").hide();

          $currentSection = $section;
          var height = $section.find(".form").outerHeight(true) + 20;
          $article.find(".container").animate({scrollLeft:section * sectionWidth, height:height}, speed, "easeInOutQuad");
        });

      } else {
        $currentSection = $section;
        var height = $section.find(".form").outerHeight(true) + 20;
        $article.find(".container").animate({scrollTop: 0, scrollLeft:section * sectionWidth, height:height}, speed, "easeInOutQuad");
      }

    });
  })
}

