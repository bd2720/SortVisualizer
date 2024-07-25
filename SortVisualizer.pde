/*
    SortVisualizer.pde: simulates and displays swaps and comparisons for a given sorting algorithm.
*/

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

// desired sorting algorithm
enum SortType {
  BUBBLE,    // bubble sort
  SELECTION, // selection sort
  INSERTION, // insertion sort
  QUICK,     // quicksort
  HEAP       // heapsort
}

// passed to windowResize() in setup()
final int screenWidth = 1280;
final int screenHeight = 720;

final int fps = 60; // passed to frameRate()
final String fontStr = "Consolas"; // contained in PFont.list()

final SortType sortingAlg = SortType.QUICK; // selected sorting method
final int arrSize = 32; // length of array

int[] array; // array of len integers, 1 -> len
float segWidth; // width / array.length

ArrayList<Pair> swaps; // arraylist of swaps made during the sort
ArrayList<Pair> comps; // arraylist of array element comparisons made

int currFrame; // current frame (0/1 comps and 0/m swaps per frame)
int endFrame;  // frame AFTER the last operation (comp and/or swap)
int compsIndex; // current index into "comps" ArrayList
int swapsIndex; // current index into "swaps" ArrayList

boolean paused;

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

// wrapper for a comparison that stores it in comps
boolean compInArrayLT(int i, int j, int[] arr, int frame){
  comps.add(new Pair(frame, i, j));
  return arr[i] < arr[j];
}
boolean compInArrayGT(int i, int j, int[] arr, int frame){
  comps.add(new Pair(frame, i, j));
  return arr[i] > arr[j];
}

