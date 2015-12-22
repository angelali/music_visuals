import ddf.minim.*;
import ddf.minim.analysis.*;

static int SIZE = 16;

int[] palette = {#999999, #aaaaaa, #bbbbbb, #cccccc};

Minim minim;
AudioInput in;
BeatDetect beat;

boolean orientation;
int cellSize;
float rotation;

void setup()
{
  size(400, 400); // Width and height must be equal!
  
  minim = new Minim(this);  
  in = minim.getLineIn(Minim.STEREO, (SIZE * SIZE));
  beat = new BeatDetect();
  
  cellSize = width / SIZE; 
  rotation = 0;
}

void draw()
{
  beat.detect(in.mix);
  
  background(0);  
  noStroke();

  rectMode(CENTER);  
  translate(cellSize / 2, cellSize / 2);  
            
  for (int i = 0; i < (SIZE * SIZE); i++) {
   // Get size and position of cell based on the current sample in the buffer
   int squareDim = floor(in.mix.get(i) * (cellSize * 0.75));
    
   int div = i / SIZE;
   int mod = i % SIZE;
   int xPos, yPos;
    
   if (orientation) {
     xPos = div;
     yPos = mod;
   } 
   else {
     xPos = mod;
     yPos = div;
   }
    
   int squareX = xPos * cellSize;
   int squareY = yPos * cellSize;
    
   // Get color of cell
   int cellColor = floor(map(i, 0, SIZE * SIZE, 0, palette.length - 1)); 
   //fill(palette[cellColor]);

   fill(255, 255);
    
   // Draw the cell!
   pushMatrix();
   translate(squareX, squareY);  
   rotate((rotation / 360) * TWO_PI);
   rect(0, 0, squareDim, squareDim);
   popMatrix();
  }
  
  // Update rotation
  rotation = (rotation + 3) % 360;     
  
  // Update orientation
  if (beat.isOnset()) {
    orientation = !orientation;
  }
}