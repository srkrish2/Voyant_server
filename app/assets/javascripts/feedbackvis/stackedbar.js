(function(d3) {
  window.stackedbars = function(containID, contianLegendID, mode, arrs, lables, tooltips, xlables, headmapImgCanvas, img_width, img_height, cords) {

    var self = {};
    var json_mode = {"mode_criteria":"guide", "mode_goal":"goal"};
    
    var optFilters_subtypescore_bak;
    
    Array.prototype.repeat= function(what, L){
    	 while(L) this[--L]= what;
    	 return this;}
    var arrLegendChecked = [].repeat(1, arrs.length);
   
    
    var w = 240; //legend width
    var container = d3.select(containID)
        .on("click", function(){
		var target = d3.event.target.tagName;
		console.log("click:"+target);
		if (target == "svg" && lastclicked !="")
		{	
			optFilters[json_mode[mode]].subtypescore = [];
			
			for (var j = 0; j < arrLegendChecked.length; j++) {
		    	if(arrLegendChecked[j] == 1)
		    		{//add one subtype
		    			addOneSubtype(j,num_samples);
		    		
		    		}
		    }

			d3.select("#"+lastclicked).style("stroke-width",0);
			lastclicked = "";
			optFilters[json_mode[mode]].isClickedTextPanel =  false;
			if ( isHeatmapvisible == "true")
	    	 {
		    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
	    	 }

			}
        });
    
    var arrOrg = []; while(arrOrg.push([]) < arrs.length);
	for ( var r = 0; r < arrs.length; r++) {
		for ( var i = 0; i < arrs[r].length; i++) {
			arrOrg[r][i] =  arrs[r][i];
		}
	}

	var arrBarHeightForLegendChecked = []; while(arrBarHeightForLegendChecked.push([]) < arrs.length);
	for ( var r = 0; r < arrs.length; r++) {
		for ( var i = 0; i < arrs[r].length; i++) {
			arrBarHeightForLegendChecked[r][i] =  arrs[r][i];
		}
	}

    
	for ( var r = 0; r < arrs.length; r++) {
		for ( var i = 0; i < arrs[r].length; i++) {
			arrs[r][i] = {
				x : i,
				y : arrs[r][i],
				l : r,
				groupID:mode+"_"+r,
				id: mode+"_"+r+"_"+i
			};
		}
	}

	var num_layers = arrs.length; // number of layers
	var num_samples = arrs[0].length; // number of samples per layer
	console.log("arrLegendChecked:"+arrLegendChecked);
	
    for (var j = 0; j < arrLegendChecked.length; j++) {
    	if(arrLegendChecked[j] == 1)
    		{//add one subtype
    			addOneSubtype(j,num_samples);
    		
    		}
    }
 	console.log("arry:"+optFilters[json_mode[mode]].subtypescore);


	self.getCurrentData = function(){return arrs;}
    
    self.getOrgData = function(){ return arrOrg;}
    
	self.getLegendCheckedData = function(){return arrBarHeightForLegendChecked;}

    
    self.update = function(arrTmp) {
    	
    	for ( var r = 0; r < arrTmp.length; r++) {
			for ( var i = 0; i < arrTmp[r].length; i++) {
				arrs[r][i] = {
					x : i,
					y : arrTmp[r][i],
					l : r,
					groupID:mode+"_"+r,
					id: mode+"_"+r+"_"+i
				};
			}
		}
    	
    	layers = d3.layout.stack()(arrs);
    	
    	layer = svg.selectAll(".layer"+mode)
        .data(layers)
        .attr("class", "layer"+mode);

    	rect = layer.selectAll("rect")
    	    .data(function(d) { return d; })
    	    //.style("stroke-width",0)
    	    //.attr("x", function(d) { return x(d.x); })
    	    //.attr("y", function(d) { return y(d.y0 + d.y); })
    	    //.attr("width", x.rangeBand())
    	     //.attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); })
    	    .attr("id", function(d) { return d.id; })
    	    .attr("class", function(d) { return d.groupID; });
    	
    		var isChecked = d3.select("#"+mode+"switch").attr("checked");	
    		console.log("is Summary checked:"+isChecked);
    		//if (false) //anbang make fig
    		if (isChecked == "false" && isCheckedLegend())
	         {
	  		     //d3.select("#"+mode+"switch").attr("checked",true);
	  			 transitionStacked(250,yGroupMax);
	
	         }else if (isChecked == "false" && !isCheckedLegend()){//none is checked
	        	 transitionGrouped(100);
	         }
	  		 else{
	             //d3.select("#"+mode+"switch").attr("checked",false);	  
	        	 transitionStacked(200,yStackMax);
	
	         }
	      		
  		 
    	
    	
    	
    	//console.log(arrTmp);

    	
    }
		

		
		if (num_layers<2) {
			// 1 layer - "group" and "stack" make no sense here.
			//dojo.style(this.modeButtons, "display", "none");
		}
				
		
		
		var layers = d3.layout.stack()(arrs);
    
   // var n = 3, // number of layers
   // m = 7, // number of samples per layer
   // stack = d3.layout.stack(),
    //layers = stack(d3.range(n).map(function() { return bumpLayer(m, .1); })),
    var yGroupMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y; }); });
    var yStackMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); });

	var margin = {top: 10, right: 10, bottom: 20, left: 40},
	    width = 300 - margin.right,
	    height = 200 - margin.top - margin.bottom;


	var x = d3.scale.ordinal()
    .domain(d3.range(num_samples))
	.rangeRoundBands([0, width], .08);
	
	var y = d3.scale.linear()
	    .domain([0, yStackMax])
	    .range([height, 0]);
	
	//var color = ["#69D2E7","#E0E4CC","#E08E79","#774F38","#95D4EC"];
	//var color = d3.scale.category10();

	
	var xAxis = d3.svg.axis()
	    .scale(x)
	    .tickSize(1)
	    .tickPadding(6)
	    .orient("bottom");
	
	var yAxis = d3.svg.axis()
	  .scale(y)
	  .tickSize(1)
	  .orient("left")
	  .ticks(5);

	
	//xAxis.tickValues(xlables.map( function(d,i) { if(i == 0 || i == 6 ){return d;}else{return i;} } ).filter(function (d) { return !!d; } ));
	//xAxis.tickValues(xlables.map( function(d,i) { if(i == 0 || i == 6 ) 
	//											  {return d;}else{return "null";}
	//
	//											} ));
	
	//xAxis.tickValues(xlables);
	
	xAxis.tickFormat(function(d, i){
	    return xlables[i]; //"Year1 Year2, etc depending on the tick value - 0,1,2,3,4"
	});
	

	//xAxis.tickValues(xlables.map( function(d,i) {return d; } ).filter(function (d) { return !!d; } ));

