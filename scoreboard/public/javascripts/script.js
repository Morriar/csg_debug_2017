$(document).ready(function() {
	$('.slot-icon').on('click', function() {
		var bid = $(this).data('bid');
		var tid = $(this).data('tid');
		var title = $(this).attr('title');
		$.get('/team/' + tid + '/' + bid, function(data) {
			$('#bugModal').find('.modal-title').text(title)
			$('#bugModal').find('.modal-body').html(data)
			$('#bugModal').modal();
		});
	});

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
