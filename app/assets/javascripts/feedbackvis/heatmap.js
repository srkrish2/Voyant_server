(function(d3) {
  window.heatmap = function(divID, width, height, cords) {
  //parallel = function(model, colors, svgW, svgH) {
  //window.parallel = function(model, colors) {
    var self = {};
    
    //var width = 261;
    //var height = 403;
    //var cords=[[0,0,5,10],[3,3,8,12]];
    
    
    //var margin = {top: 20, right: 20, bottom: 30, left: 30};

    var resolution = 10;
    //matrix  d1*d2
    var d1 = Math.round(width/resolution);//width261
    var d2 = Math.round(height/resolution);//403
    
    

    var matrix  =  new Array();
    
    
//    Array.prototype.repeat= function(what, L){
//      	 while(L) this[--L]= what;
//      	 return this;
//      	}
//      	
//      Array.max = function( array ){
//          return Math.max.apply( Math, array );
//      };
//       	

    for (var i = 0; i < d2 ; ++i)
    {
        var m_x = [].repeat(0, d1);

        matrix[i]  = m_x;
    }
    
    for (var i = 0; i < cords.length; ++i) {
      	
    	
    	matrix =  updateMatrix(cords[i],matrix);

      }
    
    

    var x = d3.scale.linear()
        .range([0, width]);

    var y = d3.scale.linear()
        .range([height, 0]);

    var arraySortedMatrix = getUniqueSortedArrayofMatrix(matrix);
    
    
    
    //---------------opacity mapping start---------------
    var opacityMapping = d3.scale.linear()
        .domain([0, arraySortedMatrix[arraySortedMatrix.length -1]])
        .range([0.8,0]);
    var arraryOpacity =  new Array();

    for (var i = 0; i < arraySortedMatrix.length ; ++i)
    {
    	arraryOpacity.push(opacityMapping(arraySortedMatrix[i]));
    }

    var opacity = d3.scale.linear()
    .domain(arraySortedMatrix)
    .range(arraryOpacity);
    //---------------opacity mapping end---------------
    
    //---------------color mapping start---------------
    var colorMapping = d3.scale.linear()
        .domain([0, arraySortedMatrix[arraySortedMatrix.length -1]])
        .range(["#f0f3be","#03aa5a"]);
    var arraryColor =  new Array();

    for (var i = 0; i < arraySortedMatrix.length ; ++i)
    {
    	arraryColor.push(colorMapping(	arraySortedMatrix[i]));
    }

    var color = d3.scale.linear()
    .domain(arraySortedMatrix)
    .range(arraryColor);
    //---------------color mapping end---------------

    
    var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    .ticks(20);

    var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");
    

    //svg
    //   .attr("width", width + margin.left + margin.right)
//        .attr("height", height + margin.top + margin.bottom)
      //.append("g")
      //  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    //d3.json(matrix, function(error, heatmap) {

      
//**********************start
      var heatmap = matrix;
      var dx = heatmap[0].length,                                         
      dy = heatmap.length;                                          
                                                                    
  // Fix the aspect ratio.                                          
  // var ka = dy / dx, kb = height / width;                         
  // if (ka < kb) height = width * ka;                              
  // else width = height / ka;                                      
                                                                    
      x.domain([0, dx]);
      y.domain([0, dy]);                                      
                                                                    

                                                                    
     var posImg = $("#viz").offset();     
     d3.select(divID)
     .attr("top", posImg.top)
     .attr("left", posImg.left);     
                                                                    
  d3.select(divID).append("canvas")   
  		.attr("id", "heatmapID")    
      .attr("width", dx)                                            
      .attr("height", dy)                                           
      .style("width", width + "px")                                 
      .style("height", height + "px")     
      //.style("opacity", 0.5)  
      .call(drawImage);                                             
                                                                    
  //var svg = d3.select("body").append("svg")                         
  //    .attr("width", width)                                         
  //    .attr("height", height);                                      
                                                                    
  //svg.append("g")                                                   
  //    .attr("class", "x axis")                                      
  //    .attr("transform", "translate(0," + height + ")")             
  //    .call(xAxis)                                                  
  //    .call(removeZero);                                            
                                                                    
  //svg.append("g")                                                   
  //    .attr("class", "y axis")                                      
  //    .call(yAxis)                                                  
  //    .call(removeZero);                                            
                                                                    
  // Compute the pixel colors; scaled by CSS.                       
  function drawImage(canvas) {                                      
    var context = canvas.node().getContext("2d"),                   
        image = context.createImageData(dx, dy);                    
                                                                    
    for (var y = 0, p = -1; y < dy; ++y) {                          
      for (var x = 0; x < dx; ++x) {                                
        //var c = d3.rgb();                       
        image.data[++p] = 0;                                      
        image.data[++p] = 0;                                      
        image.data[++p] = 0;                                      
        image.data[++p] = opacity(heatmap[y][x])*255;       //255   
        
//        var c = d3.rgb(color(heatmap[y][x]));                       
//        image.data[++p] = c.r;                                      
//        image.data[++p] = c.g;                                      
//        image.data[++p] = c.b;                                      
//        image.data[++p] = 255;       //255   
      }                                                             
    }                                                               
                                                                    
    context.putImageData(image, 0, 0);                              
  }                                                                 
                                                                    
  function removeZero(axis) {                                       
    axis.selectAll("g").filter(function(d) { return !d; }).remove();
  }                                                                 

//*********************end      
  function getPos(el) {
	    // yay readability
	    for (var lx=0, ly=0;
	         el != null;
	         lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
	    return {x: lx,y: ly};
	}
      
      function updateMatrix(cord, matrix){
    	  var x1 = Math.round(cord[0]/resolution);
    	  var y1 = Math.round(cord[1]/resolution);
    	  var x2 = Math.round(cord[2]/resolution);
    	  var y2 = Math.round(cord[3]/resolution);


    	  // Loop through both dimensions
    	  for (var y = 0; y < matrix.length; ++y) {
    	  	
    	  	if (y >= y1 && y <= y2 )
    	  	{
    	  	    //var entry = matrix[y];
    	  	    for (var x = 0; x < matrix[y].length; ++x) {

    	  			if (x >= x1 && x <= x2 )
    	  			{
    	  				matrix[y][x] = matrix[y][x] + 1;
    	  			}

    	  	    }
    	  	}

    	  }

    	return matrix;
    	  
      }
      
      function getUniqueSortedArrayofMatrix(matrix){
    	  
    	  var hash = new Object(); // or just {}
    	  var sorteArray = new Array();

    		  // Loop through both dimensions
    		  for (var y = 0; y < matrix.length; ++y) {
    		  	    //var entry = matrix[y];
    		  	    for (var x = 0; x < matrix[y].length; ++x) {
    		  			
    		  				hash[matrix[y][x]] = matrix[y][x];
    		  	
    		  	    }
    		  }
    		  
    		  
    		// show the values stored
    		  for (var k in hash) {
    		      // use hasOwnProperty to filter out keys from the Object.prototype
    		      //if (hash.hasOwnProperty(k)) {
    		    	  sorteArray.push(hash[k]);
    		      //}
    		  }

    	
    		 return sorteArray.sort(function(a,b){return a - b});
    	  }
    	  
      
      function isoline(min) {
    	    return function(x, y) {
    	      return x >= 0 && y >= 0 && x < dx && y < dy && heatmap[y][x] >= min;
    	    };
    	  }

    	  function transform(point) {
    	    return [point[0] * width / dx, point[1] * height / dy];
    	  } 


	
return self;
  };
  
})(d3);