var svg = 
	container.append("svg")
    .attr("width", 420)
    .attr("height",200)
    .attr("class", "textintextpanle")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    ;
    //.attr("width", width + margin.left + margin.right)
    //.attr("height", height + margin.top + margin.bottom)
	
	var lastclicked = "";
	var layer = svg.selectAll(".layer"+mode)
	
    .data(layers)
    .enter().append("g")
    .attr("class", "layer"+mode)
    .style("fill", function(d, i) { return arr_allColor[i]; });

	var rect = layer.selectAll("rect")
	    .data(function(d) { return d; })
	    .enter().append("rect")
	    //.style("stroke-width",0)
	    .attr("x", function(d) { return x(d.x); })
	    .attr("y", height)
	    .attr("width", x.rangeBand())
	    .attr("height", 0)
	    .attr("id", function(d) { return d.id; })
	    .attr("class", function(d) { return d.groupID; })
	    //.attr("value", "barblock")
	    ;
	rect.on("mouseover", function(d){
		if (this.id != lastclicked)
		{
			d3.select(this).style("stroke","black");
			d3.select(this).style("stroke-width",1);
		}
		//mode_goal_0_3

	    optFilters_subtypescore_bak = (optFilters[json_mode[mode]].subtypescore).slice(0);//copy the arry

		optFilters[json_mode[mode]].subtypescore = [];
		optFilters[json_mode[mode]].subtypescore.push(convertTextPanelIDtoOptFiltersID(this.id));
		if(lastclicked !="")
		{optFilters[json_mode[mode]].subtypescore.push(convertTextPanelIDtoOptFiltersID(lastclicked));}
		console.log(optFilters[json_mode[mode]].subtypescore);
		
	    if ( isHeatmapvisible == "true")
	    {
		    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
	    }else{
	    		//$('#heatmapID').remove();
	 		 	//var currentheatmap = heatmap(headmapImgCanvas, img_width, img_height, cords[d.id.slice(5)]);
	    }
		
		//console.log(this.id);
		//$('#heatmapID').remove();
		 
	 	//var cords=[[0,0,51,104],[29,34,80,123],[50,50,180,223]];
	 	//var currentheatmap = heatmap(headmapImgCanvas, img_width, img_height, cords[d.id.slice(5)]);
	 
	 	
	 	//setTimeout(function() { $('.heatmapline').remove(); }, 1000);
	 	//setTimeout(function() {heatmap(imgSVG, img_width, img_height, cords); }, 2000);

    	})
    	
    .on("mouseout", function(d){
    	if (this.id != lastclicked)
		{
			d3.select(this).style("stroke-width",0);
		}
		optFilters[json_mode[mode]].subtypescore = [];
		optFilters[json_mode[mode]].subtypescore = optFilters_subtypescore_bak.slice(0);

    	
//    	var idTmp = (this.id).slice(5);
//    	if (this.id != lastclicked)
//    	{
//    		for(var i = optFilters[json_mode[mode]].subtypescore.length-1; i >= 0; i--){  
//        	    if( optFilters[json_mode[mode]].subtypescore[i] == idTmp){      
//        	    	
//        	    	 optFilters[json_mode[mode]].subtypescore.splice(i,1);                 
//        	    }
//        	}
//    	}
    	if ( isHeatmapvisible == "true")
    	 {
	    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
    	 }else
    	{
 			$('#heatmapID').remove();
    	}
    	})
    	
    .on("click", function(d){
    	if (this.id != lastclicked)
    	{
        	var isCtrl = d3.event.ctrlKey;

    		if(isCtrl) {
    			if(optFilters_subtypescore_bak.indexOf(convertTextPanelIDtoOptFiltersID( this.id)) == -1)
				 {
    				optFilters_subtypescore_bak.push(convertTextPanelIDtoOptFiltersID( this.id));
				 }
    			optFilters[json_mode[mode]].subtypescore  = (optFilters_subtypescore_bak).slice(0);//copy the arry

    			console.log("ctrl+left click");
    		}
    		
    		if(lastclicked !="" && !isCtrl)
			{

    			
				console.log("last clicked: "+lastclicked);
				d3.select('#'+lastclicked).style("stroke-width",0);
				
				//console.log("filterbefore:"+optFilters.imp.subtype);
				
				for(var i =  optFilters[json_mode[mode]].subtypescore.length-1; i >= 0; i--){  
            	    if( optFilters[json_mode[mode]].subtypescore[i] ==  convertTextPanelIDtoOptFiltersID(lastclicked)){      
            	    	
            	    	 optFilters[json_mode[mode]].subtypescore.splice(i,1);                 
            	    }
            	}
				
			}
		    optFilters_subtypescore_bak = (optFilters[json_mode[mode]].subtypescore).slice(0);//copy the arry

			lastclicked = this.id;
			optFilters[json_mode[mode]].isClickedTextPanel =  true;
			
        	//d3.select(this).style("stroke","#F6B149");
        	d3.select(this).style("stroke","black");
    		d3.select(this).style("stroke-width",2);
    		
    		if ( isHeatmapvisible == "true")
	    	 {
		    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
	    	 }else{
	    		 var ratingID = this.id.slice(5);
	    		 	console.log("raingID:"+ratingID);
	        		//get the explaination via this ID	
	        		var containerID = '#explain_'+mode.slice(5);
	    		 	$(containerID).empty();
	    			var idArr = ratingID.split("_");
	    		 	console.log("mode:"+containerID);	
	    			
	    			$.ajax({
	    				type: "GET",
	    				url: "get_score_comments.php",
	    				data: { type: idArr[0], gid: idArr[1], score: idArr[2]}
	    			}).done(function( result ) {
	    				var jsonArrayOneImpTmp = $.parseJSON(result);
	    				var jsonArrayOneImp = jsonArrayOneImpTmp;
	    				var crurrentexplains = explain(containerID,jsonArrayOneImp, img_width, img_height);
	    				
	    			});				
	    			//one rating: goal_0_0 or criteria_0_0
	    		 	//json = JSON.parse( myjson );
	    		 	/*
	    			var jsonArrayOneImp = [
	    	                 {'id': 'goal_0_0',
	    	                'cord':[50,50,180,223],
	    	                'txt' : '1JavaScript is a general purpose programming language that was introduced as the page scripting language for Netscape Navigator'
	    	                 },
	    	                 {'id':'goal_0_1',
	    	                'cord':[0,0,51,104],
	    	                'txt' : '2JavaScript is a general purpose programming language that was introduced as the page scripting language for Netscape Navigator'
	    	                 }
	    		 	] ;
	    		 	*/
	    		 
	    	 }
    		 
        		
    	}
    	
		 	
    	})	
    	;
	
	rect.transition()
	    .delay(function(d, i) { return i * 10; })
	    .attr("y", function(d) { return y(d.y0 + d.y); })
	    .attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); });
	
	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis);
	
	
	var ytmp = svg.append("g");
	
	ytmp.attr("class", "y axis")
	.attr("transform", "translate(" + 0 + ",0)")
	.call(yAxis);
	
