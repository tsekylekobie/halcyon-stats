$(function() {
	// Enable tooltips
	$('[data-toggle="tooltip"]').tooltip()

	// Highlight match-preview boxes depending on match result
	$('.match-preview').each(function() {
		if ($('#' + this.id + '.match-result').text().trim() == "Victory") {
			this.style.borderColor = '#37c33c';
		} else {
			this.style.borderColor = '#F7464A';
		}
	})

	// Display five match previews at a time
	$('.match-preview').css('display', 'none');
	displayMatchPreviews();
	$('#show-more-btn').click(displayMatchPreviews);
	// Same for match details
	$('.match-preview').click(function() { displayMatchDetails(this.id); });


    // Draw win loss graph
    var ctx = document.getElementById("winPercentage").getContext('2d');
    var data = [
	    {
	        value: $('span#wins').text(),
	        color: "#37c33c",
	        highlight: "#43d648",
	        label: "Wins"
	    },
	    {
	        value: $('span#losses').text(),
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Losses"
	    }
	]

    drawDonutChart(ctx, data);
});

function drawDonutChart(ctx, data) {
    var option = {
    	responsive: true,
    };

	new Chart(ctx).Doughnut(data, option);
}

// Displays (5) matches when called
function displayMatchPreviews() {
	var matches = $('.match-preview').filter(function() { return this.style.display == 'none'});
	if (matches.length > 0) {
		for (var i = 0; i < 5; i++) {
			matches[i].style.display = "block";
		}
	} else {
		$('#show-more-btn').hide();
		$('#no-more-text').show();
	}
}

function displayMatchDetails(id) {
	$('.match-details').hide();
	$('#' + id + '.match-details').show();
}
