final int arrSize = 40; // length of array
final int fps = 60; // passed to frameRate()

int[] array; // array of len integers, 1 -> len
float segWidth; // width / array.length

enum SortType {BUBBLE} // desired sorting algorithm

class Pair { // represents a record of a swap/comparison
  int id;
  int a; // first index
  int b; // second index
  Pair(int id, int a, int b){
    this.id = id;
    this.a = a;
    this.b = b;
  }
  Pair(){
    id = -1;
    b = a = 0;
  }
}

ArrayList<Pair> swaps; // arraylist of swaps made during the sort
ArrayList<Pair> comps; // arraylist of array element comparisons made

// allocate, fill and shuffle array using Processing's IntList
void initArray(){
  IntList il = new IntList(arrSize);
  int i;
  for(i = 0; i < arrSize; i++){
    il.set(i, i+1);
  }
  il.shuffle();
  array = new int[arrSize]; // dynamically allocate array
  for(i = 0; i < arrSize; i++){
    array[i] = il.get(i);
  }
}

// swaps elements at a pair of indices
void swapInArray(Pair p){
  int temp = array[p.a];
  array[p.a] = array[p.b];
  array[p.b] = temp;
}

void drawArray(){
  float segHeight; // segment height, based on value
  for(int i = 0; i < arrSize; i++){
    if(i % 2 == 0){
      fill(#efefef);
    } else {
      fill(#cfcfcf);
    }
    segHeight = array[i] * (height / (float)arrSize);
    rect(i*segWidth, height-segHeight, segWidth, segHeight);
  }
}

void drawPair(Pair p){
  float segHeight; // segment height, based on value
  int a = p.a;
  int b = p.b;
  
  if(a % 2 == 0){
    fill(#ef0000);
  } else {
    fill(#cf0000);
  }
  segHeight = array[a] * (height / (float)arrSize);
  rect(a*segWidth, height-segHeight, segWidth, segHeight);
  if(b % 2 == 0){
    fill(#ef0000);
  } else {
    fill(#cf0000);
  }
  segHeight = array[b] * (height / (float)arrSize);
  rect(b*segWidth, height-segHeight, segWidth, segHeight);
}

// fill ArrayList of swaps
void bubbleSort(int[] arr) {
  int frame = 0; // iteration counter
  int temp;
  int n = arr.length;
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n-i-1; j++){
      if(arr[j] > arr[j+1]){
        temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
        swaps.add(new Pair(frame, j, j+1));
      }
      comps.add(new Pair(frame, j, j+1));
      frame++;
    }
  }
}
// fill ArrayList of swaps and comps, running through desired sorting alg.
void simulateSort(int [] arr, SortType t){
  switch(t){
    case BUBBLE:
      bubbleSort(arr);
      break;
  }
}

int currFrame; // should be synced with "comps" ArrayList
int swapsIndex; // current index into "swaps" ArrayList

void displayStats() {
  // display stats
  fill(#ffffff);
  textSize(30);
  text("comparisons: " + (currFrame+1), 10, 30);
  text("swaps: " + (swapsIndex), 10, 70);
}

// generic indexOf() for arrays
int findString(String[] strings){
  for(int i = 0; i < strings.length; i++){
    if(strings[i].equals("Consolas")) return i;
  }
  return -1;
}

void setup(){
  size(800, 600);
  frameRate(fps);
  rectMode(CORNER);
  stroke(#000000);
  // try to load consolas font
  if(findString(PFont.list()) != -1){
    textFont(createFont("Consolas", 32));
  }
  
  segWidth = width / (float)arrSize; // segment width
  swaps = new ArrayList<Pair>();
  comps = new ArrayList<Pair>();
  
  initArray();
  simulateSort(array.clone(), SortType.BUBBLE);
  
  currFrame = -1;
  swapsIndex = 0;
  
  background(#000000);
  drawArray();
  
  displayStats();
  currFrame++;
}

void draw(){
  // end sketch if no more comparisons (sorted)
  if(currFrame >= comps.size()){
    noLoop();
    // draw final array
    background(#000000);
    drawArray();
    currFrame--;
    displayStats();
    return;
  }
  
  // draw array
  background(#000000);
  drawArray();
  
  // draw the current comparison in red
  // don't need to check if inbounds, since noLoop() occurs
  Pair currComp = comps.get(currFrame);
  drawPair(currComp);
  
  // display stats
  displayStats();
  
  // if a swap occurs on this frame, do it
  if(swapsIndex < swaps.size()){
    Pair currSwap = swaps.get(swapsIndex);
    if(currSwap.id == currFrame){
      swapInArray(currSwap);
      swapsIndex++;
    }
  }
  currFrame++; 
}

boolean paused;

void keyPressed(){
  if(key == ' '){
    if(paused){
      loop();
    } else {
      noLoop(); 
    }
    paused = !paused;
  }
}
