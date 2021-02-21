function geoFindMe() {
  function success(position) {
    const latitude  = position.coords.latitude;
    const longitude = position.coords.longitude;
    document.getElementById('location').value = `${latitude},${longitude}`;
  }

  function error() {
    alert('エラーが発生しました。')
  }

  if(!navigator.geolocation) {
     alert('Geolocation is not supported by your browser');
  } else {
    navigator.geolocation.getCurrentPosition(success, error);
  }
}

document.querySelector('#get_current_spot').addEventListener('click', geoFindMe);