//	svg.append("g")
//    .attr("class", "x axis")
//    .attr("transform", "translate(0," + height + ")")
//    .call(xAxis)
//  .selectAll("text")
//    .attr("y", 0)
//    .attr("x", 9)
//    .attr("dy", ".35em")
//    .attr("transform", "rotate(90)")
//    .style("text-anchor", "start");
	
	
	//d3.selectAll("input[name="+mode+"]").on("change", change);
	//	d3.selectAll("input").on("change", change);

	
	//var timeout = setTimeout(2000);
	
	//var timeout = setTimeout(function() {
	//	  d3.select("input[value=\"grouped\"]").property("checked", true).each(change);
	//	}, 2000);
	//d3.select("input[value=\"grouped\"]").property("checked", true).each(change);
	transitionGrouped(500);
	
	//function change() {
	//alert(this.name);
	  //clearTimeout(timeout);
	 // if (this.value === "grouped") transitionGrouped(500);
	 // else transitionStacked(500);
	//}
	
	function transitionGrouped(time) {
	  //y.domain([0, 8]);
	
	  y = d3.scale.linear()
	    .domain([0, yGroupMax])
	    .range([height, 0]);
	  
	  
	  yAxis = d3.svg.axis()
	  .scale(y)
	  .tickSize(1)
	  .orient("left")
	  .ticks(5);
	  
	  ytmp
		.attr("class", "y axis")
		.attr("transform", "translate(" + 0 + ",0)")
		.call(yAxis);
	  
	  rect.transition()
	      .duration(time)
	      .delay(function(d, i) { return i * 10; })
	      .attr("x", function(d, i, j) { return x(d.x) + x.rangeBand() / num_layers * j; })
	      .attr("width", 
	    		  
	    		  function(d, i, j) { 
	    	  return  x.rangeBand() / num_layers; 
	    	  }
	    		 
	    
	      )
	    .transition()
	      .attr("y", function(d) { return y(d.y); })
	      .attr("height", function(d) { return height - y(d.y); });
	}
	
	function transitionStacked(time, yMax) {
	  //y.domain([0, 20]);
		  y = d3.scale.linear()
		    .domain([0, yMax])
		    .range([height, 0]);
		  
		  yAxis = d3.svg.axis()
		  .scale(y)
		  .tickSize(1)
		  .orient("left")
		  .ticks(5);
		  
		  ytmp
			.attr("class", "y axis")
			.attr("transform", "translate(" + 0 + ",0)")
			.call(yAxis);
		  
	  rect.transition()
	      .duration(time)
	      .delay(function(d, i) { return i * 10; })
	      .attr("y", function(d) { return y(d.y0 + d.y); })
	      .attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); })
	    .transition()
	      .attr("x", function(d) { return x(d.x); })
	      .attr("width", x.rangeBand());
	}
	

	// rotate labe
	//svg.selectAll("text")
    //.attr("transform", function(d) {
    //    return "rotate(90)translate(" + this.getBBox().height/2 + "," +
   //         this.getBBox().width/2 + ")";
    //});
	
	//create the legend for the bar graph
