import deadpixel.command.Command;
Command cmd;

static final String APP = "python ";
static final String FILE = "importreplicate.py";

PrintWriter output;

import processing.serial.*;
PImage photo;
Serial myPort;  // Create object from Serial class
String val, realval;     // Data received from the serial port

void setup() {

  String portName = Serial.list()[3]; //for serial communication between teensy and processing
  myPort = new Serial(this, portName, 115200); //remember baudrate
  size(1000, 600);
  realval = "A high quality dslr photo, of a lion, with the head of a horse, and with the olor of a zebra, and with a tail of a monkey, with a full body picture";
  photo = loadImage("test.png");
  final String path = dataPath(FILE);
  cmd = new Command(APP + path);
  println(cmd.command, ENTER);
  cmd.run();
  println("Successs:", cmd.success);
  printArray(cmd.getOutput());
  output = createWriter("sentence.txt");
}

void draw() {
  if ( myPort.available() > 0)
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if (val.indexOf("dslr") >= 0) { //or else try indexof
      realval = val;
    }
    delay(100);
  }
  print(val);
  
  background(200);
  imageMode(CENTER);
  image(photo, width/2, height/2);
  textAlign(CENTER);
  textSize(15);
  fill(0, 0, 0);
  text(realval, width/2, (49*height)/50);
}
void mouseClicked() {
  output.println(realval); // Write the coordinate to the file
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  photo = loadImage("test.png");
  final String path = dataPath(FILE);
  cmd = new Command(APP + path);
  println(cmd.command, ENTER);
  cmd.run();
  println("Successs:", cmd.success);
  printArray(cmd.getOutput());
}
