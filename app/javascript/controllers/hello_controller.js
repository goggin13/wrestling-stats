import { Controller } from "@hotwired/stimulus"

// I literally do not have any idea why this works here
// ToDo: figure out this JS pipeline
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
        } else if (tournament.exposure != exposure_count) {
          console.log("Display exposure");
          exposure_count = tournament.exposure;
        } else if (tournament.challenges != challenge_count) {
          console.log("Display challenge");
          challenge_count = tournament.challenges;
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

