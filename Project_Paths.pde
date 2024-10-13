// When referring to 'the article' I mean "The Truck Dipatching Problem" by G.B.Dantzig and J.H.Ramser 1959 (https://www.jstor.org/stable/2627477?seq=4) //<>//

import java.util.*; // Library I use for lists
import java.lang.Math;

PImage glassBinImage, plasticBinImage, metalBinImage, recyclingStationImage;

int bin_side = 70; // Size of a side of a bin image (ellipse for now);
int recycleStationX = 540; // Coordinates of the recycling station
int recycleStationY = 270;
int numberOfMetalBins = 0; // Quantity of each type of bin
int numberOfPlasticBins = 0;
int numberOfGlassBins = 0;

int metalSavedCO2; // Variables to store the total amount of saved CO2 (in kgs)
int plasticSavedCO2;
int glassSavedCO2;
int totalSavedCO2;

int totalDistanceCovered = 0; // Variable to store a total distance covered by a truck

boolean CO2InformationShown = false; // Variable to track if the program needs to show the information about CO2 saved 

Random rand = new Random();

List<point> points = new ArrayList<point>(); // List for points

button startButton; // Button to map the path of the truck
button clearButton; // Button to clear the points on the map
button calculateCO2Button; // Button to show the information about the CO2 produced and calculate how much of ot was saved
button closeCO2InformationButton; // Button to close the tab that shows information about CO2 produced

static void checkArray(float[][][] array, int row) { // Methos to display the array
  println("P0");
  for (int i = 0; i < array.length; i++) {
    for (int j = 0; j <= i; j++) {
      print(array[i][j][row] + "\t");
    }
    print("P" + (i + 1));
    println("");
  }  
}

public int findMinConnection(float[][][] array, int[] connections, int pointNumber) { // Function to find the point of closest connection to a point
      float min = 99999;
      int minPoint = -1;
      if (pointNumber < array.length) { // We can't check the Column below the furtherst Point because there is no column (otherwise there would be an ArrayIndexOutOfBoundsException
        for (int i = pointNumber; i < array.length; i++) { // Check the Column below the Point
          if (array[i][pointNumber][0] < min && connections[i + 1] < 2 && array[i][pointNumber][1] <= 0) { // Check if 1) The point is supposedly the closest to the connection point, 2) Number of connections of the second point allows it to be connected (<2) except point 0 (recycling station) and 3) The two points are not already connected
            min = array[i][pointNumber][0];
            minPoint = i + 1;
          }
        }
      }
      if (pointNumber > 0) { // We can't check the Row on the left of the Point 0 (recycling station) because there is no row (otherwise there would be an ArrayIndexOutOfBoundsException
        for (int j = 0; j < pointNumber; j++) { // Check the Row on the left of the Point
          if (array[pointNumber - 1][j][0] < min && ((connections[j] < 2 && j > 0) || (j == 0)) && array[pointNumber - 1][j][1] <= 0) { // Check if 1) The point is supposedly the closest to the connection point, 2) Number of connections of the second point allows it to be connected (<2) and 3) The two points are not already connected
            min = array[pointNumber - 1][j][0];
            minPoint = j;
          }
        }
      }
    return minPoint;
  }

void setup() {
 size(1080, 720); 
 background(120,152,133);
 rect(20, 20, 1040, 500, 10); // Drawing a "map" on which and only on which the user can map the bins
 startButton = new button(640, 1060, 540, 610, "Start mapping the path");
 clearButton = new button(640, 1060, 620, 690, "Clear the map");
 calculateCO2Button = new button(200, 620, 540, 610, "Calculate CO2 saved");
 closeCO2InformationButton = new button(980, 1020, 60, 100, "X");
 points.add(new point(recycleStationX, recycleStationY, recyclingStationImage)); // The first point is the 'recycling station'
 
 plasticBinImage = loadImage("plasticBin.png");
 metalBinImage = loadImage("metalBin.png");
 glassBinImage = loadImage("glassBin.png");
 recyclingStationImage = loadImage("recyclingStation.png");
 textureMode(NORMAL);
 blendMode(BLEND);
}

