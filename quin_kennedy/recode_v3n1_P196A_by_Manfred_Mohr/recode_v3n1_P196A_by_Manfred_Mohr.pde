/**
 * This sketch is part of the ReCode Project - http://recodeproject.com
 * Computer Graphics and Art – Feb, 1978 – Vol. 3, No. 1 – Pg 9
 * 
 * "P-196A"
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

static final int boxSize = 300;
static final int canvasSize = 600;

void setup(){
  size(canvasSize, canvasSize, P2D);
  noLoop();
}

void draw(){
translate(width/2, height/2, 0);
PGraphics topLight = createGraphics(width, height, P3D);
PGraphics bottomLight = createGraphics(width, height, P3D);
PGraphics topHeavy = createGraphics(width, height, P3D);
PGraphics bottomHeavy = createGraphics(width, height, P3D);
float rX = random(TWO_PI);
float rY = random(TWO_PI);
float rZ = random(TWO_PI);
drawBox(topLight, rX, rY, rZ, 1, 255);
drawBox(topHeavy, rX, rY, rZ, 4, 252);
rX = random(TWO_PI);
rY = random(TWO_PI);
rZ = random(TWO_PI);
drawBox(bottomLight, rX, rY, rZ, 1, 255);
drawBox(bottomHeavy, rX, rY, rZ, 4, 252);

copy(topLight, 0, 0, width, height/2, 0, 0, width, height/2);
copy(bottomLight, 0, height/2, width, height/2, 0, height/2, width, height/2);
int pX = (width-boxSize)/2;
int pY = (height-boxSize)/2;
int cW = boxSize;
int cH = boxSize/2;
copy(topHeavy, pX, pY, cW, cH, pX, pY, cW, cH);
pY += boxSize/2;
copy(bottomHeavy, pX, pY, cW, cH, pX, pY, cW, cH);
line(0, height/2, width, height/2);
}

void drawBox(PGraphics g, float rotX, float rotY, float rotZ, float weight, int backgroundColor){
  g.beginDraw();
  g.ortho();
  g.translate(width/2, height/2, 0);
  g.rotateX(rotX);
  g.rotateY(rotY);
  g.rotateZ(rotZ);
  g.background(backgroundColor);
  g.stroke(0);
  g.strokeWeight(weight);
  g.noFill();
  g.box(boxSize);
  g.endDraw();
}
