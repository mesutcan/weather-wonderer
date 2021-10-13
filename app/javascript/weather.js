function getLocation() {
    const x = document.getElementById('error-message');

    if (navigator.geolocation) {
        navigator.geolocation.watchPosition(success, error);
    } else {
        x.style.display='block';
        x.innerHTML = "Geo-location is not supported by this browser.";
    }
}

function success(position) {
    let cookie_val = position.coords.latitude + "|" + position.coords.longitude;
    window.location = '/?lat_long=' + encodeURI(cookie_val);
}

function error(error) {
    const x = document.getElementById('error-message');
    x.style.display='block';
    switch(error.code) {
        case error.PERMISSION_DENIED:
            x.innerHTML = "User denied the request for Geolocation.";
            break;
        case error.POSITION_UNAVAILABLE:
            x.innerHTML = "Location information is unavailable.";
            break;
        case error.TIMEOUT:
            x.innerHTML = "The request to get user location timed out.";
            break;
        case error.UNKNOWN_ERROR:
            x.innerHTML = "An unknown error occurred.";
            break;
    }
}