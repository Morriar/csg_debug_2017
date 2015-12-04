 $('[data-toggle="popover"]').popover();

$('.run-build').on('click', function() {
	$this = $(this)
	$this.attr('disabled', 'disabled');
	var td = $this.parent("td").next("td");
	td.empty();

	var version = $this.data().version;
	$.get( "/json/build/" + version, function(data) {
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
				.attr("data-content", data.message)
				.attr("data-placement", "left")
				.attr("data-trigger", "focus")
				.popover()
			);
		}
		$this.removeAttr('disabled');
	});
});

$('.run-all').on('click', function() {
	$('.run-test').trigger('click');
});

$('.run-test').on('click', function() {
	var btn = $(this)
	btn.attr('disabled', 'disabled');
	var td = btn.parent("td").next("td");
	td.empty();

	var version = btn.data().version;
	var test = btn.data().test;
	$.get( "/json/check/" + version + '/' + test, function(data) {
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
				.attr("data-content", data.message)
				.attr("data-placement", "left")
				.attr("data-trigger", "focus")
				.popover()
			);
		}
		btn.removeAttr('disabled');
	});
});
