<% # Hello.js # %>
var helloSocialConfig = {
  <% # Not using twitter right now - does not provide email. If you start looking in to it, will need to set up OAuth 1 proxy %>
  "facebook": "<%= ENV['FACEBOOK_APP_ID'] %>",
  "google": "<%= ENV['GOOGLE_APP_ID'] %>"
};
var helloOptions = {
  "redirect_uri": "/"
};

hello.init(helloSocialConfig, helloOptions);
