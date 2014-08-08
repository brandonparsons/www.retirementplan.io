function extractParamFromUri(uri, paramName) {
  if (!uri) return;
  var regex = new RegExp('[\\?&#]' + paramName + '=([^&#]*)');
  var params = regex.exec(uri);
  if (params != null) {
    return unescape(params[1]);
  }
  return;
}

function determineCurrentPagePath() {
  var canonical = $("link[rel='canonical']").attr('href');
  if (canonical != null && typeof(canonical) != 'undefined') {
    link = document.createElement("a");
    link.href = canonical;
    return link.pathname;
  } else {
    return document.location.pathname;
  }
}

function determineTweetTarget(intentEvent) {
  var targetUrl;
  if (intentEvent.target && intentEvent.target.nodeName == 'IFRAME') {
    targetUrl = extractParamFromUri(intentEvent.target.src, 'url');
  } else {
    targetUrl = determineCurrentPagePath();
  }
  return targetUrl;
}

function trackTwitterTweet(intentEvent) {
  if (!intentEvent) return;
  var targetUrl = determineTweetTarget(intentEvent);
  ga('send', 'social', 'twitter', 'tweet', targetUrl);
}

function trackTwitterFollow(intentEvent) {
  if (!intentEvent) return;
  var user = intentEvent.data.user_id + " (" + intentEvent.data.screen_name + ")";
  ga('send', 'social', 'twitter', 'follow', user, {page: determineCurrentPagePath()} );
}

function trackTwitterRetweet (intentEvent) {
  if (!intentEvent) return;
  var tweetId = intentEvent.data.source_tweet_id;
  ga('send', 'social', 'twitter', 'retweet', tweetId, {page: determineCurrentPagePath()} );
}

function trackTwitterFavorite(intentEvent) {
  if (!intentEvent) return;
  var targetUrl = determineTweetTarget(intentEvent);
  ga('send', 'social', 'twitter', 'favorite', targetUrl);
}

// Wait for the asynchronous resources to load
// window.twttr defined in 02_social_plugins.js
window.twttr.ready(function (twttr) {
  // Now bind our custom intent events
  twttr.events.bind('tweet', trackTwitterTweet);
  twttr.events.bind('follow', trackTwitterFollow);
  twttr.events.bind('retweet', trackTwitterRetweet);
  twttr.events.bind('favorite', trackTwitterFavorite);
});


$(document).ready(function() {

  // Footer social links
  $("#facebook-profile-link").click(function() {
    ga('send', 'social', 'facebook', 'engagement', 'facebook-profile-visit');
  });

  $("#twitter-profile-link").click(function() {
    ga('send', 'social', 'twitter', 'engagement', 'twitter-profile-visit');
  });

  $("#linkedin-profile-link").click(function() {
    ga('send', 'social', 'linkedin', 'engagement', 'linkedin-profile-visit');
  });

  $("#googleplus-profile-link").click(function() {
    ga('send', 'social', 'googleplus', 'engagement', 'gplus-profile-visit');
  });

  $("#email-link").click(function() {
    ga('send', 'social', 'email', 'engagement', 'email-link-click');
  });

  $("#rss-link").click(function() {
    ga('send', 'social', 'rss', 'engagement', 'rss-visit');
  });

});
