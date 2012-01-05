$(function() {

  $(".load-popover").click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    $("#uploader-popover").show();
    $("#uploader-popover").animate({left: 30, top:100, opacity:1}, 250);
    setupUpload();
  });

  function setupUpload() {
    var $this = $("#uploader");
    var uploader = new qq.FileUploader({
      element: document.getElementById("file_uploader"),
      action: $("#file_uploader").attr("data-url"),
      text: 'Upload file',
      fileTemplate: '<li>' +
                  '<span class="qq-upload-file"></span>' +
                  '<span class="qq-upload-spinner"></span>' +
                  '<span class="qq-upload-size"></span>' +
                  '<a class="qq-upload-cancel" href="#">Cancel</a>' +
                  '<span class="qq-upload-failed-text">Failed</span>' +
               '</li>',
      template: '<div class="qq-uploader">' +
              '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
              '<div class="qq-upload-button">Test</div>' +
              '<ul class="qq-upload-list"></ul>' +
          '</div>',
      params: {
        utf8: $this.find('input[name=utf8]').val(),
        authenticity_token: $this.find('input[name=authenticity_token]').val()
      },
      debug: false,
      onSubmit: function(id, fileName){
        //console.log("Submit");
      },
      onProgress: function(id, fileName, loaded, total){
        console.log("Progress");
      },
      onComplete: function(id, fileName, responseJSON){

        var cacheImage = document.createElement('img');
        cacheImage.src = "/uploads/tmp/" + responseJSON.image_cache_name;

        $('.image_cache_name').val(responseJSON.image_cache_name);

        $(cacheImage).bind("load", function () {
          var src = $(cacheImage).attr("src");
          $(".avatar_box").html(cacheImage);
        });
      },
      onCancel: function(id, fileName){
        console.log("Cancel");
      }
    });
  }

});
