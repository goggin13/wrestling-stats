// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function () {
  console.log("Ready");
  check_for_updates();
});

function check_for_updates () {
  var last_updated_at = 0;

  var poll = function () {
    console.log("Polling");
    $.get("/olympics/fetch_latest_updated_at", function (data) {
      console.log("mine: ", last_updated_at, "server: ", data.last_updated_at);
      if (data.last_updated_at > last_updated_at) {
        if (last_updated_at > 0) {
          update_scoreboard();
        }
        last_updated_at = data.last_updated_at;
      }
    });
  };

  setInterval(poll, 1000);
};

function update_scoreboard() {
  console.log("update scoreboard!");
  $.get("/olympics/fetch_now_playing.js");
  $.get("/olympics/fetch_on_deck.js");
  $.get("/olympics/fetch_rankings.js");
};

function manage_bp_form () {
  // for .match_form.beer_pong submit buttons
  // on click
    // popup dialog : how many cups remaining?
    // if ! valid response
      // return false
    // else
      // set bp_cups_remaining to response
      // return true
};
