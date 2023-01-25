// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function () {
  console.log("Ready");
  check_for_updates();
  manage_bp_form();
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
  $(".match_form.beer_pong .update_match_form").submit(function (event) {
    let bp_cups = prompt("How many cups were left?");
    if (isNaN(bp_cups) || bp_cups < 1 || bp_cups > 10) {
      event.preventDefault();
      alert("Please enter a number between 1 and 10");
    } else {
      $(this).find("input[name='olympics_match[bp_cups_remaining]']").val(bp_cups);
    }
  });
  // for .match_form.beer_pong submit buttons
  // on click
    // popup dialog : how many cups remaining?
    // if ! valid response
      // return false
    // else
      // set bp_cups_remaining to response
      // return true
};
