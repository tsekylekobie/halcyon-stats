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
		        data: [wins],
		        backgroundColor: "#37c33c",
		        label: "Wins"
		    },
		    {
		        data: [losses],
		        backgroundColor:"#F7464A",
		        label: "Losses"
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
		        data: [sideRecord["left"]["wins"]],
		        backgroundColor: "#37c33c",
		        label: "Wins"
		    },
		    {
		        data: [sideRecord["left"]["losses"]],
		        backgroundColor:"#F7464A",
		        label: "Losses"
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
		        data: [sideRecord["right"]["wins"]],
		        backgroundColor: "#37c33c",
		        label: "Wins"
		    },
		    {
		        data: [sideRecord["right"]["losses"]],
		        backgroundColor:"#F7464A",
		        label: "Losses"
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
      		yAxes: [{
         		ticks: {
                   min: 0,
                   callback: function(value, index, values) {
                       return value + 'k';
                   }
                }
      		}],
      		xAxes: [{
      			barPercentage: .75
      		}]
      	},
      	tooltips: {
            enabled: true,
            mode: 'single',
            callbacks: {
                label: function(tooltipItems, data) { 
                    return tooltipItems.yLabel + 'k';
                }
            }
        },
	}
	var option2 = {
		responsive: false,
		legend: {
			display: false
		},
   		scales: {
      		yAxes: [{
      			position: 'right',
        		ticks: {
            		min: 0,
           			max: 5
	         	}
	      	}],
	      	xAxes: [{
      			barPercentage: .75
      		}]
	   }
	}

	var headToHead1Array = $(".head-to-head1");
	var headToHead2Array = $(".head-to-head2");
	for (var i = 0; i < headToHead1Array.length; i++) {
		var ctx1 = headToHead1Array[i];
		var ctx2 = headToHead2Array[i];
		var rosters = matchRosters.filter(function(obj) { return obj.match_id == headToHead1Array[i].id; });
		var roster1 = rosters.filter(function(obj) { return obj.left == true; })[0];
		var roster2 = rosters.filter(function(obj) { return obj.left == false; })[0];
		var data1 = {
    		labels: ["Total Gold"],
    		datasets: [
    		    {
    		        label: "Blue Team",
    		        backgroundColor: "#3A96E8",
    		        data: [(roster1.gold / 1000).toFixed(1)]
    		    },
    		    {
    		    	label: "Red Team",
    		    	backgroundColor: "#FE4D4D",
    		        data: [(roster2.gold / 1000).toFixed(1)]
    		    }
    		]
		};
		var data2 = {
			labels: ["Kraken Steals", "Aces Earned"],
			datasets: [
				{
    		        label: "Blue Team",
    		        backgroundColor: "#3A96E8",
    		        data: [parseInt(roster1.kraken), parseInt(roster1.aces)]
    		    },
    		    {
    		    	label: "Red Team",
    		    	backgroundColor: "#FE4D4D",
    		        data: [parseInt(roster2.kraken), parseInt(roster2.aces)]
    		    }
			]
		}
		new Chart(ctx1, {
			type: 'bar',
			data: data1, 
			options: option1
		});
		new Chart(ctx2, {
   			type: 'bar',
   			data: data2,
   			options: option2
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
