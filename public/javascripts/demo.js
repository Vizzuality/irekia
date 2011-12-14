$(function() {
  var $this = $("#uploader");

  var uploader = new qq.FileUploader({
    element: document.getElementById("file_uploader"),
    action: $("#file_uploader").attr("data-url"),
    params: {
      utf8: $this.find('input[name=utf8]').val(),
      authenticity_token: $this.find('input[name=authenticity_token]').val()
    },
    debug: true,
    text: 'Upload file',
    onSubmit: function(id, fileName){
      console.log("Submit");
    },
    onProgress: function(id, fileName, loaded, total){
      console.log("Progress");
    },
    onComplete: function(id, fileName, responseJSON){
      console.log("Complete");
    },
    onCancel: function(id, fileName){
      console.log("Cancel");
    }
  });

});
