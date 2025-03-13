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
  $("#advocate_aggregate_toggle_extra_data").click(function () {
    $(".aggregate_extra_data").toggle();
  });
  $("#toggle_copy_paste").click(function () {
    $("#staffing_grid_container").toggleClass("for_copy_paste");
  });
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

/* WRESTLE_BET */

$(document).ready(function () {
  var $match_display_div = $("#wrestle_bet_match_display")
  if ($match_display_div.length > 0) {
    var match_path = $match_display_div.attr("match-path");
    var tournament_path = $match_display_div.attr("tournament-path");
    poll_for_prop_bet(tournament_path);
    poll_for_match(match_path);
  };

  var $leaderboard_div = $("#wrestle_bet_leaderboard")
  if ($leaderboard_div.length > 0) {
    var tournament_path = $leaderboard_div.attr("tournament-path");
    poll_for_tournament(tournament_path);
    poll_for_prop_bet(tournament_path);
  };

  var $prop_bet_toggle = $("#prop_bet_toggle");
  if ($prop_bet_toggle.length > 0) {
    hide_show_prop_bets($prop_bet_toggle);
  }

  console.log("checling");
  if ($("#wrestle_bet_betslip").length > 0) {
    listen_for_bets();
  }
});

function poll_for_prop_bet(tournament_path) {
  console.log("polling for prop bets:", tournament_path);
  var initial = true;
  var jesus_count = -1;
  var exposure_count = -1;
  var challenge_count = -1;

  var poll = function () {
    $.getJSON(tournament_path)
      .done(function (tournament) {
        console.log(tournament);

        if (initial) {
          initial = false;
          console.log("initializing prop_bets");
          jesus_count = tournament.jesus;
          exposure_count = tournament.exposure;
          challenge_count = tournament.challenges;
        } else if (tournament.jesus != jesus_count) {
          console.log("Display Jesus");
          jesus_count = tournament.jesus;
          show_jesus();
        } else if (tournament.exposure != exposure_count) {
          console.log("Display exposure");
          exposure_count = tournament.exposure;
          show_exposure();
        } else if (tournament.challenges != challenge_count) {
          console.log("Display challenge");
          challenge_count = tournament.challenges;
          show_challenge();
        }

        setTimeout(poll, 5000);
      }).fail(function (data) {
        console.log("ERROR - failed to get tournament data");
        console.log(data);
      });
  }

  poll();
}

function poll_for_tournament(tournament_path) {
  console.log("polling for tournament:", tournament_path);
  var poll = function () {
    $.getJSON(tournament_path)
      .done(function (tournament) {
        console.log(tournament);
        if (tournament.match_in_progress) {
          console.log("new match starting");
          reload_page_in_x_seconds(1);
        } else {
          setTimeout(poll, 5000);
        }
      }).fail(function (data) {
        console.log("ERROR - failed to get tournament data");
        console.log(data);
      });
  }

  poll();
};

function poll_for_match(match_path) {
  console.log("polling for match:", match_path);
  var poll = function () {
    $.getJSON(match_path)
      .done(function (match) {
        console.log(match);
        if (match.home_score !== null) {
          console.log("winner!");
          set_winner(match.home_score > match.away_score ? "home" : "away");
        } else {
          setTimeout(poll, 5000);
        }
      }).fail(function (data) {
        console.log("ERROR - failed to get match data");
        console.log(data);
      });
  }

  poll();
};

function random_fatality() {
  var root = "https://dumbledore-public-assets.s3.us-east-1.amazonaws.com/fatalaties/";
  var min = 1;
  var max = 27;
  var random = Math.floor(Math.random() * (max - min + 1) + min);

  return root + random + ".gif";
};

function set_winner(winner) {
  var loser = winner == "home" ? "away" : "home";
  var fatality = random_fatality();
  console.log("fatality");
  $("#" + loser + "_wrestler").attr("src", fatality);
  console.log("setting winner!", winner);
  reload_page_in_x_seconds(20);
};

function show_jesus() {
  const sound = new Audio("/assets/heaven.mp3");
  sound.play();
  $("#wrestle_bet_jesus").fadeIn(7000);
  reload_page_in_x_seconds(15);
};

function show_exposure() {
  $("#wrestle_bet_exposure").fadeIn(7000);
  reload_page_in_x_seconds(10);
};

function show_challenge() {
  $("#wrestle_bet_challenge").fadeIn(7000);
  reload_page_in_x_seconds(10);
};

function reload_page_in_x_seconds(seconds) {
  console.log("reloading page in ", seconds, " seconds");
  setTimeout(function () {
    window.location.reload(true);
  }, seconds * 1000);
};

function hide_show_prop_bets($prop_bet_toggle) {
  $prop_bet_toggle.click(function () {
    $("#prop_bet_content").toggle();
    $(".prop_bets_hide_show").toggle();
  });
}

function listen_for_bets() {
  console.log("listening");
  $("#wrestle_bet_spread_bets td.wrestle_bet_wrestler form").on("submit", function(e) {
    e.preventDefault();
    console.log("clicked");

    var $form = $(this);
    var match_id = $(this).find('input[name="wrestle_bet_spread_bet[match_id]"]').val();
    var wager = $(this).find('input[name="wrestle_bet_spread_bet[wager]"]').val();
    var form_data = {
      wrestle_bet_spread_bet: {
        match_id: match_id,
        wager: wager
      }
    };
    console.log("POSTing ", form_data);
    console.log($("meta[name='csrf-token']").attr("content"));

    var path = "/wrestle_bet/spread_bets";

    $.ajax({
      url: path,
      type: "POST",
      contentType: "application/json",
      headers: {
        "X-CSRF-Token": $("meta[name='csrf-token']").attr("content"),
        "Accept": "application/json"
      },
      data: JSON.stringify(form_data),
      success: function(response) {
        console.log("Success:", response);
        $form.parents("tr").children("td").removeClass("current_bet");
        $form.parents("td").addClass("current_bet");
      },
      error: function(xhr, status, error) {
        try {
          const error_data = JSON.parse(xhr.responseText);
          console.log('Parsed error data:', error_data);
          alert(error_data.error);
          reload_page_in_x_seconds(0);
        } catch (e) {
          console.log('Response is not JSON');
        }
      }
    });
  });
};
