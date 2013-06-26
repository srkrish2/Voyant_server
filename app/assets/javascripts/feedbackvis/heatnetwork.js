(function(d3) {
	window.heatnetwork = function(svg, width, height, displyType, graph, optfilters,hash_ImpContent_IDinCloud) {
		

		var self = {};
		var hash_subtype = new Hashtable();

		var opt = optfilters;
		
		//var displyType = "guide";
		
		//graph.range.guide[0] = 0;
		//graph.range.guide[1] = 6;
		
		//graph.range.goal[0] = 0;
		//graph.range.goal[1] = 6;
		
		//swith the color coding scheme
//		var tmp_score = graph.range.imp[0];
//		graph.range.imp[0] = graph.range.imp[1];
//		graph.range.imp[1] = tmp_score;
//		
//		tmp_score = graph.range.ele[0];
//		graph.range.ele[0] = graph.range.ele[1];
//		graph.range.ele[1] = tmp_score;
		
		
		var x0 = null, y0 = null, x1 = null, y1 = null;

		var max_size = Math.max.apply(Math,graph.nodes.map(function(o){return o.size;}));
		var min_size = Math.min.apply(Math,graph.nodes.map(function(o){return o.size;}));
		
		
		var max_score =  graph.range[displyType][1];
		var min_score =	graph.range[displyType][0];
		
		console.log("max_score"+max_score);
		console.log("min_score"+min_score);
		
		
		

		
		//var max_score = Math.max.apply(Math,graph.nodes.map(function(o){return o.content.score;}));
		//var min_score = Math.min.apply(Math,graph.nodes.map(function(o){return o.content.score;}));


		//var max_score = 11;
		//var max_size = 120000;
	    //var color =d3.scale.linear().domain([min_score,max_score]).range(["red","green"]);
		var color = d3.scale.category10();
		updateSubtypes(graph);
		
//	    var color = d3.scale
//        .pow()
//        .exponent(.5)
//        .domain([ [min_score] , 5  , [max_score]  ])
//        .range(['red','green','blue']);
	    
	    //var size =d3.scale.linear().domain([min_size,max_size]).range([4,10]);
	    var size =d3.scale.linear().domain([min_score,max_score]).range([4,10]);

	    
		var node = svg.append("g")
				//.attr("id", "test")
				.attr("class", "node")
				.selectAll("circle").data(graph.nodes).enter().append("circle")
				//.style("fill", function(d) {
					//return color(d.content.score);
					//return color(hash_subtype.get(d.content.subtype));
					//return "black";
					//})
				//.attr("r",  function(d) {
					//return size(d.size);
					//return size(d.content.score);
					//})
					
				.attr("cx", function(d) {
					return d.x;})
				.attr("cy", function(d) {
					return d.y;})
				.attr("class", function(d) {
					return d.type;})
				.attr("subtype", function(d) {
				return d.content.subtype;})
				.attr("score", function(d) {
				return d.score;})
				.attr("txt", function(d) {
					if(d.type == "ele"){return  d.content.txt;}
					else{return "";}
				})
				;
		
		//var x = d3.scale.linear().range([0, width]);
		var x = d3.scale.identity().domain([ 0, width ])

		//var y = d3.scale.linear().range([height, 0]);
		var y = d3.scale.identity().domain([ 0, height ]);

		var brush = d3.svg.brush().x(x).y(y).on("brush", brushCb);

		var g_brush = svg.append("g").attr("class", "brush").call(brush);

		
		g_brush
        .on("mousedown", function(){
        	mouseUpDown = mouseUpDown - 1;
        	console.log("isBrushdown:"+mouseUpDown);
        	});
        
		self.isBrushEmpty = function() {return brush.empty();}
		self.getBrushCord = function() {return brush.empty();}

		
		self.showOneTypeNodes = function(type,isExplainVisible) {
			
			displyType = type;
			updateSubtypes(graph);
			
			g_brush.attr("display", "inline");
			d3.select('.extent').attr("display", "inline");
			
			node.attr("display", "none");
			
		    //color =d3.scale.linear().domain([graph.range[displyType][0],graph.range[displyType][1]]).range(["red","green"]);
		    //color =d3.scale.linear().domain([graph.range[displyType][0],graph.range[displyType][1]]).range(["#F5362E","#A4D291"]);
		    size =d3.scale.linear().domain([graph.range[displyType][0],graph.range[displyType][1]]).range([4,10]);

//		    color = d3.scale
//	        .pow()
//	        .exponent(.5)
//	        .domain([ [graph.range[displyType][0]],5, [graph.range[displyType][1]]  ])
//	        .range(['red','green','blue']);

		    
			//d3.selectAll("[circle[subtype='goal1'],circle[subtype='goal0']")
			
		    d3.selectAll('.'+displyType)
			.filter(function(d){
			    return isNodeinTextPanelFilter(d,displyType, opt);

				})
			.attr("display", "inline")
			 .attr("r",  function(d) {
					//return size(d.size);
				 if(displyType == "goal" || displyType == "guide")
			     {
					 return size(d.content.score);
					 if(d.content.score<4)
					 {return size(2);
				     }else{return size(4);}
			     }
				 else{
					 return size(d.content.score);
				 }
					})
			.style("fill", function(d) {
				if (displyType == "imp")
				{	return "#F6B149";//anbang to make the fig
					//return "#98df8a";
					//assignColorImp(d.content.score);
				
				}
				else{return assignColor(d.content.subtype);}
			
				});
			
		    if(isExplainVisible)
		    {showExplainsandTextPanel(graph, width, height );}
			//if(	d3.event.target == null)
			//{brushCb();}

		}

		self.hide = function() {
//			d3.select('.extent').attr("visibility", "hidden");
//			node.attr("visibility", "hidden");
			d3.select('.extent').attr("display", "none");
			node.attr("display", "none");
			g_brush.attr("display", "none");
		}

		self.show = function() {

//			d3.select('.extent').attr("visibility", "visible");
//			node.attr("visibility", "visible");
			d3.select('.extent').attr("display", "inline");
			//node.attr("display", "inline");
			d3.selectAll('.'+displyType).attr("display", "inline");
			g_brush.attr("display", "inline");

		}
		
		
		function brushCb() {
			//var t = 0;
			

			//if (brush.empty()) {
			//    t = 0;
			//} else {
			//var extent = brush.extent();
			var extent = d3.event.target.extent();

			x0 = extent[0][0], y0 = extent[0][1], x1 = extent[1][0], y1 = extent[1][1];

			node.classed("selected", function(d, i) {
				return (x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1)
			});
			
			//remove brush if it is out of bundary
			if(extent[1][0] >= width || extent[1][1] >= height)
			{
				//d3.select(".brush").call(brush.clear());
				//node.classed("selected", false);
				//console.log("brush.clear()");

			}
			

			showExplainsandTextPanel(graph, width, height );

			//}
			 // console.log(displyType);


		}
		
		
		function isNodeinBothFilters(d,type, opt)
		{
				switch (type)
				{
				case "ele":
						if (d.type != type)
						{return false;}
						//console.log("brush.empty():"+brush.empty());
						//console.log("opt.ele.isClickedTextPanel:"+opt.ele.isClickedTextPanel);
						//console.log("opt.ele.isClickedLegendPanel:"+opt.ele.isClickedLegendPanel);
						//console.log("opt.ele.subtypetxt:"+opt.ele.subtypetxt);

						if(brush.empty() && (opt.ele.isClickedTextPanel )){
							//if(opt.ele.subtype)
							for(var i=0; i< opt.ele.subtypetxt.length; i++) {
							if(  (d.content.subtype +'_'+d.content.txt) == opt.ele.subtypetxt[i] )
									  {return true;}
							}
							return false;
						}else if (!brush.empty() &&  (opt.ele.isClickedTextPanel || opt.ele.isClickedLegendPanel)){
							for(var i=0; i< opt.ele.subtypetxt.length; i++) {
								  if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1 && (d.content.subtype +'_'+d.content.txt) == opt.ele.subtypetxt[i] )
									  {return true;}
							}
							return false;
						}else if (!brush.empty() &&  !(opt.ele.isClickedTextPanel && opt.ele.isClickedLegendPanel)){
						    if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1)
						    {return true;}else{return false;}
						
						}
				  break;
				case "imp":
						if (d.type != type)
						{return false;}
						
						if(brush.empty() && opt.imp.subtype.length != 0){
							for(var i=0; i< opt.imp.subtype.length; i++) {
							if( d.content.subtype == opt.imp.subtype[i] )
									  {return true;}
							}
							return false;
						}else if (!brush.empty() && opt.imp.subtype.length != 0){
							for(var i=0; i< opt.imp.subtype.length; i++) {
								  if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1 && d.content.subtype == opt.imp.subtype[i] )
									  {return true;}
							}
							return false;
						}else if (!brush.empty() && opt.imp.subtype.length == 0){
							 if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1)
							  {return true;}else{return false;}
						}
							
						else{
							return false;
						}				
								  
				break;
				case "goal"://"goal":{"subtype":["goal0","goal1"],"subtypescore":["goal0_0","goal0_6"]},

					if (d.type != type)
					{return false;}
					//console.log("brush.empty():"+brush.empty());
					//console.log("opt.goal.isClickedTextPanel:"+opt.goal.isClickedTextPanel);
					//console.log("opt.goal.isClickedLegendPanel:"+opt.goal.isClickedLegendPanel);
					//console.log("opt.goal.subtypescore:"+opt.goal.subtypescore);

					if(brush.empty() && (opt.goal.isClickedTextPanel )){
						//if(opt.goal.subtype)
						for(var i=0; i< opt.goal.subtypescore.length; i++) {
						if(  (d.content.subtype +'_'+d.content.score) == opt.goal.subtypescore[i] )
								  {return true;}
						}
						return false;
					}else if (!brush.empty() &&  (opt.goal.isClickedTextPanel || opt.goal.isClickedLegendPanel)){
						for(var i=0; i< opt.goal.subtypescore.length; i++) {
							  if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1 && (d.content.subtype +'_'+d.content.score) == opt.goal.subtypescore[i] )
								  {return true;}
						}
						return false;
					}else if (!brush.empty() &&  !(opt.goal.isClickedTextPanel && opt.goal.isClickedLegendPanel)){
					    if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1)
					    {return true;}else{return false;}
					
					}
						
					else{//brush.empty() && opt.goal.subtype.length == 0
					
						return false;
					}	break;
				case "guide":
					if (d.type != type)
					{return false;}
					//console.log("brush.empty():"+brush.empty());
					//console.log("opt.guide.isClickedTextPanel:"+opt.guide.isClickedTextPanel);
					//console.log("opt.guide.isClickedLegendPanel:"+opt.guide.isClickedLegendPanel);
					//console.log("opt.guide.subtypescore:"+opt.guide.subtypescore);

					if(brush.empty() && (opt.guide.isClickedTextPanel )){
						//if(opt.guide.subtype)
						for(var i=0; i< opt.guide.subtypescore.length; i++) {
						if(  (d.content.subtype +'_'+d.content.score) == opt.guide.subtypescore[i] )
								  {return true;}
						}
						return false;
					}else if (!brush.empty() &&  (opt.guide.isClickedTextPanel || opt.guide.isClickedLegendPanel)){
						for(var i=0; i< opt.guide.subtypescore.length; i++) {
							  if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1 && (d.content.subtype +'_'+d.content.score) == opt.guide.subtypescore[i] )
								  {return true;}
						}
						return false;
					}else if (!brush.empty() &&  !(opt.guide.isClickedTextPanel && opt.guide.isClickedLegendPanel)){
					    if( x0 <= d.x && d.x <= x1 && y0 <= d.y && d.y <= y1)
					    {return true;}else{return false;}
					
					}
						
					else{//brush.empty() && opt.guide.subtype.length == 0
					
						return false;
					}	break;
				}
		}
		
		function isNodeinTextPanelFilter(d,type, opt)
		{
			switch (type)
			{
			case "ele":
				if(opt.ele.subtypetxt.length == 0){
					return true;//all are selected
				}else{
					for(var i=0; i< opt.ele.subtypetxt.length; i++) {
						  if( (d.content.subtype +'_'+d.content.txt) == opt.ele.subtypetxt[i] )
							  {return true;}
					}
					return false;
				}
			  return true;
			  break;
			case "imp":
					if(opt.imp.subtype.length == 0){
						return true;//all are selected
					}else{
						for(var i=0; i< opt.imp.subtype.length; i++) {
							  if( d.content.subtype == opt.imp.subtype[i] )
								  {return true;}
						}
						return false;
					}						  
			break;
			case "goal":
				
					if(opt.goal.subtypescore.length == 0){
						return true;//all are selected
					}else{
						for(var i=0; i< opt.goal.subtypescore.length; i++) {
							  if( (d.content.subtype +'_'+d.content.score) == opt.goal.subtypescore[i] )
								  {return true;}
						}
						return false;
					}
			  return true;
			  break;
			case "guide":
				
				if(opt.guide.subtypescore.length == 0){
					return true;//all are selected
				}else{
					for(var i=0; i< opt.guide.subtypescore.length; i++) {
						  if( (d.content.subtype +'_'+d.content.score) == opt.guide.subtypescore[i] )
							  {return true;}
					}
					return false;
				}
		  return true;
		  break;
			}
		}
		
		function showExplainsandTextPanel(graph, width, height )
		{
			var jsonArray = [];
			var hash_IDs = new Hashtable();
			
			graph.nodes.forEach(function(d, i) {
				

				if (isNodeinBothFilters(d,displyType, opt)) {
					//t += 1;

					var tmp = d.id;
					if (!(hash_IDs.containsKey(tmp))) {
						hash_IDs.put(tmp, "")
						jsonArray.push({
							id : d.id,
							cord : d.cord,
							txt : d.content.txt,
							score:d.content.score,
							subtype:d.content.subtype
						});
						//	txt : (d.content.score).concat(d.content.txt),
					}

				}
			});
			
			if (jsonArray.length > 0) {
				//$('#explain_heatnetwork').empty();
				$(explain_feedbackTypes[current_tab]).empty();

				/*
					var jsonArrayOneImp = [
							 {'id': 'w_0_0',
							'cord':[50,50,180,223],
							'txt' : '1JavaScript is a general purpose programming language that was introduced as the page scripting language for Netscape Navigator'
							 },
							 {'id':'w_0_1',
							'cord':[0,0,51,104],
							'txt' : '2JavaScript is a general purpose programming language that was introduced as the page scripting language for Netscape Navigator'
							 }
					] ;
				 */
				if (displyType != "ele")
				{
//					if(displyType == "imp")
//					{
//						var list = {"162":9,"165":8,"177":7,"178":6,"166":5,"152":4,"132":3,"174":2};//anbang to make the fig
//						for(var i_list = 0; i_list < jsonArray.length; i_list++)
//							{
//								jsonArray[i_list].score = list[jsonArray[i_list].id];
//							}
//					}
					
//					if(displyType == "guide")
//					{
//						var list = {"96":9,"95":8,"93":7,"94":6,"50":5};//anbang to make the fig
//						for(var i_list = 0; i_list < jsonArray.length; i_list++)
//							{
//								if(list.hasOwnProperty(jsonArray[i_list].id))
//								{jsonArray[i_list].displayorder = list[jsonArray[i_list].id];}else{
//									jsonArray[i_list].displayorder = 0;
//								}
//							}
//						jsonArray_sorted=$(jsonArray).sort(sortTmporderDesc);
//
//					}
					
//					if(displyType != "guide")////anbang to make the fig
					jsonArray_sorted=$(jsonArray).sort(sortScoreDesc);
					console.log("data1111111111111:"+JSON.stringify(jsonArray_sorted));
					
					//var crurrentexplains = explain("#explain_heatnetwork",jsonArray_sorted, width, height);
					var crurrentexplains = explain(explain_feedbackTypes[current_tab],jsonArray_sorted, width, height);

				}

			} else {
				//$('#explain_heatnetwork').empty();
				$(explain_feedbackTypes[current_tab]).empty();
			}
			

			//update the textpanel on the right
			switch (displyType)
			{
			case "ele":
			  console.log(displyType);
			  var jsonArrTmp = [];
			  var hash_tmp = new Hashtable();
			  
			  for (var i = 0; i < jsonArray.length; i++) {				  
				  if(hash_tmp.containsKey(jsonArray[i].txt))
				  {	  var tmpVote = hash_tmp.get(jsonArray[i].txt);
					  hash_tmp.put(jsonArray[i].txt, tmpVote + 1 );
				  }else{
					  hash_tmp.put(jsonArray[i].txt, 1);
					  var subtypetxt = jsonArray[i].subtype+"_"+jsonArray[i].txt;
					  jsonArrTmp.push({"id":hash_eleSubtypetxt_IDinTable.get(subtypetxt),
						  			   "type":jsonArray[i].subtype,
						  			   "typevote":json_allColor.ele[jsonArray[i].subtype],
						  			   "element":jsonArray[i].txt,
						  			   "allvote":0 });
				  }	  
			  }	  
			  for (var i = 0; i < jsonArrTmp.length; i++) {
				  //{"id":"505_4","type":"color","typevote":3,"element":"Green","allvote":"2"},
 
				  jsonArrTmp[i].allvote = hash_tmp.get(jsonArrTmp[i].element);
				  
				}
				
			  //console.log(jsonArrTmp);
			  tab_element.update(jsonArrTmp);
			  
			  if(brush.empty())
				 {

				 	//console.log("after:"+tab_element.getLegendCheckedData());
				 	tab_element.update(tab_element.getLegendCheckedData());


				 }
			  
			  break;
			case "imp":
					d3.selectAll('.impword')
					.attr("display", "none");
					for (var i = 0; i < jsonArray.length; i++) {
						
						var impID = hash_ImpContent_IDinCloud.get(jsonArray[i].subtype);
						d3.select('#'+impID)
						.attr("display", "inline");
					}
					
					 if(brush.empty())
						 {
						 d3.selectAll('.impword')
							.attr("display", "inline");
						 }
					 
			  break;
			case "goal":
					d3.selectAll("rect[class^='mode_goal_']")
					.attr("display", "none");
					
					var arrs = tab_stackbar_goal.getCurrentData();
					var arrTmp = iniArry(arrs);
					//var arrOrg  = copyArry(arrs);
					 //console.log("before:"+arrs);

					
					for (var i = 0; i < jsonArray.length; i++) {
						
						var index_m = (jsonArray[i].subtype).slice(4);
						var index_n = jsonArray[i].score;
						var barID =  "mode_goal_"+index_m+"_"+index_n;
						console.log(jsonArray[i].subtype+"   "+"barID:"+barID);
						arrTmp[index_m][index_n]++; 
						//mode_goal_0_0
							
						d3.select('#'+barID)
						.attr("display", "inline");
					}
					//var arrTmp = [[5,5,5,5,5,5,5],[6,6,6,6,6,6,6]];

	
					//if the right text pane is Clicked, don't update the right text panel.
					//if(!optFilters[displyType].isClickedTextPanel)
					//{
						tab_stackbar_goal.update(arrTmp);
					 	//console.log("optFilter.goal.isClickedTextPanel:"+optFilters.goal.isClickedTextPanel);
				    //}
					 if(brush.empty())
						 {
						 d3.selectAll("rect[class^='mode_goal_']")
							.attr("display", "inline");
						 	console.log("after:"+tab_stackbar_goal.getLegendCheckedData());
							//tab_stackbar_goal.update(tab_stackbar_goal.getOrgData());
							tab_stackbar_goal.update(tab_stackbar_goal.getLegendCheckedData());


						 }
					 
				  //console.log(displyType);
			  break;
			case "guide":
					d3.selectAll("rect[class^='mode_criteria_']")
					.attr("display", "none");
					
					var arrs = tab_stackbar_criteria.getCurrentData();
					var arrTmp = iniArry(arrs);
	
					
					for (var i = 0; i < jsonArray.length; i++) {
						
						var index_m = (jsonArray[i].subtype).slice(5);
						var index_n = jsonArray[i].score;
						var barID =  "mode_criteria_"+index_m+"_"+index_n;
						arrTmp[index_m][index_n]++; 
						//mode_criteria_0_0
						//console.log("barID:"+barID);	
						d3.select('#'+barID).attr("display", "inline");
					}
					
	
					//for fig in the paper if the right text panel is Clicked, don't update the right text panel.
					//if(!optFilters[displyType].isClickedTextPanel)
					//{
						tab_stackbar_criteria.update(arrTmp);
					 	//console.log("optFilter.guide.isClickedTextPanel:"+optFilters.guide.isClickedTextPanel);
				    //}
					
				    if(brush.empty())
						 {
						 d3.selectAll("rect[class^='mode_criteria_']")
							.attr("display", "inline");
						 	console.log("after:"+tab_stackbar_criteria.getLegendCheckedData());
							//tab_stackbar_criteria.update(tab_stackbar_criteria.getOrgData());
							tab_stackbar_criteria.update(tab_stackbar_criteria.getLegendCheckedData());
	
	
						 }
					 
				  //console.log(displyType);
			  break;
			} 
		}
		

		
		function iniArry(arrs){
			var arrTmp = []; while(arrTmp.push([]) < arrs.length);
			
			for ( var r = 0; r < arrs.length; r++) {
				for ( var i = 0; i < arrs[r].length; i++) {
					arrTmp[r][i] = 0;
				}
			}
			return arrTmp;
		}
		
		function updateSubtypes (graph){
			hash_subtype = new Hashtable();
			var index =0;
			graph.nodes.forEach(function(d) {
				if (d.type == displyType) {
					if (!(hash_subtype.containsKey(d.content.subtype))) {
						hash_subtype.put(d.content.subtype, index);
						
						//console.log("hash_subtype"+d.content.subtype+" index:"+index);

						index++;
						

					}
				}
			});
		}
		jQuery.fn.sort = function() {  
		    return this.pushStack( [].sort.apply( this, arguments ), []);  
		};  

		 function sortScore(a,b){  
		     if (a.score == b.score){
		       return 0;
		     }
		     return a.score> b.score ? 1 : -1;  
		 };  

		 function sortScoreDesc(a,b){  
		     return sortScore(a,b) * -1;  
		 };

		 function sortTmp(a,b){  
		     if (a.displayorder == b.displayorder){
		       return 0;
		     }
		     return a.displayorder> b.displayorder ? 1 : -1;  
		 };  
		 function sortTmporderDesc(a,b){  
		     return sortTmp(a,b) * -1;  
		 };
		 
		 self.updateFilters = function(opttmp) {
			 opt = opttmp;
		 }
		return self;
	};

})(d3);
