public class button { // Class for creating a button
  int x1; // Left x coordinate
  int x2; // Right x coordinate
  int y1; // Top y coordinate
  int y2; // Bottom y coordinate
  String text; // Text inside a button
  int r = 231; // Variables to set a color of a button
  int g = 255;
  int b = 158;
  
  public button() { // Default constructor for a button
    x1 = 20;
    x2 = 70;
    y1 = 540;
    y2 = 600;
    text = new String("Test");
  }
  
  public button(int a, int b, int c, int d, String t) { // Constructor with coordinates of a button as arguments
    x1 = a;
    x2 = b;
    y1 = c;
    y2 = d;
    text = t;
  }
  
  public void drawButton() { // Method to draw a button on a screen
    fill(r, g, b);
    rect(x1, y1, x2 - x1, y2 - y1, 10);
    fill(0, 0, 0);
    textAlign(CENTER);
    textSize(30);
    PFont font = createFont("Futura", 30);
    textFont(font);
    text(text, x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2 + 10);
  }
  
  public void buttonHover() { // Method to highlight a button if user hovers their mouse over it and highlight it more if user presses it
    if(checkMouse()) {
      if (mousePressed) {
        r = 172;
        g = 208;
        b = 37;
      }
      else {
        r = 203;
        g = 255;
        b = 15;
      }
    } else {
      r = 231;
      g = 255;
      b = 158;
    }
  }
  
  public boolean checkMouse() { // Function to check if the mouse position in on the button. I created it to check if the mouse is on a button if user clicks it
    boolean check = false;
    if (mouseX < x2 && mouseX > x1 && mouseY < y2 && mouseY > y1) check = true;
    return check;
  }
}
