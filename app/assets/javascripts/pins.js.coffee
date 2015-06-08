# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  $('#pins').imagesLoaded ->
    $('#pins').masonry
      itemSelector: '.box'
      isFitWidth: true

  file_upload = $('#images_upload')
  file_upload.fileupload
    url: '/pins'
    autoUpload: false
    dataType: 'json'
    type: 'POST'
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    sequentialUploads: true
    limitMultiFileUploads: 6
    previewMaxWidth: 100
    previewMaxHeight: 100
    add: (e, data) ->

      data.context = $('<div/>').appendTo('#images');
      file = data.files[0]

      reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onload = (e)->
        img = document.createElement("img")
        img.src = e.target.result
        img.style.height = "40px"
        img.style.width  = "60px"
        img.style.margin = "5px"
        img.style.borderRadius = "2px"
        span = $('<span/>')
        span.text(file.name)
        data.context.append(span)
        data.context.prepend(img)