//	 var div_checkbox = 
//		 d3.select(contianLegendID).append("div")
//		  .attr("class", "checkboxLegend");

	  var height_containlegent = (arrs.length-3)*22+150;
	  var svgLegend = 
		  d3.select(contianLegendID)
		  .style("margin", "0px 0px 0px 330px")//-20px 0px 0px 0px
		  .append("svg")
	        .attr("width", 268)
	        .attr("height",height_containlegent);
	        //.attr('transform', 'translate(0,-200)');
	        //.attr('transform', 'translate(0,-200)');  
	
	  
	  svgLegend.on("click", function(){
			var target = d3.event.target.tagName;
			console.log("clickLegend:"+target);
			//if (target == "svg" && lastclicked !="")
			if (target != "text")
			{	
			  d3.select("#"+mode+"switch").style("font-weight","normal");
			  d3.select("#"+mode+"switch").attr("checked",false);
  			  arrLegendChecked_atSummary();// for the nodes in the heatnetwork
  			  
  			  addAllRows();//for the barchart
  			  isUpdateTextPanel = true;
  			  
		  		  if(lastclicked != "")
		  		  {
		  			d3.select("#"+lastclicked).style("stroke-width",0);
				    lastclicked = "";
					optFilters[json_mode[mode]].isClickedTextPanel =  false;
		  		  }
		  		  
		  	 	  if(isUpdateTextPanel && isHeatmapvisible == "true")
			  	  {
				  		if(sumArr(arrLegendChecked) == arrLegendChecked.length)
				  		{ optFilters[json_mode[mode]].isClickedLegendPanel = false;}else{
				  		  optFilters[json_mode[mode]].isClickedLegendPanel = true;
				  		}

					 	console.log("optFilters:"+optFilters[json_mode[mode]].subtypescore);

				    	object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
			  		  
			  	  }

			}
	    });
	        
	var legend = svgLegend.append("g")
	  .attr("class", "legend")
        //.attr("x", w - 65)
        //.attr("y", 50)
	  .attr("height", 100)
	  .attr("width", 100)
	  .attr('transform', 'translate(-150,50)');   
      

