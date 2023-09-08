// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function () {
  if ($("#rankings").length > 0) {
    check_for_updates();
  }
  manage_bp_form();
  advocate_show_hide();
  if ($("#etoh").length > 0) {
    initialize_etoh();
  }
});

function advocate_show_hide() {
  $(".date.clickable:not(.header)").click(function() {
    $(".date").removeClass("selected");
    $(".schedule_days").hide();

    $(this).addClass("selected");
    var target = "#schedule_" + $(this).attr("id");
    $(target).show();
  });
};

function check_for_updates () {
  var last_updated_at = 0;
  var completed_games = -1;

  var poll = function () {
    $.get("/olympics/fetch_latest_updated_at", function (data) {
      if (data.last_updated_at > last_updated_at) {
        if (last_updated_at > 0) {
          update_now_playing();
        }
        last_updated_at = data.last_updated_at;
      }

      if (data.completed_games != completed_games) {
        if (completed_games > -1) {
          update_scoreboard();
        }
        completed_games = data.completed_games;
      }
    });
  };

  setInterval(poll, 5000);
};

function update_now_playing() {
  console.log("update now playing!");
  $("#now_playing").fadeOut();
  $("#on_deck").fadeOut();
  // now playing will also update on deck
  $.get("/olympics/fetch_now_playing.js");
}

function update_scoreboard() {
  console.log("update scoreboard!");
  $.get("/olympics/fetch_rankings.js");

  // scoreboard will fade in tiebreaker when it's done with the rows
  $("#tiebreaker").fadeOut();
};

function manage_bp_form() {
  $(".match_form.beer_pong .update_match_form").submit(function (event) {
    let bp_cups = prompt("How many cups were left?");
    if (isNaN(bp_cups) || bp_cups < 1 || bp_cups > 10) {
      event.preventDefault();
      alert("Please enter a number between 1 and 10");
    } else {
      $(this).find("input[name='olympics_match[bp_cups_remaining]']").val(bp_cups);
    }
  });
};

// ETOH
function startTime() {
  const today = new Date();
  let h = today.getHours();
  let m = today.getMinutes();
  let s = today.getSeconds();
  m = zeroPad(m);
  s = zeroPad(s);
  document.getElementById("clock").innerHTML =  h + ":" + m + ":" + s;
  setTimeout(startTime, 1000);
}

function zeroPad(i) {
  if (i < 10) {i = "0" + i};
  return i;
}

function initialize_etoh() {
  $(".delete_drink").click(function () {
    var text = $(this).prev("span").text();
    return confirm("Really delete '" + text + "'?");
  });

  startTime();
}
