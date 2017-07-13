$(function() {
	// Enable tooltips
	$('[data-toggle="tooltip"]').tooltip()

	// Enable tab functions
	$('#myTab a').click(function (e) {
  		e.preventDefault()
  		$(this).tab('show')
	})

	// Highlight match-preview boxes depending on match result
	$('.match-title-bar').each(function() {
		if ($('#' + this.id + '.match-result').text().trim() == "Victory") {
			this.style.backgroundColor = '#37c33c';
		} else {
			this.style.backgroundColor = '#F7464A';
		}
	})

	// Display five match previews at a time
	$('.match-preview').css('display', 'none');
	displayMatchPreviews();
	$('#show-more-btn').click(displayMatchPreviews);
	// Same for match details
	$('.match-preview').click(function() {
		displayMatchDetails(this.id);
		$(".match-preview").map(function() {this.style.backgroundColor = "#F2F2F2"});
		this.style.backgroundColor = "#ABABAB";
	});


    // Draw win loss chart
    var ctx = $("#winPercentage");
    var data = {
	    labels: ["Wins", "Losses"],
	    datasets: [
		    {
		        data: [wins, losses],
		        backgroundColor: ["#37c33c", "#F7464A"]
		    }
		]
	}
	var option = {
    	responsive: true,
    	legend: {
    		display: false
    	},
    	layout: {
            padding: {
            	left: 10,
            	right: 10,
            	top: 0,
            	bottom: 0
            }
        }
    };
	new Chart(ctx, {
		type: 'doughnut',
		data: data, 
		options: option
	});
	
	// Draw win loss chart per side
	ctx = $("#leftPercentage");
	var width = $("#leftPercentage").width;

    data = {
    	labels: ["Wins", "Losses"],
    	datasets: [
		    {
		        data: [sideRecord["left"]["wins"], sideRecord["left"]["losses"]],
		        backgroundColor: ["#37c33c", "#F7464A"]
		    }
		]
	}
	new Chart(ctx, {
		type: 'doughnut',
		data: data, 
		options: option
	});

	ctx = $("#rightPercentage");
    data = {
	    labels: ["Wins", "Losses"],
	    datasets: [
		    {
		        data: [sideRecord["right"]["wins"], sideRecord["right"]["losses"]],
		        backgroundColor: ["#37c33c", "#F7464A"]
		    }
		]
	}
	new Chart(ctx, {
		type: 'doughnut',
		data: data, 
		options: option
	});

	var option1 = {
    	responsive: false,
    	legend: {
    		display: false
    	},
    	scales: {
      		yAxes: [
      			{
    				id: 'y-axis-1',
    				type: 'linear',
    				position: 'right',
    				ticks: {
    					min: 0,
    					max: 5
    				}
    			},
      			{
    				id: 'y-axis-0',
    				type: 'linear',
    				position: 'left',
    				ticks: {
            	    	min: 0,
            	    	max: 50,
            	    	callback: function(value, index, values) {
            	           return value + 'k';
            	    	}
            	    }
    			}
      		],
      		xAxes: [{
      			barPercentage: .75
      		}]
      	},
      	tooltips: {
            enabled: true,
            mode: 'single',
            callbacks: {
                label: function(tooltipItems, data) {
                	if (!Number.isInteger(tooltipItems.yLabel)) return (tooltipItems.yLabel * 10).toFixed(1) + 'k';
                	else return tooltipItems.yLabel;
                }
            }
        },
	}

	var headToHeadArray = $(".head-to-head");
	for (var i = 0; i < headToHeadArray.length; i++) {
		var rosters = matchRosters.filter(function(obj) { return obj.match_id == headToHeadArray[i].id; });
		var roster1 = rosters.filter(function(obj) { return obj.left == true; })[0];
		var roster2 = rosters.filter(function(obj) { return obj.left == false; })[0];
		var data = {
    		labels: ["Total Gold", "Kraken Steals", "Aces"],
    		datasets: [
    		    {
    		        label: "Blue Team",
    		        backgroundColor: "#3A96E8",
    		        data: [(roster1.gold / 1000 / 50 * 5), // Scale gold to kraken and aces values
    		        		parseInt(roster1.kraken),
    		        		parseInt(roster1.aces)]
    		    },
    		    {
    		    	label: "Red Team",
    		    	backgroundColor: "#FE4D4D",
    		        data: [(roster2.gold / 1000 / 50 * 5),
    		        		parseInt(roster2.kraken),
    		        		parseInt(roster2.aces)]
    		    }
    		]
		};
		new Chart(headToHeadArray[i], {
			type: 'bar',
			data: data, 
			options: option1
		});
	}
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
