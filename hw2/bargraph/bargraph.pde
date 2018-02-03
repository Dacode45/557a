class BarGraph {
  
  Table table; 
  String xName;
  String yName;
  float draw_width;
  float draw_height;
  float draw_x;
  float draw_y;
  float padding = 20;
  
  float state = 3;
  float next_state = 0;
  float state_transition_time = 1;
  
  String toolTipText = "";
  
  boolean clicked = false;
  
  BarGraph(Table t, String x, String y) {
    LoadTable(t, x, y);
  }
  
  void Resize(float x, float y, float w, float h) {
      draw_x = x;
      draw_y = y;
      draw_height = h;
      draw_width = w;
  }
  
  void LoadTable(Table t, String x, String y) {
    table = t; 
    xName = x;
    yName = y; 
    
    state = 3;
    next_state = 0;
 
  }
  
  boolean inRectBounds(float point_x, float point_y, float rect_x, float rect_y, float rect_w, float rect_h) {
     return (point_x >= rect_x && point_x <= (rect_x + rect_w) && point_y >= rect_y && point_y <= (rect_y + rect_h));
  }
  
  boolean isClose(float a, float b) {
    if (abs(a-b) < 0.1) {
       return true; 
    } else {
      return false; 
    }
  }
  // Update the state 
  void Update(float dt) {
    if (!isClose(state, next_state)) {
      if (state < next_state) {
        state += dt; 
      } else {
        state -= dt; 
      }
    } else {
      state = next_state; 
    }
    print("state: " + state + "\n");
      
  }
  
  int Max() {
    int m = 0;
    for(TableRow row : table.rows()) {
      m = max(m, row.getInt(yName));
    }
    return m;
  }
  
  int NumRows() {
    int m = 0;
    for (TableRow row : table.rows()) {
      m++; 
    }
    return m;
  }
  
  TableRow[] GetRows() {
    TableRow[] rows = new TableRow[NumRows()]; 
    int i = 0;
    for (TableRow row : table.rows()) {
      rows[i] = row;
      i++;
    }
    return rows;
  }
  
  void DrawToolTip(String t) {
    float text_length = t.length()*8 + 6;
    fill(255, 255, 0);
    rect(mouseX, mouseY - 15, text_length, 20);
    fill(0,0,0);
    text(t, mouseX+6, mouseY); 
  }
  
  void DrawBars() {
    float hor_tick = h_tick();
    float vert_tick = v_tick();
    
    
    // Draw bars
    float rounded_max = ((Max() + 9)/10)*10;
    int i = 1;
    for (TableRow row : table.rows()) {
      float value = row.getInt(yName);
      String name = row.getString(xName);
      float bar_percent = value/rounded_max;
      float bar_percent_inverse = 1 - bar_percent;
      
      float start_y = tl_y() + vert_tick + bar_percent_inverse * 10* vert_tick;
      float ending_height = max(bar_percent * 10 * vert_tick * (1 - (state%1)), 20);
      
      rect( tl_x() + hor_tick*i - 10, start_y , 20, ending_height);
      if (inRectBounds(mouseX, mouseY, tl_x() + hor_tick*i - 10, start_y, 20, ending_height)) {
        toolTipText = (name+": " + value);  
      }
      i++;
    }
    
  }
  
  void DrawLineGraph() {
    float hor_tick = h_tick();
    float vert_tick = v_tick();
    float[] x_points = new float[NumRows()];
    float[] y_points = new float[NumRows()];
    
    // Draw points
    float rounded_max = ((Max() + 9)/10)*10;
    int i = 1;
    for (TableRow row : table.rows()) {
      float value = row.getInt(yName);
      String name = row.getString(xName);
      float bar_percent = value/rounded_max;
      float bar_percent_inverse = 1 - bar_percent;
      
      float start_y = tl_y() + vert_tick + bar_percent_inverse * 10* vert_tick;
      float ending_height = 20;//bar_percent * 10 * vert_tick;
      float hw = 10;
      x_points[i-1] = tl_x() + hor_tick*i;
      y_points[i-1] = start_y;
      
      ellipse(x_points[i-1], start_y, 2*hw, ending_height); 
      
      if (inRectBounds(mouseX, mouseY, x_points[i-1]-hw, start_y, 2*hw, ending_height)) {
        toolTipText = (name+": " + value);  
      }
      
      i++;
    }
    
    // Draw lines
    float linesToDraw = NumRows();
    if(state >= 1 && state < 2) {
      linesToDraw = 0;
    } else if (state >= 2 && state < 3) {
      linesToDraw *= min((state%1 + .1),1); 
    }
    for (i = 1; i < linesToDraw; i++) {
      line(x_points[i-1], y_points[i-1], x_points[i], y_points[i]);
    }
    
  }
  
  void DrawAxis() {
     // lines
     line(tl_x(), tl_y(), bl_x(), bl_y());
     line(bl_x(), bl_y(), br_x(), br_y());
     
     // create tick marks;
     float vert_tick = v_tick();
     float hor_tick = h_tick();
     
     // vertical ticks.
     for (int i = 1; i <= 10; i++) {
       line(tl_x()-10, tl_y() + vert_tick*i, tl_x(), tl_y() + vert_tick*i);  
     }
     
     // horizontal ticks.
     for (int i = 1; i <= NumRows(); i++) {
       line(tl_x() + hor_tick*i, bl_y(), tl_x() + hor_tick*i, bl_y() + 10 + 10*(i%2));
     }
     
     int rounded_max = ((Max() + 9)/10)*10;
     int tenths = rounded_max/10; 
     
     fill(0,0,0);
     // y axis titles. 
     for (int i = 1; i <= 10; i++) {
       float text_x = bl_x() - 20;
       float text_y = bl_y() - vert_tick*i + 5;
       pushMatrix();
       translate(text_x, text_y);
       rotate(-HALF_PI);
       text(Integer.toString(tenths*i), 0, 0);
       popMatrix();
     }
     
     // x axis titles
     int i = 1;
     for (TableRow row : table.rows()) {
       String name = row.getString(xName);
       text(name, bl_x() + hor_tick*i - name.length()/2*6, bl_y() + 23 + 15*(i%2));
       i++;
     }
     
  }
  
  void DrawButton() {
    String button_text = "";
    if (next_state == 0) {
      button_text = "Line Graph";
    } else if (next_state == 3) {
      button_text = "Bar Graph"; 
    }
    if (state != 0 && state != 3) {
      fill(200,200,200);
    } else {
      fill(255,255,255);
    }
    float button_width = button_text.length() * 8 + 6;
    rect(tr_x() - button_width, draw_y - 15, button_width, 20);
    fill(0,0,0);
    text(button_text, tr_x() - button_width + 6, draw_y ); 
    
    if (clicked && inRectBounds(mouseX,mouseY,tr_x() - button_width, draw_y - 15, button_width, 20)) {
      if (state == 0) {
        next_state = 3; 
      } else if (state == 3) {
        next_state = 0;
      }  
    }
    
  }

  
  void Draw() {
     DrawAxis(); 
     if (state >= 0 && state < 1) {
        DrawBars();  
     } else if (state >= 1 && state < 2) {
        DrawLineGraph();
     } else if (state >= 2) {
        DrawLineGraph();
     }
     
     if (toolTipText != "") {
       DrawToolTip(toolTipText);
     }
     toolTipText = "";
     DrawButton();
  }
  
    
  float v_tick() {
    return (bl_y() - tl_y() )/11;
  }
  
  float h_tick() {
    return (br_x() - bl_x())/NumRows();
  }
  
  float tl_x() {
    return draw_x + padding;
  }
  float tr_x() {
    return draw_x + draw_width - padding;
  }
  
  float tl_y() {
    return draw_y;
  }
  
  float bl_x() {
    return draw_x + padding;
  }
  
  float bl_y() {
    return draw_y + draw_height - padding; 
  }
  
  float br_x() {
    return draw_x + draw_width - 2*padding; 
  }
  
  float br_y() {
    return draw_y + draw_height - padding; 
  }
  
}

BarGraph graph;
void setup() {
  size(800, 800);
  Table table = loadTable("data.csv", "header");
  graph = new BarGraph(table, "Name", "Price");
  graph.Resize(100, 100, 600, 600);
  surface.setResizable(true);
}

void draw() {
  background(255, 255, 255, 1);
  graph.Resize(0.1*width, 0.1*height, 0.8*width, 0.8*height);
  graph.Update(1.0/(frameRate));
  graph.Draw(); 
  graph.clicked = false;
}

void mouseClicked() {
  graph.clicked = true;

}