//    for(var i =0; i <=arrs.length ;i++)
//    {
//    	  div_checkbox
//          .append("div")
//          .style("padding", "0px")
//          .append("input")
//          .attr("id", function() { 
//		    //var text = lables[i];	   
//        	  if (i != arrs.length)
//        	  {
//        		  return mode+"_"+i+"checkbox";
//        	  }else{
//        		  return mode+"_"+"checkbox_summary";
//        	  }
//	      })
//    	    .attr("checked", false)
//    	    .attr("type", "checkbox")
//    	   // .attr("onClick", "change(this)");
//          	  
//    	.on("click", function(d,i){
//          	//d3.select(this).style("stroke-width":1px);
//       	 console.log(d3.select(this).attr("checked"));
//
//        	  var isChecked = d3.select(this).attr("checked");
//        	  var id = d3.select(this).attr("id");
//        	 
//        	  if ( id != mode+"_"+"checkbox_summary")
//        	  {
//        		  if (isChecked == "false")
//            	  {
//            		  d3.select(this).attr("checked",true);
//            		  
//            		  //d3.select(this).style("opacity", 0.2);
//            		  d3.select("#"+ id.slice(0, -8)+"lable").style("visibility", "hidden");	    
//            	      d3.selectAll('.'+id.slice(0, -8)).style("visibility", "hidden");
//            	  }else{
//            		  d3.select(this).attr("checked",false);
//            		  
//            		  //d3.select(this).style("opacity", 1);
//            		  d3.select("#"+ id.slice(0, -8)+"lable").style("visibility", "visible");	    
//            	      d3.selectAll('.'+id.slice(0, -8)).style("visibility", "visible");
//            	  }
//        	}else{
//        		 if (isChecked == "false")
//	          	  {
//	          		  d3.select(this).attr("checked",true);
//	          		  transitionGrouped();
//
//	          	  }else{
//	          		  d3.select(this).attr("checked",false);
//	          		  
//	          		  transitionStacked();
//
//	          	  }
//	        		
//        	}
//    	   
//      		//console.log("over"+d.id);
//
//          	});
//    	  
//    	 // $checkbox.setAttribute("checked", "checked");
//    }
//	  
//	  $('#'+mode+"_"+"checkbox_summary").attr('checked', false); 

    
	var textWidth = lables[0].length;
	//var legend_x = w +  Math.round(9*textWidth-44);
	var legend_x = w-70;
	console.log("textWidth"+textWidth);
    legend.selectAll('rect')
      .data(arrs)
      .enter()
      .append("rect")
	  //.attr("x", w - 65)
       //.style("padding", "10px")
      .attr("title", function(d,i){return tooltips[i];})
      .attr("x", legend_x)
      .attr("y", function(d, i){ return i *  22 -2;})
	  .attr("width", 11)
	  .attr("height", 11)
	  .attr("checked", true)
	  .attr("id", function(d,i) { 
		    //var text = lables[i];	    
	        return mode+"_"+i+"lable";
	      })
	  .style("fill", function(d,i) { 
        //var  = color_hash[dataset.indexOf(d)][1];
        return arr_allColor[i];
      });
      
    legend.selectAll('text')
      .data(arrs)
      .enter()
      .append("text")
      .attr("class", "legendtext")
      .attr("title", function(d,i){return tooltips[i];})
	  .attr("x", w - 52)
      .attr("y", function(d, i){ return i *  22 + 9;})
      .attr("id", function(d,i) { 
		    //var text = lables[i];	    
	        return mode+"_"+i+"labletxt";
	      })
      
      .attr("checked", false)
      .on("click", function(d,i){
	  	  var isChecked = d3.select(this).attr("checked");
	  	  var isUpdateTextPanel = false;
		  	  if (isChecked == "false") //checkbox
		  	  {
		  		//var numChecked = sumArr(arrLegendChecked); //checkbox
		  		

		  		//if (numChecked >1)//checkbox 
		  		//{
			  		  //arrLegendChecked[i] = 0;
			  		  //d3.select(this).attr("checked",false);  		  
			  		  //d3.select(this).style("opacity", 0.2);
		    		  //d3.select("#"+mode+"_"+i+"lable").style("visibility", "hidden");	    
			  		  //d3.selectAll('.'+mode+"_"+i).style("visibility", "hidden");
			  		  //emptyaRow(i);//update the height of the bars in text panel. This data will be used when brush is empty //checkbox
		  		      d3.select("#"+mode+"switch").style("font-weight","normal");    
		  		      d3.select("#"+mode+"switch").attr('checked', false);   
		  		   
	  	  			  arrLegendChecked_atOneRow(i);
	  	  			  emptyExceptRow(i);//bar length
			  		  isUpdateTextPanel = true;
			  		  
			  		  if(lastclicked != "")
			  		  {
			  			d3.select("#"+lastclicked).style("stroke-width",0);
					    lastclicked = "";
						optFilters[json_mode[mode]].isClickedTextPanel =  false;
			  		  }
				  	  

//			  		  if(lastclicked == "")
//			  		  { deleOneSubtype(i);}
//			  		  isUpdateTextPanel = true;
			  		  
			  		  
		  		}
		  		  
		
//		  	  }else{//checkbox
//		  		  arrLegendChecked[i] = 1;
//		  		  d3.select(this).attr("checked",true);
//		  		  d3.select(this).style("opacity", 1);
//	    		  d3.select("#"+mode+"_"+i+"lable").style("visibility", "visible");	    
//		  		  //d3.selectAll('.'+mode+"_"+i).style("visibility", "visible");
//		  		  //addaRow(i);//update the height of the bars in text panel. This data will be used when brush is empty //checkbox
//		  		  addExcpetRow(i);
//		  		  
//		  		  if(lastclicked == "")
//		  		  {addOneSubtype(i,num_samples); }
//		  		  
//		  		  isUpdateTextPanel = true;
//		  	  }//checkbox
			   
		  	  if(isUpdateTextPanel && isHeatmapvisible == "true")
		  	  {
			  		if(sumArr(arrLegendChecked) == arrLegendChecked.length)
			  		{ optFilters[json_mode[mode]].isClickedLegendPanel = false;}else{
			  		  optFilters[json_mode[mode]].isClickedLegendPanel = true;
			  		}

				 	console.log("optFilters:"+optFilters[json_mode[mode]].subtypescore);

			    	object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
		  		  
		  	  }
				//console.log("over"+d.id);
		
	   })
	  .text(function(d,i) {
        //var text = color_hash[dataset.indexOf(d)][0];
		  var text = lables[i];
        return text;
      });
    
    
    
