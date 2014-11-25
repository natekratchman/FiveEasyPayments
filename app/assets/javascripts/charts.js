$(document).ready(
  function Charts(){
    // var settled_count = $('#settled_count').text
    // var pending_count = $('#pending_count').text
    // var uncharged_count = $('#uncharged_count').text

    var settled_count = 5;
    var pending_count = 6;
    var uncharged_count = 2;

		var data = [
    	{
        value: settled_count,
        color:"#F7464A",
        highlight: "#FF5A5E",
        label: 'Settled',
        labelColor : 'white',
        labelFontSize : '16'
      },
      {
        value: pending_count,
        color: "#46BFBD",
        highlight: "#5AD3D1",
        label: 'Pending',
        labelColor : 'white',
        labelFontSize : '16'
      },
      {
        value: uncharged_count,
        color: "#FDB45C",
        highlight: "#FFC870",
        label: 'Uncharged',
        labelColor : 'white',
        labelFontSize : '16'
      }
    ]

    var options = {}

    //var ctx = document.getElementById('TransactionPieChart').getContext("2d");
    //var myPieChart = new Chart(ctx).Doughnut(data,options);

	}

)