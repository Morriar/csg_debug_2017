//  Copyright 2015 Alexandre Terrasa <alexandre@moz-code.org>.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing perbugs and
//  limitations under the License.

$('[data-toggle="popover"]').popover();

function refreshProgress(progressbar, value, label) {
	progressbar.attr('aria-valuenow', value);
	progressbar.css('width', value + '%');
	progressbar.text(label);
}

function refreshBtn($panel, status) {
	$btn = $panel.find("#" + status.bug);
	$btn.removeClass("btn-success");
	$btn.removeClass("btn-danger");
	$btn.addClass(status.status == "success" ? "btn-success": "btn-danger");
}

$(function() {
	$('.slot-icon').on('click', function() {
		var bid = $(this).data('bid');
		var tid = $(this).data('tid');
		var title = $(this).attr('title');
		$.get('/team/' + tid + '/' + bid, function(data) {
			$('#bugModal').find('.modal-title').text(title)
			$('#bugModal').find('.modal-body').html(data)
			$('#bugModal').modal();
			$('[data-toggle="popover"]').popover();
		});
	});
});

$(function() {
	setInterval(function() {
		$('.panel-team-status').each(function(i, panel) {
			var tid = $(panel).data('tid');
			$.get('/json/team/' + tid, function(team) {
				$panelStatus = $('.panel-team-status[data-tid=' + team.id + ']');
				$panelStatus.find(".team-score").text(' ' + team.score + ' pts');
				refreshProgress($panelStatus.find(".progress-bar-o2"), team.oxygen/10, team.oxygen);
				refreshProgress($panelStatus.find(".progress-bar-zz"), team.energy/10, team.energy);
				if(team.isDead) {
					$panelStatus.removeClass('indanger');
					$panelStatus.addClass('team isdead');
				} else if(team.inDanger) {
					$panelStatus.removeClass('isdead');
					$panelStatus.addClass('team indanger');
				} else {
					$panelStatus.removeClass('indanger');
					$panelStatus.removeClass('isdead');
				}
			});
		});
	}, 1000);

	$('.panel-dome').each(function(i, panelDome) {
		setInterval(function() {
			$panelDome = $(panelDome);
			var tid = $panelDome.data('tid');
			$.get('/json/status/' + tid, function(status) {
				Object.keys(status.bugs).forEach(function(bug) {
					refreshBtn($panelDome, status.bugs[bug]);
				});
			});
		}, 1000);
	});

	$('.panel-round').each(function(i, panelRound) {
		setInterval(function() {
			$panelRound = $(panelRound);
			$.get('/json/round/', function(round) {
				var endsAt = round.startedAt + round.duration * 1000;
				var rest = Math.floor(new Date(endsAt - round.now) / 1000);
				var value = Math.floor(rest * 100 / round.duration)
				//refreshScore($panel, team.score)
				if(round.hideScoreboard) {
					$('.table-scoreboard').remove();
				}
				if($('#team-panel.team.isdead').length > 0) {
					$panelRound.find('h3').text('You are dead!');
					$panelRound.find('div').remove();
					$panelRound.addClass('team isdead');
					$panelRound.append($('<div>').text('You are a disgrace for the Empire. Please leave now.'))
				} else if(round.gameFinished) {
					$panelRound.find('h3').text('Competition is over');
					$panelRound.find('div').remove();
					$panelRound.removeClass('team isdead');
					$panelRound.append($('<div>').text('Please leave now.'))
				} else {
					$panelRound.find('h3').text('Round ' + round.round);
					$panelRound.removeClass('team isdead');
					refreshProgress($panelRound.find(".progress-bar-round"), value, rest + 's');
				}
			});
		}, 1000);
	});
});
