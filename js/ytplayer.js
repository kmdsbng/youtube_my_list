
var params = { allowScriptAccess: "always" };
var atts = { id: "myytplayer" };
var video_url_input = document.getElementById('video_url');
var video_url = video_url_input.value;
var next_url_a = document.getElementById('next_url');
var next_url = next_url_a.href;
var prev_url_a = document.getElementById('prev_url');
var prev_url = prev_url_a.href;
var duration_input = document.getElementById('duration');
var duration = duration_input.value;
swfobject.embedSWF(video_url, 
                   "ytapiplayer", "560", "365", "8", null, null, params, atts);

var ytplayer;
var playerFinishHandled = false;
function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("myytplayer");
  ytplayer.addEventListener("onStateChange", "onytplayerStateChange");
  playerFinishHandled = true;
}

// http://code.google.com/intl/en/apis/youtube/js_api_reference.html#Events
// This event is fired whenever the player's state changes. Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). When the SWF is first loaded it will broadcast an unstarted (-1) event. When the video is cued and ready to play it will broadcast a video cued event (5).
function onytplayerStateChange(newState) {
  if (newState == 0)
    jumpToNextVideo();
}

function jumpToNextVideo() {
  location.href = next_url;
}

if (duration > 0) {
  setTimeout(function() {
    if (!playerFinishHandled)
      jumpToNextVideo();
  }, duration * 1000 + 10000);
}


