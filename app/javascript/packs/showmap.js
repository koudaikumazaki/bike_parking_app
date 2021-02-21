// function initMap() {
//   let test ={lat: gon.latitude, lng: gon.longitude};
//   let map = new google.maps.Map(document.getElementById('map'), {
//               zoom: 15, 
//               center: test
//             });
//   let transitLayer = new google.maps.TransitLayer();
//   transitLayer.setMap(map);

//   let contentString = '住所：<%= @parking.address %>';
//   let infowindow = new google.maps.InfoWindow({
//     content: contentString
//   });

//   let marker = new google.maps.Marker({
//                   position:test,
//                   map: map,
//                   title: contentString
//                 });

//   marker.addListener('click', function() {
//     infowindow.open(map, marker);
//   });
// };