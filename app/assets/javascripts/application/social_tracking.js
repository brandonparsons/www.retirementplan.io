$(document).ready(function() {

  // Footer social links
  $("#facebook-profile-link").on('click', function() {
    ga('send', 'social', 'facebook', 'engagement', 'facebook-profile-visit');
  });

  $("#twitter-profile-link").on('click', function() {
    ga('send', 'social', 'twitter', 'engagement', 'twitter-profile-visit');
  });

  $("#linkedin-profile-link").on('click', function() {
    ga('send', 'social', 'linkedin', 'engagement', 'linkedin-profile-visit');
  });

  $("#googleplus-profile-link").on('click', function() {
    ga('send', 'social', 'googleplus', 'engagement', 'gplus-profile-visit');
  });

  $(".email-link").on('click', function() {
    ga('send', 'social', 'email', 'engagement', 'email-link-click');
  });

  $("#rss-link").on('click', function() {
    ga('send', 'social', 'rss', 'engagement', 'rss-visit');
  });

});
