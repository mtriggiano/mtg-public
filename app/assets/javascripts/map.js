$(document).on("ready pjax:complate ajaxComplete", function(){
  var mapa = $("#map")
  if (mapa.length){
    initMap()
  }
})

var map;
var markers = [];

function initMap() {
  var haightAshbury = {lat: -24.782674, lng: -65.407897};

  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 16,
    center: haightAshbury,
    mapTypeId: 'terrain'
  });

  // This event listener will call addMarker() when the map is clicked.
  map.addListener('click', function(event) {
    addMarker(event.latLng);
    showInfo(event.latLng);
  });


  // Adds a marker at the center of the map.
  addMarker(haightAshbury);
}

// Adds a marker to the map and push to the array.
function addMarker(location) {
  clearMarkers()
  var marker = new google.maps.Marker({
    position: location,
    map: map,
    draggable: true
  });
  markers.push(marker);
  var pos = markers[markers.length-1].position;
  $("[id$=location_attributes_map]").val(pos);
}

// Sets the map on all markers in the array.
function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

// Removes the markers from the map, but keeps them in the array.
function clearMarkers() {
  setMapOnAll(null);
}

// Shows any markers currently in the array.
function showMarkers() {
  setMapOnAll(map);
}

// Deletes all markers in the array by removing references to them.
function deleteMarkers() {
  clearMarkers();
  markers = [];
}



function showInfo(latlng) {
  geocoder = new google.maps.Geocoder();
  geocoder.geocode({
    'latLng': latlng
  }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
        // here assign the data to asp lables
        $("[id$=location_attributes_address]").val(results[1].formatted_address);
      } else {
        alert('No results found');
      }
    } else {
      alert('Geocoder failed due to: ' + status);
    }
  });
}
