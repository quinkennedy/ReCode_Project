/**
 * This sketch is part of the ReCode Project - http://recodeproject.com
 * Computer Graphics and Art – Nov, 1976 – Vol. 1, No. 4 – Pg 6
 * 
 * "Generative Drawings"
 * by Manfred Mohr
 *
 * direct recode by Quin Kennedy 2012
 *
 * Copyright (c) 2012 Quin Kennedy
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

static final int cellWidth = 30;
static final int boxSize = 7;
static int numEdges = 9;
static final int cubeEdges = 12;
static final int numUnique = factorial(cubeEdges)/(factorial(numEdges)*factorial(cubeEdges-numEdges));
static final int numCellsWide = ceil(sqrt(numUnique));
static final int gutterWidth = 10;
static final int canvasWidth = numCellsWide*cellWidth+gutterWidth*2;
static final boolean showMirror = true;
static final boolean closerMatch = true;

public static final int factorial(int n){
  int output = 1;
  for(;n>0; n--){
    output *= n;
  }
  return output;
}

void setup(){
  size(canvasWidth * (showMirror ? 2 : 1), canvasWidth, P3D);
  noLoop();
}

void draw(){
  background(0);
  noFill();
  stroke(255);
  strokeWeight(1.5);
  ortho();
  drawGrid();
  drawSet();
  if (showMirror){
    translate(width/2, 0, 0);
    drawGrid();
    numEdges = cubeEdges-numEdges;
    drawSet();
  }
}

void drawSet(){
  pushMatrix();
  int currCubeEdges = (closerMatch ? initCubeFlags() : 0);
  float rX = PI/3;//random(TWO_PI);
  float rY = 0;//random(TWO_PI);
  float rZ = PI*2/3;//random(TWO_PI);
  translate(gutterWidth+cellWidth/2., numCellsWide*cellWidth+gutterWidth-cellWidth/2., 0);
  for(int i = 0; i < numCellsWide; i++){
    pushMatrix();
    for(int j = 0; j < numCellsWide; j++){
      pushMatrix();
      rotateX(rX);
      rotateY(rY);
      rotateZ(rZ);
      scale(boxSize);
      if (closerMatch){
        drawCube(currCubeEdges);
        currCubeEdges = getNextCube(currCubeEdges);
      } else {
        for(;currCubeEdges <= 0xfff; currCubeEdges++){
          if (numFlags(currCubeEdges) == numEdges){
            drawCube(currCubeEdges);
            currCubeEdges++;
            break;
          }
        }
      }
      popMatrix();
      translate(0, -cellWidth, 0);
    }
    popMatrix();
    translate(cellWidth, 0, 0);
  }
  popMatrix();
}

int numFlags(int f){
  int output = 0;
  while(f > 0){
    if ((f & 1) == 1){
      output++;
    }
    f >>= 1;
  }
  return output;
}

void drawGrid(){
  int currX = gutterWidth;
  for(int i = 0; i <= numCellsWide; i++, currX += cellWidth){
      line(currX, gutterWidth, currX, numCellsWide*cellWidth+gutterWidth);
      line(gutterWidth, currX, numCellsWide*cellWidth+gutterWidth, currX);
  }
}

int initCubeFlags(){
  int firstFlags = 0;
  for(int i = 0; i < numEdges; i++){
    firstFlags <<= 1;
    firstFlags++;
  }
  return firstFlags;
}

int getNextCube(int sideFlags){
  return incrementFlags(sideFlags, cubeEdges-1);
}

int incrementFlags(int sideFlags, int lastValidIndex){
  int myMask = 1;
  int bitMask = 1;
  for(int i = 1; i <= lastValidIndex; i++){
    bitMask <<= 1;
    myMask <<= 1;
    myMask++;
  }
  if ((sideFlags & bitMask) > 1){
    //if there are no flags below us, we are done, return 0;
    if ((sideFlags & (myMask >> 1)) == 0){
      return 0;
    }
    //move the flags below us
    int nextFlags = incrementFlags(sideFlags, lastValidIndex-1);
    //if we receive 0, we are done with the whole series
    if (nextFlags == 0){
      return 0;
    }
    //otherwise reset our flag to directly after theirs
    while(bitMask > 0 && (nextFlags & (bitMask >> 1)) == 0){
      bitMask >>= 1;
    }
    return (nextFlags | bitMask);
  } else {
    //move this flag up by one position
    //find where the flag is
    while(bitMask > 0 && (sideFlags & (bitMask >> 1)) == 0){
      bitMask >>= 1;
    }
    //mask my section, remove the current flag and add the new flag
    return (((sideFlags & myMask) ^ (bitMask >> 1)) | bitMask);
  }
}

void drawCube(int sideFlags){
  if (closerMatch){
    if ((sideFlags & 0x1) != 0){
      line(1, -1, -1, 1, 1, -1);
    }
    if ((sideFlags & 0x2) != 0){
      line(1, 1, 1, 1, -1, 1);
    }
    if ((sideFlags & 0x4) != 0){
      line(-1, -1, 1, -1, 1, 1);
    }
    if ((sideFlags & 0x8) != 0){
      line(-1, -1, -1, 1, -1, -1);
    }
    if ((sideFlags & 0x10) != 0){
      line(1, -1, -1, 1, -1, 1);
    }
    if ((sideFlags & 0x20) != 0){
      line(-1, -1, 1, 1, -1, 1);
    }
    if ((sideFlags & 0x40) != 0){
      line(-1, -1, -1, -1, -1, 1);
    }
    if ((sideFlags & 0x80) != 0){
      line(-1, -1, -1, -1, 1, -1);
    }
    if ((sideFlags & 0x100) != 0){
      line(-1, 1, -1, 1, 1, -1);
    }
    if ((sideFlags & 0x200) != 0){
      line(1, 1, 1, 1, 1, -1);
    }
    if ((sideFlags & 0x400) != 0){
      line(1, 1, 1, -1, 1, 1);
    }
    if ((sideFlags & 0x800) != 0){
      line(-1, 1, -1, -1, 1, 1);
    }
  } else {
    if ((sideFlags & 0x1) != 0){
      line(-1, -1, -1, -1, -1, 1);
    }
    if ((sideFlags & 0x2) != 0){
      line(-1, -1, -1, -1, 1, -1);
    }
    if ((sideFlags & 0x4) != 0){
      line(-1, -1, -1, 1, -1, -1);
    }
    if ((sideFlags & 0x8) != 0){
      line(1, 1, 1, 1, 1, -1);
    }
    if ((sideFlags & 0x10) != 0){
      line(1, 1, 1, 1, -1, 1);
    }
    if ((sideFlags & 0x20) != 0){
      line(1, 1, 1, -1, 1, 1);
    }
    if ((sideFlags & 0x40) != 0){
      line(-1, -1, 1, 1, -1, 1);
    }
    if ((sideFlags & 0x80) != 0){
      line(-1, -1, 1, -1, 1, 1);
    }
    if ((sideFlags & 0x100) != 0){
      line(-1, 1, -1, 1, 1, -1);
    }
    if ((sideFlags & 0x200) != 0){
      line(-1, 1, -1, -1, 1, 1);
    }
    if ((sideFlags & 0x400) != 0){
      line(1, -1, -1, 1, 1, -1);
    }
    if ((sideFlags & 0x800) != 0){
      line(1, -1, -1, 1, -1, 1);
    }
  }
}
