(function(d3) {
  window.wordcloud = function(divID, iWords, hash_ImpContent_IDinCloud, iWordsVotes, img_width, img_height, object_heatnetwork) {
	 
    var self = {};
    
    var hash_IDinCloud_ImpContent = new Hashtable();
    
    for (var i = 0; i < iWords.length; i++) {
    	hash_IDinCloud_ImpContent.put(hash_ImpContent_IDinCloud.get(iWords[i]),iWords[i]);//id has to include a letter
    }
    
    Array.max = function( array ){
		 return Math.max.apply( Math, array );
	};

    //var fill =d3.scale.linear().domain([0,iWords.length-1]).range(["#0B486B","#A8DBA8"]);
    //var fill =d3.scale.linear().domain([0,iWords.length-1]).range(["#2E2633","#555152"]);
    //var fill =d3.scale.linear().domain([1, Array.max(iWordsVotes)]).range(["#0B486B","#A8DBA8"]);
    
    //var mapsize =d3.scale.linear().domain([1,Math.max.apply( Math, iWordsVotes )]).range([20,60]);
    var mapsize =d3.scale.linear().domain([1, Array.max(iWordsVotes)]).range([16,36]);
    //    var mapsize =d3.scale.linear().domain([1, Array.max(iWordsVotes)]).range([18,40]);

	  d3.layout.cloud().size([500, 190])
      .words(iWords.map(function(d,i) {
        return {text: d, size: mapsize(iWordsVotes[i]), vote:iWordsVotes[i] };
      }))
       //.rotate(function() { return ~~(Math.random() * 2) * 90; })
      .rotate(function() { return 0; })
       
      .font("Impact")
      .fontSize(function(d) { return d.size; })
      .on("end", draw)
      .start();
	  
  var lastclicked = "";
  
//If click outside of the wordcloud, reset.
  d3.select(divID)
  .on("click", function(){
	var target = d3.event.target.tagName;
	console.log(target);
	if ((target == "DIV" || target == "svg") && lastclicked !="")
	{	
			optFilters.imp.subtype = [];
			d3.select('#'+lastclicked).style("stroke-width",0);
			d3.select('#'+lastclicked).style("fill",function(d) {return assignColorImp(d.vote);});

			lastclicked = "";
			//optFilters[mode].isClickedTextPanel =  false;
			if ( isHeatmapvisible == "true")
	    	 {
		    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
	    	 }

		}
  });    
  function draw(words) {
    d3.select(divID).append("svg")
        //.attr("width", 410)
        //.attr("height", 180)
        //.attr("width", 500)
        //.attr("height", img_height-100)
        .attr("width", 465)
        .attr("height", 280)
      .append("g")
        .attr("transform", "translate(230,140)")
        //        .attr("transform", "translate(250,100)")
      .selectAll("text")
        .data(words)
      .enter().append("text")
        .style("font-size", function(d) { return d.size + "px"; })
        .style("font-family", "Impact")
        .style("fill", function(d, i) { 
	        console.log("i:"+i+"_text:"+d.text); return assignColorImp(d.vote); })
	    
        
        .attr("text-anchor", "middle")
        .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
        })
        //.attr("id",function(d,i) { return "w_"+i; })
		.attr("id",function(d,i) { return hash_ImpContent_IDinCloud.get(d.text);})	
        .attr("class", "impword")
        .text(function(d) { return d.text; })
	    .on("mouseover", function(d){
	    	if (this.id != lastclicked)
		    {
		       this.style.strokeWidth = "1.2px";
	    	   d3.select(this).style("stroke","black");  
		    }
		    	
			// if(optFilters.imp.subtype.indexOf(hash_IDinCloud_ImpContent.get(this.id)) == -1)
			// optFilters.imp.subtype.push(hash_IDinCloud_ImpContent.get(this.id));
		
			// if ( isHeatmapvisible == "true")
		    // object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);			 	
    	})
        .on("mouseout", function(d){
	    	this.style.strokeWidth = "0px";
	    	d3.select(this).style("stroke","");
	    	
        	// if (this.id != lastclicked)
        	// {
        		// for(var i = optFilters.imp.subtype.length-1; i >= 0; i--){  
            	    // if(optFilters.imp.subtype[i] == hash_IDinCloud_ImpContent.get(this.id)){      
         	    	
            	    	// optFilters.imp.subtype.splice(i,1);                 
            	    // }
            	// }
        	// }
        	
        	// if( isHeatmapvisible == "true")
			// object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],false);
	    	 
    	})
    	.on("click", function(d){

    		if (this.id != lastclicked)
		 	{
		 		if(optFilters.imp.subtype.indexOf(hash_IDinCloud_ImpContent.get(this.id)) == -1)
			    optFilters.imp.subtype.push(hash_IDinCloud_ImpContent.get(this.id));
			
    			if(lastclicked !="")
    			{
    				
    				console.log("last clicked: "+lastclicked);
    				console.log("filterbefore:"+optFilters.imp.subtype);
    				d3.select('#'+lastclicked).style("stroke-width",0);
    				d3.select('#'+lastclicked).style("fill",function(d) {return assignColorImp(d.vote);});
    				
    				for(var i = optFilters.imp.subtype.length-1; i >= 0; i--){  
                	    if(optFilters.imp.subtype[i] == hash_IDinCloud_ImpContent.get(lastclicked)){      
                	    	
                	    	optFilters.imp.subtype.splice(i,1);                 
                	    }
                	}
    				console.log("filterafter:"+optFilters.imp.subtype);

    			}
    			lastclicked = this.id;
				//alert(this.id);
	    		//this.style.fontWeight = "bold";
	    		//this.style.textShadow = "-1px 0 #F6B149, 0 1px #F6B149, 1px 0 #F6B149, 0 -1px #F6B149";
	    		//document.getElementById(this.id).style.textShadow="5px 5px 1px #ff0000";
	    		//document.getElementById(this.id).style.backgroundColor="#f3f3f3"; 
    			//document.getElementById(this.id).style.color="#ff0000";
    			
    			 //d3.select(this).style("stroke","#F6B149");// anbnag make fig
    			
    			 //d3.select(this).style("stroke-width",1);
    			 d3.select(this).style("fill","#F6B149" );
    			 
    			 //d3.select(this).style("stroke","#2ca02c");

    			 //d3.select(this).style("fill","#2ca02c" );

    			 

    			 //d3.select(this).style("border", "1px solid black") 
    			 
    			 if ( isHeatmapvisible == "true")
		    	 {
			    	 object_heatnetwork.showOneTypeNodes(json_feedbackTypes[current_tab],true);
			    	 
		    	 }else{
		    	 	 console.log("error: isHeatmapvisible is"+isHeatmapvisible);
		    		 // var tmpID =  this.id.slice(1);
						// var idArr = tmpID.split("_");
					 	// $('#explain_imp').empty();
					 	// $.ajax({
							// type: "GET",
							// url: "get_comments.php",
							// data: { twid: idArr[0], tiid: idArr[1]}
						// }).done(function( result ) {
							// var jsonArrayOneImpTmp = $.parseJSON(result);
							// var jsonArrayOneImp = jsonArrayOneImpTmp;

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
					 	
							//var crurrentexplains = explain("#explain_imp",jsonArrayOneImp, img_width, img_height);

						//});
		    		 
		    	 }
	    		
	    		
		 		
		 	}
    	})
        ;
  }

  self.updateObject_heatnetwork = function(tmp) {
	  object_heatnetwork = tmp;
	 }
	
return self;
  };
  
})(d3);

