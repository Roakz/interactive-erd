$(".custom-file-input").on("change", function() {
    var fileName = $(this).val().split("\\").pop();
    $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
  });

  const upload = (file) => {
    let formData = new FormData()
    formData.append('file', file)

    fetch('http://localhost:4567/file-to-json', { // Your POST endpoint
      method: 'POST',
      body: formData // This is your file object
    }).then(
      response => response.json() // if the response is a JSON object
    ).then(
      success => console.log(success) // Handle the success response object
    ).catch(
      error => console.log(error) // Handle the error response object
    );
  };
  

  $("#upload-button").on("click", function() {
    let file = $(".custom-file-input").prop('files')
    console.log(file[0])
    upload(file[0])
  })