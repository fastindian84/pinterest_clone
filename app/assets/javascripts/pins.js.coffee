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

  initialize()





initialize = ->

  map = setupMap()

  input = document.getElementById('address')
  # Sets a listener on a radio button to change the filter type on Places
  # Autocomplete.

  autocomplete = new (google.maps.places.Autocomplete)(input)
  autocomplete.bindTo 'bounds', map
  infowindow = new (google.maps.InfoWindow)
  marker = new (google.maps.Marker)(
    map: map
    anchorPoint: new (google.maps.Point)(0, -29))
  google.maps.event.addListener autocomplete, 'place_changed', ->
    infowindow.close()
    marker.setVisible false
    place = autocomplete.getPlace()
    if !place.geometry
      window.alert 'Autocomplete\'s returned place contains no geometry'
      return
    assign_coordinates(place)
    # If the place has a geometry, then present it on a map.
    if place.geometry.viewport
      map.fitBounds place.geometry.viewport
    else
      map.setCenter place.geometry.location
      map.setZoom 17
    # Why 17? Because it looks good.
    marker.setIcon
      url: place.icon
      size: new (google.maps.Size)(71, 71)
      origin: new (google.maps.Point)(0, 0)
      anchor: new (google.maps.Point)(17, 34)
      scaledSize: new (google.maps.Size)(35, 35)
    marker.setPosition place.geometry.location
    marker.setVisible true
    address = ''
    if place.address_components
      address = [
        place.address_components[0] and place.address_components[0].short_name or ''
        place.address_components[1] and place.address_components[1].short_name or ''
        place.address_components[2] and place.address_components[2].short_name or ''
      ].join(' ')

    infowindow.setContent '<div><strong>' + place.name + '</strong><br>' + address
    infowindow.open map, marker
    return

setupMap = ->
  mapPlaceholder = document.getElementById('map-canvas')
  location = getStartPosition()
  mapOptions =
    center: new (google.maps.LatLng)(location.lat, location.long)
    zoom: 13
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)




getStartPosition = ->
  mapPlaceholder = document.getElementById('map-canvas')
  location = {
    lat: -33.8688,
    long: 151.2195
  }
  if mapPlaceholder.dataset.longtitude && mapPlaceholder.dataset.latitude
    location.long = parseFloat(mapPlaceholder.dataset.longtitude)
    location.lat = parseFloat(mapPlaceholder.dataset.latitude)
  location



assign_coordinates = (place)->
  $("#pin_longitude").val(place.geometry.location.lng())
  $("#pin_latitude").val(place.geometry.location.lat())




