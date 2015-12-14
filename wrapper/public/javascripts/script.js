 $('[data-toggle="popover"]').popover();

$('.run-all').on('click', function() {
	$('.run-test:visible').trigger('click');
});

$('.run-test').on('click', function() {
	var btn = $(this)
	btn.attr('disabled', 'disabled');
	var td = btn.parent("td").next("td");
	td.empty();

	var url = btn.data().url;
	$.get(url, function(data) {
		// console.log(data);
		if(data.status == "success") {
			td.append(
				$('<button>')
				.addClass('btn btn-link')
				.append(
					$('<span>')
					.addClass("glyphicon glyphicon-ok text-success")
				)
				.append(
					$('<span>')
					.innerText = " Success"
				)
			);
		} else {
			td.append(
				$('<button>')
					.addClass('btn btn-link')
					.append(
						$('<span>')
						.addClass("glyphicon glyphicon-remove text-danger")
					)
					.append(
						$('<span>').innerText = " Failure")
				.attr("data-toggle", "popover")
				.attr("title", "Popover title")
				.attr("data-content", data.output)
				.attr("data-placement", "left")
				.attr("data-trigger", "focus")
				.popover()
			);
		}
		btn.removeAttr('disabled');
	});
});

$('.run-round').on('click', function() {
	var btn = $(this)
	btn.attr('disabled', 'disabled');
	var div = $("#roundResponse");
	div.empty();

	var url = btn.data().url;
	$.get(url, function(data) {
		div.append(
			$('<pre>').append(
				$('code').innerHTML = JSON.stringify(data, null, 4)
			)
		);
		btn.removeAttr('disabled');
	});
});
