(function(d3) {
  window.explain = function(divID,jsonArray, img_width, img_height) {
	//console.log("jsonArray:"+jsonArray);
    var self = {};
    

    
    for (var i = 0; i < jsonArray.length; i++) {
    	
    	var id = jsonArray[i].id;
    	var txt = jsonArray[i].txt;
    	var cord = jsonArray[i].cord;
    	
    	//var cords[0] = new Array(jsonArray[i].cord);
    
    	
    	$(divID).append('\
    	<div style= "padding-left:10px">\
	    	<div class="comment more span10" id = "'+id+'" data-cord ="'+cord+'">'+txt+'\
	    	</div>\
	    	<div class = "span1" style = "width:30px; margin:5px 0 0 0">\
	    	  <div style = "width:20px; height:20px">\
	    	  <a><i class="icon-thumbs-up icon-1x span1" style = "color:red; margin:0px"></i></a>\
	    	  </div>\
	    	  <div style = "width:20px; height:20px">\
	    	  <a><i class="icon-thumbs-down icon-1x span1" style = "color:red; margin:0px"></i></a>\
	    	  </div>\
	    	</div>\
    	</div>\
    	');

		///* top=1em, right=2em, bottom=3em, left=2em */
    	//<i class="icon-camera-retro icon-1x" style = "color:red; width:10px"></i>
    	// <a class="btn btn-success" href="#"> <i class="icon-camera-retro icon-3x" style = "color:red"></i> </a>
    	

    }
  
    for (var i = 0; i < jsonArray.length; i++) {
    	var id = jsonArray[i].id;
    	//console.log("add event begin:");
		$('#'+id)
		// .mouseup(function(e) {
			// console.log("isup:"+e.which);
	      // })	
	      // .mousedown(function(e) {
			// console.log("isdown:"+e.which);
	      // })
	    .on("click", function(d){
	    	if($('#heatmapID').length != 0)
		   		$('#heatmapID').remove();
		   		
				object_heatnetwork.hide();
	
				var temp = new Array();
				var str = $('#'+this.id).data('cord');
				temp = str.split(",");
		    	var cords = new Array();
		    	cords[0] =temp;
		    	console.log(this.id);
		    	console.log(temp);
		    	
			 	heatmap("#overlay", img_width, img_height,cords);
		})
		.mouseover(function(e) {
			//console.log("1111111:"+e.which);
			
			// if (mouseUpDown == 0)//if left buttons is not clicked
		   	// { 
		   		// if($('#heatmapID').length != 0)
		   		// $('#heatmapID').remove();
// 		   		
				// object_heatnetwork.hide();
// 	
				// var temp = new Array();
				// var str = $('#'+this.id).data('cord');
				// temp = str.split(",");
		    	// var cords = new Array();
		    	// cords[0] =temp;
		    	// console.log(this.id);
		    	// console.log(temp);
// 		    	
			 	// heatmap("#overlay", img_width, img_height,cords);
		   	// }
			
		})	
	.mouseout(function(e){
			//if (e.which == 0)//if left buttons is not clicked
		   //	{
				$('#heatmapID').remove();
			   	object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
			//}

		});
    	
    	

    }
    	var showChar = 320;
    	var ellipsestext = "...";
    	var moretext = "more";
    	var lesstext = "less";
    	$('.more').each(function() {
    		var content = $(this).html();

    		if(content.length > showChar) {

    			var c = content.substr(0, showChar);
    			var h = content.substr(showChar-1, content.length - showChar);

    			var html = c + '<span class="moreelipses">'+ellipsestext+'</span>&nbsp;<span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink">'+moretext+'</a></span>';

    			$(this).html(html);
    		}

    	});

    	$(".morelink").click(function(){
    		if($(this).hasClass("less")) {
    			$(this).removeClass("less");
    			$(this).html(moretext);
    		} else {
    			$(this).addClass("less");
    			$(this).html(lesstext);
    		}
    		$(this).parent().prev().toggle();
    		$(this).prev().toggle();
    		return false;
    	});

	
return self;
  };
  
})(d3);

