(function(d3) {
  window.elementorg = function(tableID, jsonArray, cords, img_width, img_height) {
	 
    var self = {};
    var jsonArr_labelsNkeys = [];
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
           	.attr("class","eleorg-content")
           	.append("text")
         	.text(jsonArray[j].element)
         	.attr("id","org"+jsonArray[j].id)
         	.on("mouseover", function(d){
			   	//object_heatnetwork.hide();
				d3.select(this).style("color","#F6B149" );
				d3.select(this).style("font-weight","bold");
				$('#heatmapID').remove();
				var currentheatmap = heatmap("#overlay", img_width, img_height, cords[this.id.slice(3)]);	
			})
			.on("mouseout", function(d){
				d3.select(this).style("color","black" );
				d3.select(this).style("font-weight","normal");

				$('#heatmapID').remove();
			   	//object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
		
		
				
			});
           	
        	}
        } 
    }
    
    $(function(){
    	  $(tableID).masonry({
    	    // options
    	    itemSelector : '.eletype',
    	    columnWidth : 240
    	  });
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

