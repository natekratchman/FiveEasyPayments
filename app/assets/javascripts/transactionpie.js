// $(document).ready(function(){
//   var w = 400;
//   var h = 400;
//   var r = h/2;
//   var color = d3.scale.category20c();
//   var settled_count = 5;
//   var pending_count = 6;
//   var uncharged_count = 2;
  
//   var data = [{"label":"Settled", "value":settled_count}, 
//                 {"label":"Pending", "value":pending_count}, 
//                 {"label":"Uncharged", "value":uncharged_count}];


//   var vis = d3.select('#chart').append("svg:svg").data([data]).attr("width", w).attr("height", h).append("svg:g").attr("transform", "translate(" + r + "," + r + ")");
//   var pie = d3.layout.pie()
//     .value(function(d){return d.value;});

//   // declare an arc generator function
//   var arc = d3.svg.arc().innerRadius(r/2).outerRadius(r);

//   // select paths, use arc generator to draw
//   var arcs = vis.selectAll("g.slice").data(pie).enter().append("svg:g").attr("class", "slice");
//   arcs.append("svg:path")
//       .attr("fill", function(d, i){
//           return color(i);
//       })
//       .attr("d", function (d) {
//           // log the result of the arc generator to show how cool it is :)
//           return arc(d);
//       });

//   // add the text
//   arcs.append("svg:text").attr("transform", function(d){
//         d.innerRadius = 0;
//         d.outerRadius = r;
//       return "translate(" + arc.centroid(d) + ")";}).attr("text-anchor", "middle").text( function(d, i) {
//       return data[i].label;}
//   );

//   var svg = d3.selectAll("g.slice");
//   svg.on("mouseover", function(){d3.select(this).style("fill", "red");})
//   .on("mouseout", function(){d3.select(this).style("fill", "black");})
//   .on("click",click);

//   function click(d) {
//     // path.transition()
//     //   .duration(duration)
//     //   .attrTween("d", arcTween(d));

//     // // Somewhat of a hack as we rely on arcTween updating the scales.
//     // text.style("visibility", function(e) {
//     //       return isParentOf(d, e) ? null : d3.select(this).style("visibility");
//     //     })
//     //   .transition()
//     //     .duration(duration)
//     //     .attrTween("text-anchor", function(d) {
//     //       return function() {
//     //         return x(d.x + d.dx / 2) > Math.PI ? "end" : "start";
//     //       };
//     //     })
//     //     .attrTween("transform", function(d) {
//     //       var multiline = (d.name || "").split(" ").length > 1;
//     //       return function() {
//     //         var angle = x(d.x + d.dx / 2) * 180 / Math.PI - 90,
//     //             rotate = angle + (multiline ? -.5 : 0);
//     //         return "rotate(" + rotate + ")translate(" + (y(d.y) + padding) + ")rotate(" + (angle > 90 ? -180 : 0) + ")";
//     //       };
//     //     })
//     //     .style("fill-opacity", function(e) { return isParentOf(d, e) ? 1 : 1e-6; })
//     //     .each("end", function(e) {
//     //       d3.select(this).style("visibility", isParentOf(d, e) ? null : "hidden");
//     //     });
//   }

// });