// swaps elements at i/j (+ record in swaps)
void swapInArray(int i, int j, int[] arr, int frame){
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
  swaps.add(new Pair(frame, i, j));
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
int bubbleSort(int[] arr) {
  int frame = 0; // iteration counter
  boolean swapped;
  for(int i = 0; i < arr.length; i++){
    swapped = false;
    for(int j = 0; j < arr.length-i-1; j++){
      if(compInArrayGT(j, j+1, arr, frame)){
        swapInArray(j, j+1, arr, frame);
        swapped = true;
      }
      frame++;
    }
    if(!swapped) break;
  }
  return frame;
}

int selectionSort(int[] arr){
  int frame = 0;
  int mindex; // index of minimum
  for(int i = 0; i < arr.length; i++){
    mindex = i;
    for(int j = i+1; j < arr.length; j++){
       if(compInArrayLT(j, mindex, arr, frame)){
         mindex = j;
       }
       frame++;
    }
    swapInArray(mindex, i, arr, frame-1);
  }
  return frame;
}

int insertionSort(int[] arr){
  int frame = 0;
  for(int i = 1; i < arr.length; i++){
    for(int j = i; j > 0; j--){
      frame++;
      if(compInArrayGT(j, j-1, arr, frame-1)) break;
      swapInArray(j-1, j, arr, frame-1); 
    }
  }
  return frame;
}

int recur_frame; // need global frame counter due to recursion

int qs_partition(int arr[], int low, int high){
  int frame = recur_frame;
  int pivdex = high; // use last element as pivot
  int i = low; // swap elements here if lower than pivot
  for(int j = low; j < high; j++){
    if(compInArrayGT(pivdex, j, arr, frame)){
      swapInArray(i, j, arr, frame);
      i++;
    }
    frame++;
  }
  swapInArray(i, high, arr, frame-1);
  recur_frame = frame; // update global frame count
  return i; // index of pivot
}

void qs_recur(int arr[], int low, int high){
  if(low >= high || low < 0) return;
  int mid = qs_partition(arr, low, high);
  qs_recur(arr, low, mid-1);
  qs_recur(arr, mid+1, high);
}

int quickSort(int arr[]){
  recur_frame = 0; // initialize global frame count
  qs_recur(arr, 0, arr.length-1);
  return recur_frame;
}

// turn array into max heap
// returns new current frame
int hp_heapify(int arr[], int frame){
  for(int i = 1; i < arr.length; i++){
    int j = i;
    int p = (j-1)/2; // parent index
    while(p != j){
      if(compInArrayLT(p, j, arr, frame)){
        swapInArray(p, j, arr, frame);
      } else {
        frame++;
        break;
      }
      j = p;
      p = (j-1)/2;
      frame++;
    }
  }
  return frame;
}

int hs_siftDown(int arr[], int heapSize, int frame){
  int i = 0; // starts as root (parent)
  int cMax; // index of max child
  while(i < heapSize){
    int c1 = 2*i + 1; // child node 1
    if(c1 >= heapSize) break;
    int c2 = c1 + 1;  // child node 2
    if(c2 >= heapSize){ // left-child-only case
      if(compInArrayGT(c1, i, arr, frame)){
        swapInArray(c1, i, arr, frame); 
      }
      frame++;
      break;
    }
    // find max child
    cMax = compInArrayGT(c2, c1, arr, frame) ? c2 : c1;
    frame++;
    // swap with MAX child if it's bigger
    if(compInArrayGT(cMax, i, arr, frame)){
      swapInArray(cMax, i, arr, frame);
      i = cMax;
      frame++;
    } else { // no swap (sifted down)
      frame++;
      break;
    }
  }
  return frame;
}

int heapSort(int arr[]){
  int frame = 0;
  // heapify array (max heap)
  frame = hp_heapify(arr, frame);
  // swap to back and sift down n-1 times
  for(int i = arr.length-1; i > 0; i--){
    swapInArray(i, 0, arr, frame);
    frame++;
    frame = hs_siftDown(arr, i, frame);
  }
  return frame;
}

// fill ArrayList of swaps and comps, running through desired sorting alg.
// returns final frame count
int simulateSort(int [] arr, SortType t){
  switch(t){
    case BUBBLE:
      return bubbleSort(arr);
    case SELECTION:
      return selectionSort(arr);
    case INSERTION:
      return insertionSort(arr);
    case QUICK:
      return quickSort(arr);
    case HEAP:
      return heapSort(arr);
  }
  return 0;
}

void displayStats() {
  // display stats
  fill(#ffffff);
  textSize(24);
  text("sort: " + sortingAlg, 8, 24);
  text("size: " + arrSize, 8, 48);
  text("comparisons: " + (currFrame+1), 8, 72);
  text("swaps: " + (swapsIndex), 8, 96);
}

void displayPause(){
  fill(#9f9f9f);
  textSize(30);
  text("PAUSED (press space)", 10, 150);
}

// generic indexOf() for arrays
int findString(String[] strings, String str){
  for(int i = 0; i < strings.length; i++){
    if(strings[i].equals(str)) return i;
  }
  return -1;
}

void setup(){
  size(800, 600);
  windowResize(screenWidth, screenHeight);
  frameRate(fps);
  rectMode(CORNER);
  background(#000000);
  stroke(#000000);
  
  // try to load font
  if(findString(PFont.list(), fontStr) != -1){
    textFont(createFont(fontStr, 32));
  }
  
  segWidth = width / (float)arrSize; // segment width
  swaps = new ArrayList<Pair>();
  comps = new ArrayList<Pair>();
  
  initArray();
  endFrame = simulateSort(array.clone(), sortingAlg);
  
  currFrame = -1;
  compsIndex = 0;
  swapsIndex = 0;
  
  drawArray();
  
  displayStats();
  
  currFrame++;
}

void draw(){
  // end sketch if no more comparisons (sorted)
  if(currFrame == endFrame){
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
  
  // draw the current comparison in red, if there is one
  // don't need to check if inbounds, since noLoop() occurs
  // assuming 0 or 1 comparisons per frame
  if(compsIndex < comps.size()){
    Pair currComp = comps.get(compsIndex);
    if(currComp.id == currFrame){
      drawPair(currComp);
      compsIndex++;
    }
  }
  
  // display stats
  displayStats();
  
  // if swaps occur on this frame, do them
  while(swapsIndex < swaps.size()) {
    Pair currSwap = swaps.get(swapsIndex);
    if(currSwap.id == currFrame){
      int temp = array[currSwap.a];
      array[currSwap.a] = array[currSwap.b];
      array[currSwap.b] = temp;
      swapsIndex++;
    } else {
      break; 
    }
  }
  currFrame++; 
}

void keyPressed(){
  if(key == ' '){ // pause/unpause on space pressed
    if(paused){
      loop();
    } else {
      noLoop(); 
    }
    paused = !paused;
  }
}
