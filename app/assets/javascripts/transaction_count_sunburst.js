$(document).ready(function(){
  var width = 500,
      height = 600,
      radius = Math.min(width, height) / 2;

  var x = d3.scale.linear()
      .range([0, 2 * Math.PI]);

  var y = d3.scale.sqrt()
      .range([0, radius]);

  var color = d3.scale.category20c();

  var svg = d3.select("#chart").append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(" + width / 2 + "," + (height / 2 + 10) + ")");

  var partition = d3.layout.partition()
      .value(function(d) { return d.size; });

  var arc = d3.svg.arc()
    .startAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
    .endAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
    .innerRadius(function(d) { return Math.max(0, y(d.y)); })
    .outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });
  
  var tooltip = d3.select("body")
    .append("div")
    .attr("class", "tooltip")
    .style("position", "absolute")
    .style("z-index", "10")
    .style("opacity", 0);
  
  // ----- START LOOP FOR EACH SECTION --- // 
  d3.json("payments.json", function(error, root) {
    var nodes = partition.nodes({children: root});
    var path = svg.selectAll("path")
        .data(partition.nodes(root))
      .enter().append("path")
        .attr("d", arc)
        .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
        .on("click", click);

  function click(d) {
    console.log("here");
      path.transition()
        .duration(750)
        .attrTween("d", arcTween(d));
  }
  
  var div = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 1e-6);

  var g = svg.selectAll("g")
  .data(partition.nodes(root))
    .enter()
    .append("g")
    .on("mouseover", function(d) {
          tooltip.html(function() {
              return d["name"];
          });
          return tooltip.transition()
      .duration(50)
      .style("opacity", 0.9);
        })
    .on("mousemove", function(d) {
          return tooltip
      .style("top", (d3.event.pageY-10)+"px")
      .style("left", (d3.event.pageX+10)+"px");
        })
    .on("mouseout", function(){return tooltip.style("opacity", 0);});

  var path = g.append("path")
  .attr("d", arc)
  .style("fill", function(d) { return color(d.name); })
  .on("click", click);

  function mouseover() {
  div.transition()
      .duration(500)
      .style("opacity", 1);
  }

  function mouseout() {
  div.transition()
      .duration(500)
      .style("opacity", 1e-6);
  }

  function computeTextRotation(d) {
    var angle = x(d.x + d.dx / 2) - Math.PI / 2;
    return angle / Math.PI * 180;
  }

 // text.attr("transform", function(d) { return "rotate(" + computeTextRotation(d) + ")"; });

 //  function click(d) {
 //    text.transition().attr("opacity", 0);
    
 //    path.transition()
 //      .duration(750)
 //      .attrTween("d", arcTween(d))
 //      .each("end", function(e, i) {
 //        // check if the animated element's data e lies within the visible angle span given in d
 //        if (e.x >= d.x && e.x < (d.x + d.dx)) {
 //          // get a selection of the associated text element
 //          var arcText = d3.select(this.parentNode).select("text");
 //          // fade in the text element and recalculate positions
 //          arcText.transition().duration(750)
 //            .attr("opacity", 1)
 //            .attr("transform", function() { return "rotate(" + computeTextRotation(e) + ")" })
 //            .attr("x", function(d) { return y(d.y); });
 //        }
 //      });
 //  }

  });

  d3.select(self.frameElement).style("height", height + "px");
  
  function arcTween(d) {
    var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
        yd = d3.interpolate(y.domain(), [d.y, 1]),
        yr = d3.interpolate(y.range(), [d.y ? 20 : 0, radius]);
    return function(d, i) {
      return i
          ? function(t) { return arc(d); }
          : function(t) { x.domain(xd(t)); y.domain(yd(t)).range(yr(t)); return arc(d); };
    };
  }
});