//    $(function() {
//    	$( document ).tooltip();
//    	});
    
    $(function() {
    	$( document ).tooltip({
    	position: {
    	my: "center bottom-20",
    	at: "center top",
    	using: function( position, feedback ) {
    	$( this ).css( position );
    	$( "<div>" )
    	.addClass( "tooltip_arrow" )
    	.addClass( feedback.vertical )
    	.addClass( feedback.horizontal )
    	.appendTo( this );
    	}
    	}
    	});
    	});
    
//      .attr("checked", true)
//      .on("click", function(d,i){
//    	  var isChecked = d3.select(this).attr("checked");
//    	  if (isChecked == "true")
//    	  {
//    		  d3.select(this).attr("checked",false);
//    		  
//    		  d3.select(this).style("opacity", 0.2);
//    		  d3.select("#"+mode+"_"+i+"lable").style("visibility", "hidden");	    
//    	      d3.selectAll('.'+mode+"_"+i).style("visibility", "hidden");
//    	  }else{
//    		  d3.select(this).attr("checked",true);
//    		  
//    		  d3.select(this).style("opacity", 1);
//    		  d3.select("#"+mode+"_"+i+"lable").style("visibility", "visible");	    
//    	      d3.selectAll('.'+mode+"_"+i).style("visibility", "visible");
//    	  }
//	   
//  		//console.log("over"+d.id);
//
//      	});
      


    legend
    .append("text")
    .attr("class", "legendtext")
	  .attr("x", w - 52)
    .attr("y", function(){ return arrs.length *22 + 9;})
    .attr("checked", false)
    .attr("id",mode+"switch")
    //.attr("opacity",0.2)
    .on("click", function(d,i){
          	//d3.select(this).style("stroke-width":1px);
    	
       	 console.log(d3.select(this).attr("checked"));

        	  var isChecked = d3.select(this).attr("checked");
        	  var id = d3.select(this).attr("id");
        	 
        	  
        		 if (isChecked == "false")
	          	  {
       			      d3.select(this).style("font-weight","bold");
	          		  d3.select(this).attr("checked",true);
        			  arrLegendChecked_atSummary();// for the nodes in the heatnetwork
        			  
        			  addAllRows();//for the barchart
        			  isUpdateTextPanel = true;
        			  
			  		  if(lastclicked != "")
			  		  {
			  			d3.select("#"+lastclicked).style("stroke-width",0);
					    lastclicked = "";
						optFilters[json_mode[mode]].isClickedTextPanel =  false;
			  		  }
			  		  
			  	 	  if(isUpdateTextPanel && isHeatmapvisible == "true")
				  	  {
					  		if(sumArr(arrLegendChecked) == arrLegendChecked.length)
					  		{ optFilters[json_mode[mode]].isClickedLegendPanel = false;}else{
					  		  optFilters[json_mode[mode]].isClickedLegendPanel = true;
					  		}

						 	console.log("optFilters:"+optFilters[json_mode[mode]].subtypescore);

					    	object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
				  		  
				  	  }
			  		  
	          		  //d3.select(this).style("opacity", 1);
	          		  //transitionStacked(500, yStackMax);

	          	  }
        		 //else{
        			  //d3.select(this).style("opacity", 0.2);
	          	//	  d3.select(this).attr("checked",false); 
	          	//	  transitionGrouped(500);
	            // }
	        		
        
    	   
      		//console.log("over"+d.id);

          	})
	  .text(function(d,i) {
		  var text = "summary";
      return text;
    });
    
    
    function convertTextPanelIDtoOptFiltersID(id)
    {
		
		var idArryTmp = (id.slice(5)).split("_");//goal_0_3
		var idTmp = json_mode[mode]+idArryTmp[1]+"_"+idArryTmp[2];//goal0_3
		return idTmp;
    }
    
    function addOneSubtype(i,num_samples){
	  	  for(var n =  0; n <num_samples; n++){ 
				 var idTmp = json_mode[mode]+i+"_"+n;
				 //var arrTmp = optFilters[json_mode[mode]].subtypescore;
				 // if( $.inArray(idTmp, arrTmp) == -1)

				 if(optFilters[json_mode[mode]].subtypescore.indexOf(idTmp) == -1)
					 {
						optFilters[json_mode[mode]].subtypescore.push(idTmp);
					 }
	       }
    }

    function deleOneSubtype(i){
    	var cut = (json_mode[mode]).length;
	  	  for(var n =  optFilters[json_mode[mode]].subtypescore.length-1; n >= 0; n--){ 
				 var strTmp = ( optFilters[json_mode[mode]].subtypescore[n]).slice(cut);
				 var strArr=strTmp.split("_");
	      	     if(strArr[0] == i){      	    	
	      	    	optFilters[json_mode[mode]].subtypescore.splice(n,1);                 
	      	    }
	       }
    }
    
    function emptyaRow(i){
		
		for ( var r = 0; r < arrBarHeightForLegendChecked.length; r++) {
			for ( var c = 0; c < arrBarHeightForLegendChecked[r].length; c++) {
				if(r == i )
				{	arrBarHeightForLegendChecked[r][c] = 0;}
				
			}
		}
	}
    
    function addaRow(i){
		
		for ( var r = 0; r < arrBarHeightForLegendChecked.length; r++) {
			for ( var c = 0; c < arrBarHeightForLegendChecked[r].length; c++) {
				if(r == i )
				{	arrBarHeightForLegendChecked[r][c] = arrOrg[r][c];}
				
			}
		}
	}
    
