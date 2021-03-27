function geoFindMe() {
  const spinner = document.getElementsByClassName('loading_zone')[0];
  spinner.classList.add('loading')
  function success(position) {
    const latitude  = position.coords.latitude;
    const longitude = position.coords.longitude;
    document.getElementById('location').value = `${latitude},${longitude}`;
    spinner.classList.remove('loading'); 
  }

  function error() {
    alert('エラーが発生しました。')
    spinner.classList.remove('loading'); 
  }

  if(!navigator.geolocation) {
     alert('Geolocation is not supported by your browser');
  } else {
    navigator.geolocation.getCurrentPosition(success, error);
  }
}

document.querySelector('#get_current_spot').addEventListener('click', geoFindMe);

