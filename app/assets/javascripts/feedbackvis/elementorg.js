(function(d3) {
  window.elementorg = function(tableID, jsonArray, cords, img_width, img_height) {
	 
    var self = {};
    var jsonArr_labelsNkeys = [];
    var lastclicked = "";
    
    d3.select(tableID)
        .on("click", function(){
		var target = d3.event.target.tagName;
		console.log("click:"+target);
		if (target != "TEXT" && lastclicked !="")
		{	
			d3.select("#"+lastclicked).style("color","black" );
			d3.select("#"+lastclicked).style("font-weight","normal");
			$('#heatmapID_eleorg').remove();
			
			lastclicked = "";
		}
    });
    for (var i =0; i <= count(json_allColor.ele); i++)
    {
        for (var key in json_allColor.ele) {
  		  if (json_allColor.ele[key] == i && json_allColor.ele.hasOwnProperty(key)) 
  		  {jsonArr_labelsNkeys.push({"lable":key,"key":key}); }
  		}
    }
    
    jsonArray.sort( predicatBy("element") );
    
    for (var i =0; i < count(json_allColor.ele); i++)
    {
        $(tableID).append('<div class = "eletype" id = "eletype'+jsonArr_labelsNkeys[i].key+'"> <div class="eleorg-header">'+jsonArr_labelsNkeys[i].lable+'</div></div>');
        
        for (var j = 0; j < jsonArray.length; j++) {
        	if(jsonArray[j].typevote == i)
        	{
           	 //$('#eletype'+jsonArr_labelsNkeys[i].key).append('<div  class="eleorg-content">'+jsonArray[j].element+'</div>');
           	 
           	d3.select('#eletype'+jsonArr_labelsNkeys[i].key)
           	.append("div")
           	.attr("class","legendtext")
           	.attr("align","left")
           	.append("text")
         	.text(jsonArray[j].element)
         	.attr("id","org"+jsonArray[j].id)
         	.on("click", function(){
         		if (lastclicked != this.id)
         		{
         			if(lastclicked != "")
         			{
         				d3.select("#"+lastclicked).style("color","black" );
						d3.select("#"+lastclicked).style("font-weight","normal");
         			}
			
         			d3.select(this).style("color","#F6B149" );
					d3.select(this).style("font-weight","bold");
					$('#heatmapID_eleorg').remove();
					var currentheatmap = heatmap("#overlay", img_width, img_height, cords[this.id.slice(3)], 'heatmapID_eleorg');
					
					lastclicked = this.id		
					console.log(this.id);
         		}
         	})
            .on("mouseover", function(d){
				//d3.select(this).style("color","#F6B149" );
				//d3.select(this).style("font-weight","bold");
				//$('#heatmapID').remove();
				//var currentheatmap = heatmap("#overlay", img_width, img_height, cords[this.id.slice(3)]);	
			})
			.on("mouseout", function(d){
				//d3.select(this).style("color","black" );
				//d3.select(this).style("font-weight","normal");

				//$('#heatmapID').remove();
			});
           	
        	}
        } 
    }
    
    $(function(){
    	
    	// var $grid = $(tableID);
		// var height = $grid.height();
// 		
		// if( height > 0 ) { // or some other number
		    // $grid.height( 450 );
		// }else{
			 // $grid.height( 300 );
		// }


    	  $(tableID).masonry({
    	    // options
    	    itemSelector : '.eletype',
    	    columnWidth : 240,
    	    animate:false,
    	    resizeable:false 
    	  });
    	  
    	  $(tableID).height(365);
    	});


    function predicatBy(prop){
    	   return function(a,b){
    	      if( a[prop] > b[prop]){
    	          return 1;
    	      }else if( a[prop] < b[prop] ){
    	          return -1;
    	      }
    	      return 0;
    	   }
    	}
    function count(obj) {
  	  var i = 0;
  	  for (var x in obj)
  	    if (obj.hasOwnProperty(x))
  	      i++;
  	  return i;
  	}

return self;
  };
  
})(d3);

