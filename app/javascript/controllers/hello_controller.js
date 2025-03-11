import { Controller } from "@hotwired/stimulus"

// I literally do not have any idea why this works here
// ToDo: figure out this JS pipeline
$(document).ready(function () {
  var $match_display_div = $("#wrestle_bet_match_display")
  if ($match_display_div.length > 0) {
    var match_path = $match_display_div.attr("match-path");
    poll_for_match(match_path);
  };

  var $leaderboard_div = $("#wrestle_bet_leaderboard")
  if ($leaderboard_div.length > 0) {
    var tournament_path = $leaderboard_div.attr("tournament-path");
    poll_for_tournament(tournament_path);
  };
});

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
				console.log("ERROR - failed to get match data");
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

function set_winner(winner) {
  console.log("setting winner!", winner);
  reload_page_in_x_seconds(2);
};

function reload_page_in_x_seconds(seconds) {
  console.log("reloading page in ", seconds, " seconds");
	setTimeout(function () {
    window.location.reload(true);
  }, seconds * 1000);
};

