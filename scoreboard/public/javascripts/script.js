$(document).ready(function() {
	var countdown = $('.countdown');
	if(countdown) {
		var ends = countdown.data('endsat');
		var duration = countdown.data('duration');
		setInterval(function() {
			var rest = Math.floor((ends - new Date().getTime()) / 1000);
			if(rest < 0) {
				location.reload();
			}
			var value = Math.floor(rest * 100 / duration);
			countdown.find('.progress-bar').attr('aria-valuenow', rest);
			countdown.find('.progress-bar').css('width', value + '%');
			countdown.find('.progress-bar').text(rest + 's');
		}, 1000);
	}
});
