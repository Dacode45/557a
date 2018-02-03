function Graph(table) {
  this.LoadTable(table);
}


Graph.prototype.LoadTable = function LoadTable(table) {
   this.table = table;
}

var mygraph = Graph();

function setup() {
 size(800, 800);
 var table = loadTable("auto-mpg.txt", "header");
 mygraph.LoadTable(table);
}

function draw() {
  
}