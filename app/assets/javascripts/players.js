
$(function() {
	// Enable tooltips
	$('[data-toggle="tooltip"]').tooltip()

	// Enable tab functions
	$('#myTab a').click(function (e) {
  		e.preventDefault()
  		$(this).tab('show')
	})

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


    // Draw win loss chart
    var ctx = document.getElementById("winPercentage").getContext("2d");
    var data = [
	    {
	        value: wins,
	        color: "#37c33c",
	        highlight: "#43d648",
	        label: "Wins"
	    },
	    {
	        value: losses,
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Losses"
	    }
	]
	var option = {
    	responsive: true,
    };
	new Chart(ctx).Doughnut(data, option);
	console.log(sideRecord);
	// Draw win loss chart per side
	ctx = document.getElementById("leftPercentage").getContext("2d");
    data = [
	    {
	        value: sideRecord["left/blue"]["wins"],
	        color: "#37c33c",
	        highlight: "#43d648",
	        label: "Wins"
	    },
	    {
	        value: sideRecord["left/blue"]["losses"],
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Losses"
	    }
	]
	new Chart(ctx).Doughnut(data, option);

	ctx = document.getElementById("rightPercentage").getContext("2d");
    data = [
	    {
	        value: sideRecord["right/red"]["wins"],
	        color: "#37c33c",
	        highlight: "#43d648",
	        label: "Wins"
	    },
	    {
	        value: sideRecord["right/red"]["losses"],
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Losses"
	    }
	]
	new Chart(ctx).Doughnut(data, option);
});

// Displays (5) matches when called
function displayMatchPreviews() {
	var matches = $('.match-preview').filter(function() { return this.style.display == 'none'});
	if (matches.length > 0) {
		for (var i = 0; i < Math.min(matches.length, 5); i++) {
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
