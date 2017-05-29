$(function() {
    var ctx = document.getElementById("winPercentage").getContext('2d');
    drawWinLossChart(ctx, 120, 200);
});

function drawWinLossChart(ctx, wins, losses) {
	var data = [
	    {
	        value: losses,
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Losses"
	    },
	    {
	        value: wins,
	        color: "#37c33c",
	        highlight: "#43d648",
	        label: "Wins"
	    }
	]
   
    var option = {
    	responsive: true,
    };

    new Chart(ctx).Doughnut(data, option);
}