function emptyExceptRow(i){
		
		for ( var r = 0; r < arrBarHeightForLegendChecked.length; r++) {
			for ( var c = 0; c < arrBarHeightForLegendChecked[r].length; c++) {
				if(r == i )
				{	arrBarHeightForLegendChecked[r][c] = arrOrg[r][c];}
				else{
					arrBarHeightForLegendChecked[r][c] = 0;
				}
				
			}
		}
	}
    
    function addExcpetRow(i){
		
		for ( var r = 0; r < arrBarHeightForLegendChecked.length; r++) {
			for ( var c = 0; c < arrBarHeightForLegendChecked[r].length; c++) {
				if(r == i )
				{	arrBarHeightForLegendChecked[r][c] = 0;}
				else{
					arrBarHeightForLegendChecked[r][c] = arrOrg[r][c];
				}
				
			}
		}
	}
    
   function addAllRows(){//Reset the barchart.
		
		for ( var r = 0; r < arrBarHeightForLegendChecked.length; r++) {
			for ( var c = 0; c < arrBarHeightForLegendChecked[r].length; c++) {
					arrBarHeightForLegendChecked[r][c] = arrOrg[r][c];
				
			}
		}
	}
    
    function sumArr(arrLegendChecked){
    	var num = 0;
  		$.each(arrLegendChecked,function() {
  			num += this;
  		});
  		
  		return num;
    }
    
    function arrLegendChecked_atOneRow(i){
    	for (var j = 0; j < arrLegendChecked.length; j++) {
			if (i == j) {
				arrLegendChecked[j] = 1;
				d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","bold");
				d3.select("#"+mode+"_"+j+"labletxt").attr("checked",true);
				
				addOneSubtype(j,num_samples);
			}else{
				arrLegendChecked[j] = 0;
				d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","normal");
				d3.select("#"+mode+"_"+j+"labletxt").attr("checked",false);
				 //if(lastclicked == "") // check box. This line keep clicking bars higher priority than clicking legends.
		  		 // { 
				//	 console.log("123422222222222222222222:")
					 deleOneSubtype(j);
		  		  
		  		//  }
			}
	    }
    }
    
    function arrLegendChecked_atSummary(){
    	for (var j = 0; j < arrLegendChecked.length; j++) {	
				arrLegendChecked[j] = 1;
				d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","normal");
				d3.select("#"+mode+"_"+j+"labletxt").attr("checked",false);		
				addOneSubtype(j,num_samples);
		
	    }
    }
    function isCheckedLegend(){
    	for (var j = 0; j < arrLegendChecked.length; j++) {
			if (d3.select("#"+mode+"_"+j+"labletxt").attr("checked") == "true") {
				return true;
			}
	    }
    	return false;
    }	      
	
return self;
  };
  
})(d3);