void mousePressed() {
  if (mouseX > 20 + bin_side / 2 && mouseX < 1060 - bin_side / 2 && mouseY > 20 + bin_side / 2 && mouseY < 520 - bin_side / 2 && Math.sqrt(Math.pow(recycleStationX - mouseX, 2) + Math.pow(recycleStationY - mouseY, 2)) > 25 + bin_side / 2 && !(CO2InformationShown && closeCO2InformationButton.checkMouse())) { // Checks if the input is within allowed boundaries
    Random rand = new Random();
    int binType = rand.nextInt(3); // Random number from 0 to 2; 0 - metal bin, 1 - plastic bin, 2 - glass bin 
    switch (binType) {
      case 0: numberOfMetalBins++; points.add(new point(mouseX, mouseY, metalBinImage)); break; // Input for a point
      case 1: numberOfPlasticBins++; points.add(new point(mouseX, mouseY, plasticBinImage)); break;
      case 2: numberOfGlassBins++; points.add(new point(mouseX, mouseY, glassBinImage)); break;
      default: println("No such type of bin"); break;
    }
    totalDistanceCovered = 0;
  }
}

void draw() {
  fill(115, 208, 22);
  image(recyclingStationImage, recycleStationX - 50, recycleStationY - 50, 100, 100); // Drawing an ellipse which represents a "recycling station" which is in a middle of the map
  fill(255);
  startButton.drawButton(); // It draws button every frame
  startButton.buttonHover(); // It checks if user hovers or clicks on a button every frame
  clearButton.drawButton();
  clearButton.buttonHover();
  calculateCO2Button.drawButton();
  calculateCO2Button.buttonHover();
  textAlign(LEFT);
  fill(0);
  textSize(20);
  text("// Orange bin is for plastic, Yellow one is \nfor metal and Green one is for glass", 20, 660);
  fill(255);
  for (int i = 1; i < points.size(); i++) { // Mapping all the bins on the map
    points.get(i).drawPoint(bin_side);
  }
  
  if (CO2InformationShown) { // The CO2 information tab
    closeCO2InformationButton.drawButton();
    closeCO2InformationButton.buttonHover();
    textSize(20);
    textAlign(LEFT);
    fill(231, 255, 158, 100);
    rect(40, 40, 1000, 460, 10);
    fill(0);
    text("The truck collecting bins on average produces 7.5 - 10.5 kg of CO2 per km \n(9 kg will be used in calculations)", 50, 70);
    text("Recycling 1 kg of metal reduces on average 8 kg of CO2 emmissions, 1 kg of plastic - 3 kg of CO2,\n1 kg of glass - 1 kg of CO2. One bin can contain up to 45 kg of metal or 35 kg of plastic or 50 kg of glass", 50, 130);
    text("By collecting " + numberOfMetalBins + " bins for recycling metal, " + metalSavedCO2 + " kg of CO2 was saved", 50, 190);
    text("By collecting " + numberOfPlasticBins + " bins for recycling plastic, " + plasticSavedCO2 + " kg of CO2 was saved", 50, 220);
    text("By collecting " + numberOfGlassBins + " bins for recycling glass, " + glassSavedCO2 + " kg of CO2 was saved", 50, 250);
    text("So, in total " + totalSavedCO2 + " kg of CO2 was saved", 50, 280);
    if (totalDistanceCovered > 0) {
      float truckEmmissions = (float)Math.round(totalDistanceCovered) / 1000 * 9;
      text("By covering " + (float)Math.round(totalDistanceCovered) / 1000 + " km (1 pixel = 1 meter), " + truckEmmissions + " kg of CO2 was produced by the truck collecting the bins", 50, 310);
      
      textSize(25);
      if ((float)totalSavedCO2 - truckEmmissions > 0) text("So, considering the truck's emmissions, by recycling all of the bins, \n" + ((float)totalSavedCO2 - truckEmmissions) + " kg of CO2 were saved!!! :D", 50, 360);
      else if ((float)totalSavedCO2 - truckEmmissions == 0) text("So, considering the truck's emmissions, the amount of CO2 saved equals \nto the amount of CO2 produced :|", 50, 360);
      else text("Unfortunately, considering the truck's emmissions, the amount of CO2 produced \nin total is " + (truckEmmissions - (float)totalSavedCO2) + " kg of CO2 :(", 50, 360);
    }
  }
  fill(255);
}

