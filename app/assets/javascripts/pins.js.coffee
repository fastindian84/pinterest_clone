# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  $('#pins').imagesLoaded ->
    $('#pins').masonry
      itemSelector: '.box'
      isFitWidth: true

  file_upload = $('#images_upload')
  forms = []
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
      forms.push(data)

      context = $('<div/>').appendTo('#images');
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
        removeBtn = document.createElement("i")
        removeBtn.file = data
        removeBtn.className = "glyphicon glyphicon-remove"
        removeBtn.style.margin = "10px"
        removeBtn.onclick = ->
          index = forms.indexOf(@file)
          forms.splice(index, 1)
          @parentElement.outerHTML = ""
        span = $('<span/>')
        span.text(file.name)
        context.append(span)
        context.prepend(img)
        context.append(removeBtn)


  $("#submit_pin").click ->
    promises = forms.map (form)-> form.submit()
    $.when.apply($, promises).then ->
      window.location.href = "/"
    false


