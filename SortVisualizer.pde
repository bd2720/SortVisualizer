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
  QUICK      // quicksort
}

final int fps = 120; // passed to frameRate()
final String fontStr = "Consolas"; // contained in PFont.list()

final SortType sortingAlg = SortType.QUICK; // selected sorting method
final int arrSize = 256; // length of array

int[] array; // array of len integers, 1 -> len
float segWidth; // width / array.length

ArrayList<Pair> swaps; // arraylist of swaps made during the sort
ArrayList<Pair> comps; // arraylist of array element comparisons made

int currFrame; // consistent with "comps" ArrayList
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

// swaps elements at i/j
void swapInArray(int i, int j, int[] arr){
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
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
  boolean swapped;
  for(int i = 0; i < arr.length; i++){
    swapped = false;
    for(int j = 0; j < arr.length-i-1; j++){
      comps.add(new Pair(frame, j, j+1));
      if(arr[j] > arr[j+1]){
        swaps.add(new Pair(frame, j, j+1));
        swapInArray(j, j+1, arr);
        swapped = true;
      }
      frame++;
    }
    if(!swapped) return;
  }
}

void selectionSort(int[] arr){
  int frame = 0;
  int mindex; // index of minimum
  for(int i = 0; i < arr.length; i++){
    mindex = i;
    for(int j = i+1; j < arr.length; j++){
       comps.add(new Pair(frame, j, mindex));
       if(arr[j] < arr[mindex]){
         mindex = j;
       }
       frame++;
    }
    swaps.add(new Pair(frame-1, i, mindex));
    swapInArray(mindex, i, arr);
  }
}

void insertionSort(int[] arr){
  int frame = 0;
  for(int i = 1; i < arr.length; i++){
    for(int j = i; j > 0; j--){
      comps.add(new Pair(frame, j-1, j));
      frame++;
      if(arr[j-1] <= arr[j]) break;
      swaps.add(new Pair(frame-1, j-1, j));
      swapInArray(j-1, j, arr); 
    }
  }
}

int recur_frame; // need global frame counter due to recursion

int qs_partition(int arr[], int low, int high){
  int frame = recur_frame;
  int piv = arr[high]; // use last element as pivot
  int i = low; // swap elements here if lower than pivot
  for(int j = low; j < high; j++){
    comps.add(new Pair(frame, j, high));
    if(arr[j] <= piv){
      swaps.add(new Pair(frame, i, j));
      swapInArray(i, j, arr);
      i++;
    }
    frame++;
  }
  swaps.add(new Pair(frame-1, i, high));
  swapInArray(i, high, arr);
  recur_frame = frame; // update global frame count
  return i; // index of pivot
}

void qs_recur(int arr[], int low, int high){
  if(low >= high || low < 0) return;
  int mid = qs_partition(arr, low, high);
  qs_recur(arr, low, mid-1);
  qs_recur(arr, mid+1, high);
}

void quickSort(int arr[]){
  recur_frame = 0; // initialize global frame count
  qs_recur(arr, 0, arr.length-1);
}

// fill ArrayList of swaps and comps, running through desired sorting alg.
void simulateSort(int [] arr, SortType t){
  switch(t){
    case BUBBLE:
      bubbleSort(arr);
      break;
    case SELECTION:
      selectionSort(arr);
      break;
    case INSERTION:
      insertionSort(arr);
      break;
    case QUICK:
      quickSort(arr);
      break;
  }
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
  size(1280, 720);
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
  simulateSort(array.clone(), sortingAlg);
  
  currFrame = -1;
  swapsIndex = 0;
  
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
  
  // if swaps occur on this frame, do them
  while(swapsIndex < swaps.size()) {
    Pair currSwap = swaps.get(swapsIndex);
    if(currSwap.id == currFrame){
      swapInArray(currSwap.a, currSwap.b, array);
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
