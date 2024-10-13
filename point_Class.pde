public class point {
  int x; // x coordinate
  int y; // y coordinate
  float d0; // distance between the point and the recycling station
  String text = ""; // text printed over the point, I'm using it just to see the number of a point on a screen while implementing the algorithm, it will not be visible in the actual program later
  PImage image;
  
  public point() { // default constructor for the point
    x = 540;
    y = 270;
    d0 = 0;
    image = loadImage("recyclingStation.png");
  }
  
  public point(int x0, int y0, PImage typeOfBin) { // Constructor with user input
    x = x0;
    y = y0;
    d0 = sqrt(pow(540 - x, 2) + pow(270 - y, 2));
    image = typeOfBin;
  }
  
  public void drawPoint(int bin_side) { // Method to draw the point
    /*ellipse(x, y, bin_side, bin_side);
    fill(0);
    textSize(bin_side / 2);
    textAlign(CENTER);
    text(text, x, y, bin_side / 2);
    fill(255);*/
    
    image(image, x - bin_side / 2, y - bin_side / 2, bin_side, bin_side);
  }
}
