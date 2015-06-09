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
    autoUpload: false
    dataType: 'json'
    type: @method
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    sequentialUploads: true
    limitMultiFileUploads: 6
    previewMaxWidth: 100
    previewMaxHeight: 100
    add: (e, data) ->
      isNew = $(this).parents("form")[0].id is "new_pin"

      if !isNew && forms.length >= 1
        return false

      forms.push(data)

      $(".fileinput-button").attr("disabled", true) if !isNew

      context = $('<div/>').appendTo('#images');
      file = data.files[0]
      forms.push(data)

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
          $(".fileinput-button").attr("disabled", false)
          i = forms.indexOf(@file)
          forms = _.reject forms, (file) ->
            return file is removeBtn.file
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

  $("#edit_pin").click ->
    if forms.length
      forms[0].submit().then (response)->
        window.location.href = "/pins/#{response.id}"
    else
      @form.submit()


    false


