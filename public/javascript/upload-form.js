$(".custom-file-input").on("change", function() {
    var fileName = $(this).val().split("\\").pop();
    $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
  });

  const upload = (file) => {
    let formData = new FormData()
    formData.append('file', file)
    let status

    fetch('http://localhost:4567/file-to-json', { 
      method: 'POST',
      body: formData 
    }).then(
      response => {
          response.json() 
          status = response.status
      }
    ).then(
      success => {
         if(status == 200) {
            let flash = document.createElement("div")
            flash.className = "alert alert-success text-center"
            flash.innerHTML = "success! enjoy your interactive ERD!"
            document.body.append(flash)
         }
      }
    ).catch(
      error => console.log(error)
    );
  };
  
  $("#upload-button").on("click", function() {
    let file = $(".custom-file-input").prop('files')
    upload(file[0])
  })