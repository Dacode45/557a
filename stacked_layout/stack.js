(function stackedbar(csv_url) {
  var margin = {
    top: 20,
    bottom: 20,
    left: 20,
    right: 20
  };
  var width = 500 - margin.left - margin.right;
  var height = 500 - margin.top - margin.bottom;

  var canvas = d3.select(".canvas")
    .append("svg")
    .attr("width", width)
    .attr("height", height);

  d3.csv(csv_url, function(data) {
    console.log(data);

    var keys = [];
    for (key in data[0]) {
      if (key !== "Year") {
        keys.push(key);
      }
    }
    console.log(keys);

    // var stack = d3.stack()
    //   .keys(keys)
    //   .order(d3.stackOrderNone)
    //   .offset(d3.stackOffsetNone);

    var minX = d3.min(data, function(d){
      return d.Year;
    });
    var maxX = d3.max(data, function(d){
      return d.Year;
    });

    var minY = d3.min(data, function(d){
      var total = 0;
      keys.forEach(function(k){
        total += +d[k];
      });
      return total;
    })

    var maxY = d3.max(data, function(d){
      var total = 0;
      keys.forEach(function(k){
        total += +d[k];
      });
      return total;
    })

    var x = d3.scaleLinear().domain([minX, maxX]).range([0,width]);
    var y = d3.scaleLinear().domain([0, maxY]).range([height, 0]);

    var colorScale = d3.scaleOrdinal(d3.schemeCategory10);

    var series = d3.stack().keys(keys)(data);

    canvas.selectAll("g")
      .data(d3.stack().keys(keys)(data))
      .enter()
      .append("g")
      .attr("fill", function(d){return colorScale(d.key);})
      .selectAll(".rect")
      .data(function(d){console.log(d);return d;})
      .enter()
      .append("rect")
      .attr("class", "rect")
      .attr("x", function(d){ return x( d.data.Year);})
      .attr("y", function(d){return y(d[1]);})
      .attr("height", function(d){return y(d[0]) - y(d[1]);})
      .attr("width", 10);

    console.log(series);
  });
})("ratings.csv");
