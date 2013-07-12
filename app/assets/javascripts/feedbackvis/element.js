(function(d3) {
  window.elements = function(tableID,contianLegendID, jsonArray, cords, img_width, img_height) {
	 
    var self = {};
    var jsonArr_labelsNkeys = [];
    for (var i =0; i <= count(json_allColor.ele); i++)
    {
        for (var key in json_allColor.ele) {
  		  if (json_allColor.ele[key] == i && json_allColor.ele.hasOwnProperty(key)) 
  		  {jsonArr_labelsNkeys.push({"lable":key,"key":key}); }
  		}	
    }
	var lastclicked = "";
    var mode = "ele";
    var optFilters_subtypetxt_bak;
    
    var jsonArray_ForLegendChecked = [];
    jsonArray_ForLegendChecked = JSON.parse((JSON.stringify(jsonArray)).slice(0));
    
    var isSortbyType = "true";
    var y_bar = 7;
    var y_votetext = 19;


    Array.prototype.repeat= function(what, L){
   	 while(L) this[--L]= what;
   	 return this;}
    var arrLegendChecked = [].repeat(1, jsonArr_labelsNkeys.length);
    for (var j = 0; j < arrLegendChecked.length; j++) {
    	if(arrLegendChecked[j] == 1)
    		{//add one subtype
    			addOneSubtype(j,jsonArray);
    		}
    }

    //If click outside of the table, reset.
    d3.select(".elementvis")
    .on("click", function(){
	var target = d3.event.target.tagName;
	console.log(target);
	if ((target == "DIV" || target == "TD" || target == "TH" || target == "svg") && lastclicked !="")
	{	
			resetTable();
	}
    });    
    var max = 5;
	var color = d3.scale.category10();


//    d3.selectAll("thead td").data(columns).on("click", function(k) {
//  	  if(k == 'type')
//  	  {
//  	    tr.sort(function(a, b) { 
//  	    	if( b['typevote'] != a['typevote'])
//  	    	{return -1*(b['typevote'] - a['typevote']);}//{return b['typevote'] - a['typevote'];}
//  	    	else{
//  	    	 return b['allvote'] - a['allvote'];	
//  	    	}
//  	    });
//  	  }else{
//  	    tr.sort(function(a, b) { return b['allvote'] - a['allvote']; });//return (b[k] / max) - (a[k] /max)
//  	  }
//    });
    


  	$('<div id="radios" class = "row-fluid textintextpanle">\
  	    <label class = "span4">sort by</label>\
  	    <label class = "span4"><input type="radio" name="radio-sort-ele" value = "true" checked="checked" style = "margin-top:0px; margin-left:-5px" /><span style = "padding-left:5px">type<span></label>\
  	    <label class = "span4"><input type="radio" name="radio-sort-ele" value = "false"  style = "margin-top:0px; margin-left:-10px"><span style = "padding-left:5px">vote</span></label>\
  	  </div>')
	.appendTo(contianLegendID);
  	
  	//$('<input type="radio" name="radio-sort-ele"  value = "false" checked="checked" /> <label>type</label> ').appendTo(contianLegendID);
	//$('<input type="radio" name="radio-sort-ele" value = "true" /><label>vote</label>').appendTo(contianLegendID);
	  
  	$('input[name=radio-sort-ele]:radio', '#radios').click(function () {   
  		isSortbyType =  $('input[name=radio-sort-ele]:checked', '#radios').val(); 
  		sortTable(isSortbyType);
		});
		 
    
    
//----------------------legend begin---------------------------------
    var height_containlegent = (jsonArr_labelsNkeys.length-3)*22+120;
    //var height_containlegent = (jsonArr_labelsNkeys.length-3)*22+66;
    //color(json_allColor.ele[d.type]
    //    var height_containlegent = (arrs.length-3)*22+100;

	  var svgLegend = 
		  d3.select(contianLegendID).append("svg")
		    .style("margin-top", "-10px")
	        .attr("width", 180)
	        .attr("height",height_containlegent);
	  		 //.attr("width", 150)
	         //.attr('transform', 'translate(200,200)')    
	        
	        
	var legend = svgLegend.append("g")
	  .attr("class", "legend")
      //.attr("x", w - 65)
      //.attr("y", 50)
	  .attr("height", 100)
	  .attr("width", 100)
   .attr('transform', 'translate(-160,10)');   
    
    svgLegend.on("click", function(){
			var target = d3.event.target.tagName;
			console.log("clickLegend:"+target);
			//if (target == "svg" && lastclicked !="")
			if (target != "text")
			{	
				resetLegend();
	
			}
	 });

	var textWidth = 200;
    var w = 240; //legend width

	//var textWidth = lables[0].length;
	//var legend_x = w +  Math.round(9*textWidth-44);
	var legend_x = w-70;
	//var legend_x = 0;
	console.log("textWidth"+textWidth);
  legend.selectAll('rect')
    .data(jsonArr_labelsNkeys)
    .enter()
    .append("rect")
	  //.attr("x", w - 65)
     //.style("padding", "10px")
    //.attr("title", function(d,i){return tooltips[i];})
    .attr("x", legend_x)
    .attr("y", function(d, i){ return i *  22 -2;})
	  .attr("width", 11)
	  .attr("height", 11)
	  .attr("checked", false)
	  .attr("id", function(d,i) { 
		    //var text = lables[i];	    
	        return mode+"_"+i+"lable";
	      })
	  .style("fill", function(d,i) { 
      //var  = color_hash[dataset.indexOf(d)][1];
      //return color(i);
		  return arr_allColor[i];  
    });
    
  legend.selectAll('text')
    .data(jsonArr_labelsNkeys)
    .enter()
    .append("text")
    .attr("class", "legendtext")
    //.attr("title", function(d,i){return tooltips[i];})
	  .attr("x", w - 52)
    .attr("y", function(d, i){ return i *  22 + 9;})
    
    .attr("checked", false)
    .attr("id", function(d,i) { 
		    //var text = lables[i];	    
	        return mode+"_"+i+"labletxt";
	      })
    .on("click", function(d,i){
	  	  var isChecked = d3.select(this).attr("checked");
	  	  var isUpdateTextPanel = false;
		  	  if (isChecked == "false")
		  	  {
		  		//var numChecked = sumArr(arrLegendChecked);

		  		
				console.log("arrLegendChecked:"+arrLegendChecked);


		  		//if (numChecked >1)
		  		//{
		  			  arrLegendChecked_atOneRow(i);
//		  			  arrLegendChecked[i] = 0;
//			  		  d3.select(this).attr("checked",false);  		  
//			  		  d3.select(this).style("opacity", 0.2);
//		    		  d3.select("#"+mode+"_"+i+"lable").style("visibility", "hidden");	    
//			  		  d3.selectAll('.'+mode+"_"+i).style("visibility", "hidden");
			  		  //emptyaRow(i);//update the data in text panel. This data will be used when brush is empty
			  		  addaRow(i); //bar chart
			  		  emptyExceptRow(i);
			  		  
			  		  if(lastclicked != "")
			  		  {
			  			d3.select("#"+lastclicked).style("stroke-width",0);
						lastclicked = "";
						optFilters[mode].isClickedTextPanel =  false;
			  		  }
			  		  isUpdateTextPanel = true;
			  		  

		  		//}
		  		  
		
		  	  }
		  	  else{
		  	  	resetLegend();
		  	  }
//		  	  else{
//		  		  arrLegendChecked[i] = 1;
//		  		  d3.select(this).attr("checked",true);
//		  		  d3.select(this).style("opacity", 1);
//	    		  d3.select("#"+mode+"_"+i+"lable").style("visibility", "visible");	    
//		  		  d3.selectAll('.'+mode+"_"+i).style("visibility", "visible");
//		  		  addaRow(i);//update the data in text panel. This data will be used when brush is empty
//		  		  
//		  		  if(lastclicked == "")
//		  		  {	  addOneSubtype(i,jsonArray);}
//		  		  
//		  		  isUpdateTextPanel = true;
//		  	  }
			   
		  	  if(isUpdateTextPanel && isHeatmapvisible == "true")
		  	  {
			  		if(sumArr(arrLegendChecked) == arrLegendChecked.length)
			  		{ optFilters[mode].isClickedLegendPanel = false;}else{
			  		  optFilters[mode].isClickedLegendPanel = true;
			  		}

				 	console.log("optFilters:"+optFilters[mode].subtypetxt);

			    	object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
		  		  
		  	  }
				//console.log("over"+d.id);
		
	   })
	  .text(function(d,i) {
      return jsonArr_labelsNkeys[i].lable;
    });
  



  
  self.update = function(jsonArrayTmp) {
	//console.log(jsonArray);

	$(tableID).empty();
	
	 tr = d3.select(tableID).selectAll("tr")
	.data(jsonArrayTmp)
	.enter().append("tr")
	.attr("class", function(d) { return mode+"_"+d.typevote; });

	// tr.append("th")
	//	.text(function(d) { return d.element; })
	tr.append("th")
    .append("text")
	.text(function(d) { return d.element; })
	.attr("id", function(d){
		return d.id;
		
	})
	.on("mouseover", function(d){
	   	//object_heatnetwork.hide();
		//d3.select(this).style("font-weight","bold");
		//$('#heatmapID').remove();
		//var currentheatmap = heatmap("#overlay", img_width, img_height, cords[this.id]);	
	})
	.on("mouseout", function(d){
		//d3.select(this).style("font-weight","normal");
		//$('#heatmapID').remove();
	   	//object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
	})
	;

	var td_svg= tr.append("td")
	.append("svg")
	.attr("width", 271)
	//.attr("width", function(d) { 
	//return ( d.allvote/max) * 71; })
	.attr("height", 22);
	
	td_svg.append("rect")
	.style("fill", function(d) {
	//return color(d.content.score);
	//return "black";
	//return color(json_allColor.ele[d.type]);
	return assignColor(d.type);

	})
	.attr("y", y_bar)
	 .attr("x", 1)
	.attr("height", 12)
	.attr("width", function(d) { 
		return ( d.allvote/max) * 71; })
	.attr("id", function(d){
		return d.type+"__"+d.element+"__"+d.id;	
	})
	.style("stroke","black")
	.style("stroke-width",function(d){
		if((d.type+"__"+d.element+"__"+d.id) == lastclicked )
		{return 2;}else{return 0;}
		
	})
	.on("mouseover", function(d){
		if (this.id != lastclicked)
		{
			d3.select(this).style("stroke","black");
			d3.select(this).style("stroke-width",1);
			d3.select("#votetext"+this.id).attr("display", "inline");
		}
		//mode_goal_0_3

	    //optFilters_subtypetxt_bak = (optFilters.ele.subtypetxt).slice(0);//copy the arry

		//optFilters.ele.subtypetxt = [];
		//optFilters.ele.subtypetxt.push(convertTextPanelIDtoOptFiltersID(this.id));
		//if(lastclicked !="")
		//	{optFilters.ele.subtypetxt.push(convertTextPanelIDtoOptFiltersID(lastclicked));}
				
		
		if ( isHeatmapvisible == "true")
	       {
		    	 //object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
	    	}else
	        {
				$('#heatmapID').remove();
				var currentheatmap = heatmap("#overlay", img_width, img_height, cords[(this.id.split("__"))[2]]);		
	    	}
    	})
    .on("mouseout", function(d){
    	if (this.id != lastclicked)
		{
			d3.select(this).style("stroke-width",0);			
			d3.select("#votetext"+this.id).attr("display", "none");

		}
		//optFilters.ele.subtypetxt = [];
		//optFilters.ele.subtypetxt = optFilters_subtypetxt_bak.slice(0);

    	
    	//if ( isHeatmapvisible == "true")
    	// {
	    //	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
    	// }else
    	//{
 		//	$('#heatmapID').remove();
    	//}
    	})
    	
    .on("click", function(d){
    	if (this.id != lastclicked)
    	{
        	var isCtrl = d3.event.ctrlKey;

    		if(isCtrl) {
    			console.log("ctrl+left click");
    		}
    		
    		if(lastclicked !="")
			{

    			
				console.log("last clicked: "+lastclicked);
				d3.select('#'+lastclicked).style("stroke-width",0);
				d3.select("#votetext"+lastclicked).attr("display","none");

				
				//console.log("filterbefore:"+optFilters.imp.subtype);
				
				for(var i =  optFilters.ele.subtypetxt.length-1; i >= 0; i--){  
            	    if( optFilters.ele.subtypetxt[i] ==  convertTextPanelIDtoOptFiltersID(lastclicked)){      
            	    	
            	    	 optFilters.ele.subtypetxt.splice(i,1);                 
            	    }
            	}
				
			}
		    optFilters_subtypetxt_bak = (optFilters.ele.subtypetxt).slice(0);//copy the arry
		    
			optFilters.ele.subtypetxt = [];
			optFilters.ele.subtypetxt.push(convertTextPanelIDtoOptFiltersID(this.id));

			lastclicked = this.id;
			optFilters.ele.isClickedTextPanel =  true;
			
        	d3.select(this).style("stroke","black");
    		d3.select(this).style("stroke-width",2);
			d3.select("#votetext"+this.id).style("display", "inline");

    		
    		if ( isHeatmapvisible == "true")
	    	 {
		    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
	    	 }else{ 
	    		 
	    	 }
    	}else{
    		resetTable();
    	}
    	
		 	
    	});
	
    	td_svg
    	.append("text")
    	.text(function(d) { return d.allvote; })
    	.attr("x", function(d) { 
    		return ( d.allvote/max) * 71 + 5; })
    	//.attr("x", 100)
    	.attr("y", y_votetext)
    	.attr("class", "textintextpanle")
    	.attr("id", function(d){
    		return "votetext"+d.type+"__"+d.element+"__"+d.id;		
		})
		.attr("display", "none")
		
		.attr("display",function(d){
		if((d.type+"__"+d.element+"__"+d.id) == lastclicked )
		{return "inline";}else{return "none";}
		
		})
		;
    
	//tr.append("td")
	//.text(function(d) { return d.type; });

	//tr.sort(function(a, b) { return (b['Under 5 Years'] / b.Total) - (a['Under 5 Years'] / a.Total); });
	sortTable(isSortbyType); 

	  	
	  }
  
  self.update(jsonArray);
  
  self.getLegendCheckedData = function(){return jsonArray_ForLegendChecked;}

  function sortTable(isSortbyType)
  {
		if(isSortbyType == "true")
		 {
		  	    tr.sort(function(a, b) { 
		  	    	if( b['typevote'] != a['typevote'])
		  	    	{return -1*(b['typevote'] - a['typevote']);}//{return b['typevote'] - a['typevote'];}
		  	    	else{
		  	    	 return b['allvote'] - a['allvote'];	
		  	    	}
		  	    });
		  }else{
		  	    tr.sort(function(a, b) { return b['allvote'] - a['allvote']; ; });
		  }	
  }
  function count(obj) {
	  var i = 0;
	  for (var x in obj)
	    if (obj.hasOwnProperty(x))
	      i++;
	  return i;
	}
  
  function convertTextPanelIDtoOptFiltersID(id)
  {
		
		var idArryTmp = id.split("__");//object__smoothie__493_1
		var idTmp = idArryTmp[0]+"_"+idArryTmp[1];//object_smoothie
		return idTmp;
  }
  
  //update optFilters. add one subtype from the filter. i is also the typevote in the data. 
  function addOneSubtype(i,jsonArrayTmp){
  	  for(var n =  0; n <jsonArrayTmp.length; n++){
  		  if(jsonArrayTmp[n].typevote == i)
  		  {
  			var idTmp = jsonArrayTmp[n].type+"_"+jsonArrayTmp[n].element;//idTmp = object_sun,

			 if(optFilters[mode].subtypetxt.indexOf(idTmp) == -1)
				 {
					optFilters[mode].subtypetxt.push(idTmp);
				 } 
  		  }
			 
       }
}
  //update optFilters. remove one subtype from the filter. i is also the typevote in the data. 
  function deleOneSubtype(i){
	  console.log("optFilters[mode].subtypetxt before:"+optFilters[mode].subtypetxt);
	  	  for(var n =  optFilters[mode].subtypetxt.length-1; n >= 0; n--){ 
				 var strArr = optFilters[mode].subtypetxt[n].split("_");
	      	     if(strArr[0] == jsonArr_labelsNkeys[i].key){      	    	
	      	    	optFilters[mode].subtypetxt.splice(n,1);                 
	      	    }
	       }
		  console.log("optFilters[mode].subtypetxt after:"+optFilters[mode].subtypetxt);

  }
  //update the data for right text panel. i is also the typevote in the data. 
  function emptyaRow(i){		
		for ( var r = jsonArray_ForLegendChecked.length-1; r>=0; r--) 
		{
				//if(jsonArray_ForLegendChecked[r].type == jsonArr_labelsNkeys[i].key)	
				if(jsonArray_ForLegendChecked[r].typevote == i)
				{	jsonArray_ForLegendChecked.splice(r,1);}
		}
	}
  
  function emptyExceptRow(i){
		
		for ( var r = jsonArray_ForLegendChecked.length-1; r>=0; r--) 
		{
				//if(jsonArray_ForLegendChecked[r].type == jsonArr_labelsNkeys[i].key)	
				if(jsonArray_ForLegendChecked[r].typevote != i)
				{	jsonArray_ForLegendChecked.splice(r,1);}
		}
	}
  
  function arrLegendChecked_atSummary(){
  	for (var j = 0; j < arrLegendChecked.length; j++) {	
  		arrLegendChecked[j] = 1;
		d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","normal");   
  		d3.select("#"+mode+"_"+j+"labletxt").attr("checked",false); 
		
  		addOneSubtype(j,jsonArray);
		
	    }
  }
  
  function arrLegendChecked_atOneRow(i){
	  
	  for (var j = 0; j < arrLegendChecked.length; j++) {
		  	if(j == i)
		  	{
		  		arrLegendChecked[j] = 1;
	    		d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","bold");   
		  		d3.select("#"+mode+"_"+j+"labletxt").attr("checked",true); 
	    		
		  		//d3.selectAll('.'+mode+"_"+i).style("visibility", "visible");
		  		
		  		addOneSubtype(j,jsonArray);
		    }else{
		    	arrLegendChecked[j] = 0;
	    		d3.select("#"+mode+"_"+j+"labletxt").style("font-weight","normal");	    
		    	d3.select("#"+mode+"_"+j+"labletxt").attr("checked",false);  		  
		  		//d3.selectAll('.'+mode+"_"+j).style("visibility", "hidden");
	    		
	    		deleOneSubtype(j);
		    }
		  }
  }
  
  //update the data for right text panel. i is also the typevote in the data. 
  function addaRow(i){
		
		for ( var r = 0; r < jsonArray.length; r++) {
				if(jsonArray[r].typevote == i )
				{	
					var isContain = false;
					for (var n = 0; n<jsonArray_ForLegendChecked.length; n++)
					{ 
						if ( jsonArray_ForLegendChecked[n].id == jsonArray[r].id )
							{isContain = true;}
					}
					
					if(!isContain)
					{jsonArray_ForLegendChecked.push(JSON.parse((JSON.stringify(jsonArray[r])).slice(0)));}

				}
				

		}
	}
  
  function addAllRows(){//Reset the barchart.
		
	  for ( var r = 0; r < jsonArray.length; r++) {
			
				var isContain = false;
				for (var n = 0; n<jsonArray_ForLegendChecked.length; n++)
				{ 
					if ( jsonArray_ForLegendChecked[n].id == jsonArray[r].id )
						{isContain = true;}
				}
				
				if(!isContain)
				{jsonArray_ForLegendChecked.push(JSON.parse((JSON.stringify(jsonArray[r])).slice(0)));}


	     }
	}
  
  function sumArr(arrLegendChecked){
  	var num = 0;
		$.each(arrLegendChecked,function() {
			num += this;
		});
		
		return num;
  }
  

function resetTable() {
	optFilters[mode].subtypetxt = [];
	console.log("arrLegendChecked:" + arrLegendChecked);
	for (var j = 0; j < arrLegendChecked.length; j++) {
		if (arrLegendChecked[j] == 1) {//add one subtype
			addOneSubtype(j, jsonArray);
		}
	}

	d3.select("#" + lastclicked).style("stroke-width", 0);
	lastclicked = "";
	optFilters[mode].isClickedTextPanel = false;
	if (isHeatmapvisible == "true") {
		object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab], true);
	}

}

  

function resetLegend() {
	arrLegendChecked_atSummary();
	// for the nodes in the heatnetwork

	addAllRows();
	//for the barchart
	isUpdateTextPanel = true;

	if (lastclicked != "") {
		d3.select("#" + lastclicked).style("stroke-width", 0);
		lastclicked = "";
		optFilters[mode].isClickedTextPanel = false;
	}

	if (isUpdateTextPanel && isHeatmapvisible == "true") {
		if (sumArr(arrLegendChecked) == arrLegendChecked.length) {
			optFilters[mode].isClickedLegendPanel = false;
		} else {
			optFilters[mode].isClickedLegendPanel = true;
		}

		console.log("optFilters:" + optFilters[mode].subtypetxt);

		object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab], true);

	}
}

	
return self;
  };
  
})(d3);

