$(document).ready(function(){

	$.getJSON("payments.json")
    .done(function(payment){
    	var payments = payment;
  		
  		var settled_value = parseInt($('#settled_value')[0].innerHTML);
    	var uncharged_value = parseInt($('#uncharged_value')[0].innerHTML);
    	var total = settled_value + uncharged_value;
    	var max_value = 125;
    	var big_value, small_value;
    	var bigger;

    	if(settled_value>uncharged_value){
    		bigger = "settled";
    		small_value = uncharged_value;
    		big_value = settled_value;
    	}else{
    		bigger = "uncharged";
    		small_value = settled_value;
    		big_value = uncharged_value;
    	}
        //debugger;
    	var ratio = big_value/100;

    	if(bigger == "settled"){
    		var settled_pixels = 150;
    		var uncharged_pixels = uncharged_value/ratio+25;
    	}else{
    		var settled_pixels = settled_value/ratio+25;
    		var uncharged_pixels = 150;
    	}
    	//debugger;
    	var str = '<svg width="320" height="320"><circle cx=160 cy=160 r="'+settled_pixels+'" stroke="#e0c0c0" stroke-width="4" fill="#d94e4e"/><text style="text-anchor: middle" x="160" y="165" font-family="sans-serif" font-size="20px" fill="white">$'+settled_value+'</text></svg>';
			$( "#total_paid_circle_settled" ).append(str);

		var stp = '<svg width="320" height="320"><circle cx=160 cy=160 r="'+uncharged_pixels+'" stroke="#bfd6ba" stroke-width="4" fill="#64a657" /><text style="text-anchor: middle" x="160" y="165" font-family="sans-serif" font-size="20px" fill="white">$'+uncharged_value+'</text></svg>';
			$( "#total_paid_circle_uncharged" ).append(stp);
		
        //$('#settled_circle').tipsy();

	});

});