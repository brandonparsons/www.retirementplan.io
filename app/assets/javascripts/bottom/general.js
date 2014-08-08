$(document).ready(function() {

  $('.carousel').carousel({
    interval: 5000,
    pause: "none"
  });

  // Disable href="#" links that are specifically called out
  $(".javascript-disabled-link").on('click', function(e) {
    e.preventDefault();
    return false;
  });

});