void mouseClicked() {
  if (startButton.checkMouse() && points.size() > 1) { // Functionality to the startButton
    rect(20, 20, 1040, 500, 10); // Drawing a 'map' again, in case the user clicks the button the second time with different set of points
    CO2InformationShown = false;
    totalDistanceCovered = 0; // The total distance is going to be calculated from 0 because the path is most probably going to change
    
    // Sorting a list of points
    Collections.sort(points, (p1, p2) -> Double.compare(p1.d0, p2.d0)); // A modified piece of code to sort the list of objects by particular variable inside an object. Used pieces of code found on StackOverflow by Marsellus Wallace and a tutorial for sorting lists on DigitalOcean website (I will use this later in the code as well) 
    int points_count = points.size(); // Number of coordinates (bins) on a map + starting point (recycling station)
    
    for (int i = 0; i < points_count; i++) { // checking the points
      println("P" + i + " " + points.get(i).x + " " + points.get(i).y + " " + points.get(i).d0); // check the sorted coordinates
      points.get(i).text = new String("P" + i);
    }
    println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    // Filling the D array with distances between points
    float[][][] distances = new float[points_count - 1][points_count][2]; // D array for the distances between Points (more about it in the article), I added third dimension to note properties of d(i,j) elements (1 or 0), basically adding array of x(i,j) inside the D array so it's easier to work with
    float[] d_for_median = new float[(points_count - 1)*(points_count)/2]; // I've created an array to store all the Dij values to calculate the mean value of these distances. The length of that array is derived from the Sum of Arithmetic Sequence Formula (Sn = n / 2 [2a + (n-1)d] where n = points_count - 1, a = 1, d = 1
    int count = 0; // count elements in D
    //println("d_for_median length = " + d_for_median.length); // checking the length of the d_for_median array
    
    for (int i = 0; i < points_count - 1; i++) { // filling the D array, where i - rows, j - columns
      for (int j = 0; j <= i; j++) { // array is triangular, so the number of columns changes with the row (see Table 1 in the article p. 82 as an example)
        distances[i][j][0] = (float)Math.round(sqrt(pow(points.get(i + 1).x - points.get(j).x, 2) + pow(points.get(i + 1).y - points.get(j).y, 2)) * 1000) / 1000; // finding distance between two points
        distances[i][j][1] = -1.0; // By default, the points are not connected
        d_for_median[count] = distances[i][j][0];
        count++;
      }
      distances[i][0][1] = 1.0; // following the algorithm, every point connected to the P0 (recycling station) receives 1 for now
    }
    checkArray(distances, 0);
    
    println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    // Finding the median of all values of Dij in the array D
    Arrays.sort(d_for_median);
    float d_median = d_for_median[d_for_median.length / 2];
    //println("d_median = " + d_median); // checking the median
    
    // Looking for relatively small values of Dij and processing the first-stage aggregation
    float small_value = 0.2; // the authors of the article don't specify what is 'relatively small value' of Dij, so I took the fraction of the median to look for 'relatively small' values (any value lower that that fraction of the median is considered 'small value'). I made 'the fraction' a different variable so it would be easier to change it and see what 'relatively small value' fits the most
    small_value *= d_median;
    for (int i = 0; i < points_count - 1; i++) {
      for (int j = 0; j <= i; j++) {
        if (distances[i][j][0] < small_value) {
          distances[i][j][1] = 1.0;
          distances[i][0][1] = -1;
          if (i > 0) distances[i - 1][0][1] = 0.0;
        }
      }
    }
    checkArray(distances, 1);
    
    println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    float maxDelta = 1;
    List<Float> deltas = new ArrayList<Float>();
    
    while(maxDelta > 0) {  
      // Finding the pi(i) values
      float[] pi = new float[points_count];
      pi[0] = 0; // By default the pi value of P0 is 0
      for (int i = 0; i < points_count - 1; i++) {
        if (distances[i][0][1] >= 0) pi[i + 1] = distances[i][0][0];
        else {
          for (int j = 1; j <= i; j++) {
            if (distances[i][j][1] >= 0) {
              pi[i + 1] = distances[i][j][0] - pi[j];
              break;
            }
          }
        }
      }
      print("Pi values: ");
      for (int i = 0; i < pi.length; i++) print(pi[i] + " "); // check all the values of pi
      println("");
      
      // Finding delta values
      
      int rDelta = 0;
      int sDelta = 0; // position of delta in the D array (r and s = i and j)
      maxDelta = -999999;
      
      for (int i = 0; i < points_count - 1; i++) {
        for (int j = 0; j <= i; j++) {
          float tempDelta = pi[j] + pi[i + 1] - distances[i][j][0];
          if (tempDelta > maxDelta) {
            maxDelta = tempDelta; // new value of max to store the max value of delta
            rDelta = i + 1; // Point i
            sDelta = j; // Point j
          }
        }
      }
      
      println("maxDelta = " + maxDelta + " rDelta = " + rDelta + " sDelta = " + sDelta); // Check the values and the position of maxDelta
      
      if (maxDelta <= 0) break; // If maximum value of delta is equal or below 0, the change of basic set will not result in shortage of total distance, so we should not iterate the change of basic set if maxDelta is <= 0
      
      deltas.add(maxDelta);
      println("Last 3 delta values: " + deltas);
      if(deltas.size() == 3 && deltas.get(0).equals(deltas.get(2))) { // prevents cycling
        break;
      } else if (deltas.size() == 3) {
        deltas.remove(0);
      }
      
      println("~~~~~~~~~~~~~~~~~~~~~~~~~");
      
      // Finding value of theta and inserting it into the xij array
      
      // Firstly, I find the values which are going to be affected by theta
      
      int xColumnSi = 0;
      int xColumnSj = 0;
      int xRowSi = 0;
      int xRowSj = 0;
      int xColumnRi = 0;
      int xColumnRj = 0;
      int xRowRi = 0;
      int xRowRj = 0;
      
      for (int i = sDelta; i < points_count - 1; i++) {
        if (distances[i][sDelta][1] >= 0) {
          xColumnSi = sDelta; // Point i of the xij value affected
          xColumnSj = i + 1; // Point j of the xij value affected
          break;
        }
      }
      for (int j = 0; j < sDelta; j++) {
        if (distances[sDelta - 1][j][1] >= 0) {
          xRowSi = j;
          xRowSj = sDelta;
          break;
        }
      }
      for (int i = rDelta; i < points_count - 1; i++) {
        if (distances[i][rDelta][1] >= 0) {
          xColumnRi = rDelta;
          xColumnRj = i + 1;
          break;
        }
      }
      for (int j = 0; j < rDelta; j++) {
        if (distances[rDelta - 1][j][1] >= 0) {
          xRowRi = j;
          xRowRj = rDelta;
          break;
        }
      }
      
      // Secondly, I find the value of theta
      
      float[][] valuesAffectedByTheta = new float[4][3];
      if (xColumnSi != 0 || xColumnSj != 0) {
        valuesAffectedByTheta[0][0] = distances[xColumnSj - 1][xColumnSi][1];
        valuesAffectedByTheta[0][1] = xColumnSi;
        valuesAffectedByTheta[0][2] = xColumnSj;
      } else {
        valuesAffectedByTheta[0][0] = -1;
      }
      if (xRowSi != 0 || xRowSj != 0) {
        valuesAffectedByTheta[1][0] = distances[xRowSj - 1][xRowSi][1];
        valuesAffectedByTheta[1][1] = xRowSi;
        valuesAffectedByTheta[1][2] = xRowSj;
      } else {
        valuesAffectedByTheta[1][0] = -1;
      }
      if (xColumnRi != 0 || xColumnRj != 0) {
        valuesAffectedByTheta[2][0] = distances[xColumnRj - 1][xColumnRi][1];
        valuesAffectedByTheta[2][1] = xColumnRi;
        valuesAffectedByTheta[2][2] = xColumnRj;
      } else {
        valuesAffectedByTheta[2][0] = -1;
      }
      if (xRowRi != 0 || xRowRj != 0) {
        valuesAffectedByTheta[3][0] = distances[xRowRj - 1][xRowRi][1];
        valuesAffectedByTheta[3][1] = xRowRi;
        valuesAffectedByTheta[3][2] = xRowRj;
      } else {
        valuesAffectedByTheta[3][0] = -1;
      }
      
      println("xColumnS = (P" + xColumnSi + " -> P" + xColumnSj + ")   " + valuesAffectedByTheta[0][0]); // Checking if I find the right variables
      println("xRowS = (P" + xRowSi + " -> P" + xRowSj + ")   " + valuesAffectedByTheta[1][0]);
      println("xColumnR = (P" + xColumnRi + " -> P" + xColumnRj + ")   " + valuesAffectedByTheta[2][0]);
      println("xRowR = (P" + xRowRi + " -> P" + xRowRj + ")   " + valuesAffectedByTheta[3][0]);
      
      Arrays.sort(valuesAffectedByTheta, (theta1, theta2) -> Double.compare(theta1[0], theta2[0]));
      
      /*for (int i = 0; i < 4; i++) { // check sorted Array
        println(valuesAffectedByTheta[i][0]);
      }*/
      
      println("~~~~~~~~~~~~~~~~~~~~~~~~~");
      
      float theta = -1; // Theta is the biggest number that leaves the lowest xij non-negative if we substract theta from it
      for (int i = 0; i < 4; i++) {
        if (valuesAffectedByTheta[i][0] >= 0) {
          theta = valuesAffectedByTheta[i][0];
          break;
        }
      }
      println("Theta: " + theta);
      
      // Adjusting xij values to theta
      distances[rDelta - 1][sDelta][1] = theta;
      float tempTheta = 0;
      int itempTheta = 0;
      for (int i = 0; i < 4; i++) { // Finding the value that is going to be dropped
        if (valuesAffectedByTheta[i][0] == theta) {
          if (distances[(int)Math.ceil(valuesAffectedByTheta[i][2]-1)][(int)Math.ceil(valuesAffectedByTheta[i][1])][0] > tempTheta) {
            tempTheta = valuesAffectedByTheta[i][0];
            itempTheta = i;
          }
        }
      }
      for (int i = 0; i < 4; i++) {
        if (valuesAffectedByTheta[i][0] >= 0) {
          if (i != itempTheta) {
            distances[(int)valuesAffectedByTheta[i][2] - 1][(int)valuesAffectedByTheta[i][1]][1] -= theta;
          }
          else { 
            distances[(int)valuesAffectedByTheta[i][2] - 1][(int)valuesAffectedByTheta[i][1]][1] = -2;
          }
        }
      }
      
      checkArray(distances, 1);
      
      println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    }
    
    println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    // Temporary visualisation of the First-stage aggregation (Will be removed after adding visualisation for the second-step aggregation)
    
    /*for (int i = 0; i < points_count - 1; i++) {
      for (int j = 0; j <= i; j++) {
        if (distances[i][j][1] > 0) line(points.get(i + 1).x, points.get(i + 1).y, points.get(j).x, points.get(j).y); // if the xij value is positive, I connect the corresponding points
      }
    }*/
    
    // Second-Stage Aggregation
    
    int[] connectionsCount = new int[points_count]; // Array to store number of connections each point has (just so it's easier to see how many connections each point has)
    
    for (int pointNumber = 0; pointNumber < points_count; pointNumber++) { // Scan all the points to count the connections
      if (pointNumber > 0) {
        for (int j = 0; j < pointNumber; j++) { // Check the Row of the point in the Xij array
          if (distances[pointNumber - 1][j][1] > 0) connectionsCount[pointNumber]++;
        }
      }
      if (pointNumber < points_count - 1) {
        for (int i = pointNumber; i < points_count - 1; i++) { // Check the Column of the point in the Xij array
          if (distances[i][pointNumber][1] > 0) connectionsCount[pointNumber]++;
        }
      }
    }
    
    println(connectionsCount); // check the array
    
    for (int pointNumber = connectionsCount.length - 1; pointNumber > 0; pointNumber--) { // Looking through all the points starting from P1
      if (connectionsCount[pointNumber] == 0) { // Finding points with 0 connections (if there are any)
        for (int i = 0; i < 2; i++) {
          int minConnection = findMinConnection(distances, connectionsCount, pointNumber);
          if (minConnection != -1) {
            println("P" + pointNumber + " should be connected to: P" + minConnection); // Check for debugging
            connectionsCount[minConnection]++;
            connectionsCount[pointNumber]++;
            if(minConnection < pointNumber) {
              distances[pointNumber - 1][minConnection][1] = 1.0;
            } else {
              distances[minConnection - 1][pointNumber][1] = 1.0;
            }
          }
        }
      }
    }
    
    for (int pointNumber = connectionsCount.length - 1; pointNumber > 0; pointNumber--) {
      if (connectionsCount[pointNumber] == 1) {
        int minConnection = findMinConnection(distances, connectionsCount, pointNumber);
        if (minConnection != -1) {
          println("P" + pointNumber + " should be connected to: P" + minConnection); // Check for debugging
          connectionsCount[minConnection]++;
          connectionsCount[pointNumber]++;
          if(minConnection < pointNumber) {
            distances[pointNumber - 1][minConnection][1] = 1.0;
          } else {
            distances[minConnection - 1][pointNumber][1] = 1.0;
          }
        }
      }
    }
    
    println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    checkArray(distances, 1);
    
    /*for (int i = 0; i < points_count - 1; i++) {
      for (int j = 0; j <= i; j++) {
        if (distances[i][j][1] > 0) line(points.get(i + 1).x, points.get(i + 1).y, points.get(j).x, points.get(j).y); // if the xij value is positive, I connect the corresponding points
      }
    }*/
    
    // Identifying the sequences
    
    List<List> sequences = new ArrayList<List>();
    
    for (int row = 0; row < points_count - 1; row++) {
      for (int column = 0; column <= row; column++) {
        if (distances[row][column][1] > 0) {
          List<Integer> sequence = new ArrayList<Integer>();
          sequence.add(column);
          sequence.add(row + 1);
          int pointNumber1 = column;
          int pointNumber2 = row + 1;
          boolean foundConnection = false;
          distances[pointNumber2 - 1][pointNumber1][1] = 0;
          do {
            for (int j = 0; j < pointNumber2; j++) {
              if (distances[pointNumber2 - 1][j][1] > 0) {
                sequence.add(j);
                pointNumber1 = j;
                distances[pointNumber2 - 1][pointNumber1][1] = 0;
                pointNumber2 = j;
                foundConnection = true;
                break;
              }
            }
              if (!foundConnection) { // If there was no connection found in the Row
              pointNumber1 = pointNumber2;
              for (int i = pointNumber1; i < points_count - 1; i++) { // Check the Column
                if (distances[i][pointNumber1][1] > 0) {
                  sequence.add(i + 1);
                  pointNumber2 = i + 1;
                  distances[i][pointNumber1][1] = 0;
                  foundConnection = true;
                  break;
                }
              }
            }
            if (!foundConnection) { // If there was no connection (second one) found in the Row and Column
              sequence.add(0);
              pointNumber1 = 0;
            }
            foundConnection = false;
          } while(pointNumber1 != column);
          sequences.add(sequence);
        }
      }
    }
    
    println(sequences);
    
    println("~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    // Fixing the "encircled" sequences
    
    for (int i = 0; i < sequences.size(); i++) {
      List<Integer> sequence = sequences.get(i);
      if (!sequence.contains(0)) {
        List<Integer> tempSequence = new ArrayList<Integer>(sequence); // The points are indexed by their distance to the recycling station. I want to connect the point closes to the recycling station and one which is connected to it that is closer to the recycling station. Due to the nature of the algorithm, the sequences start with the points closest to the recycling station and end with it. So I want to compare the point with indexes '1' and 'sequence.size() - 2' in the sequence which one of the indexes is lower (it will be a point closer to the recycling station)
        //println(tempSequence);
        sequence.clear();
        sequence.add(0); //<>//
        println(tempSequence);
        if (tempSequence.get(1) < tempSequence.get(tempSequence.size() - 2)) {
          for (int j = tempSequence.size() - 1; j > 0; j--) {
            sequence.add(tempSequence.get(j));
          }
        } else {
          for (int j = 0; j < tempSequence.size() - 1; j++) {
            sequence.add(tempSequence.get(j));
          }
        }
        sequence.add(0);
      }
      //sequences.add(i, sequence);
    }
    println(sequences);
    
    for (int i = 0; i < sequences.size(); i++) { // Visualisation of the pathes through sequences
      List<Integer> sequence = sequences.get(i);
      for (int j = 1; j < sequence.size(); j++) {
        int point1 = sequence.get(j - 1);
        int point2 = sequence.get(j);
        stroke(0); // Black color
        strokeWeight(15);
        line(points.get(point1).x, points.get(point1).y, points.get(point2).x, points.get(point2).y);
        stroke(107, 107, 107); // Light grey color
        strokeWeight(10);
        line(points.get(point1).x, points.get(point1).y, points.get(point2).x, points.get(point2).y);
        stroke(255, 255, 0); // Yellow Color
        strokeWeight(1);
        line(points.get(point1).x, points.get(point1).y, points.get(point2).x, points.get(point2).y);
        totalDistanceCovered += (float)Math.round(sqrt(pow(points.get(point1).x - points.get(point2).x, 2) + pow(points.get(point1).y - points.get(point2).y, 2)) * 1000) / 1000;;
      }
    }
    println("totalDistanceCovered: " + totalDistanceCovered);
    stroke(0);
    strokeWeight(1);
  }
  
  if (calculateCO2Button.checkMouse()) { // Functionality to the calculateCO2Button
    int metalRate = 8; // Recycling metal saves on average 8 kg of CO2 per 1 kg of metal (alluminium)
    int plasticRate = 3; // Recycling plastic saves on average 3 kg of CO2 per 1 kg of plastic
    int glassRate = 1; // Recycling glass saves on average 1 kg of CO2 per 1 kg of glass
    int massOfMetal = numberOfMetalBins * 45; // Every bin (240L) for recycling metal contains on average 45 kg of metal
    int massOfPlastic = numberOfPlasticBins * 35; // Every bin (240L) for recycling plastic contains on average 35 kg of plastic
    int massOfGlass = numberOfGlassBins * 50; // Every bin (240L) for recycling glass contains on average 50 kg of glass;
    
    metalSavedCO2 = metalRate * massOfMetal;
    plasticSavedCO2 = plasticRate * massOfPlastic;
    glassSavedCO2 = glassRate * massOfGlass;
    
    totalSavedCO2 = metalSavedCO2 + plasticSavedCO2 + glassSavedCO2;
    
    CO2InformationShown = true;
  }
  
  if (clearButton.checkMouse()) { // Functionality of the clearButton
    points.clear();
    points.add(new point());
    rect(20, 20, 1040, 500, 10); // Drawing a "map"
    numberOfMetalBins = 0;
    numberOfPlasticBins = 0;
    numberOfGlassBins = 0;
  }
  
  if (closeCO2InformationButton.checkMouse() && CO2InformationShown) { // Functionality of the closeCO2InformationButton
    rect(20, 20, 1040, 500, 10); // Drawing a "map"
    totalDistanceCovered = 0;
    CO2InformationShown = false;
  }
}
