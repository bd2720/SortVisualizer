final int arrSize = 40; // length of array
int[] array; // array of len integers, 1 -> len

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

void drawArray(){
  rectMode(CORNER);
  noStroke();
  int segWidth = width / arrSize; // segment width
  int segHeight; // segment height, based on value
  for(int i = 0; i < arrSize; i++){
    if(i % 2 == 0){
      fill(#efefef);
    } else {
      fill(#cfcfcf);
    }
    segHeight = array[i] * (height / arrSize);
    rect(i*segWidth, height-segHeight, segWidth, segHeight);
  }
}

void drawSwap(){
  int segWidth = width / arrSize; // segment width
  int segHeight; // segment height, based on value
  
  if(swap1 % 2 == 0){
      fill(#ef0000);
    } else {
      fill(#cf0000);
    }
    segHeight = array[swap1] * (height / arrSize);
    rect(swap1*segWidth, height-segHeight, segWidth, segHeight);
    if(swap2 % 2 == 0){
      fill(#ef0000);
    } else {
      fill(#cf0000);
    }
    segHeight = array[swap2] * (height / arrSize);
    rect(swap2*segWidth, height-segHeight, segWidth, segHeight);
}

int bubble_i = -1;
int bubble_j = -1;
int bubble_temp;

int swap1;
int swap2;
boolean swapped;

void bubbleSort(int[] arr, int n) {
  int temp;
  for(int i = 0; i < n; i++){
    for(int j = i+1; j < n-i; j++){
      if(arr[i] > arr[i+1]){
        temp = arr[i];
        arr[i] = arr[i+1];
        arr[i+1] = temp;
      }
    }
  }
}

// single iteration of bubbleSort
// returns true if bubbleSort is finished.
boolean bubbleSortIter(int[] arr, int n){
  swapped = false;
  if(bubble_i == -1){ // initialize i if uninitialized
    bubble_i = 0;
  }
  if(bubble_i < n){ // outer loop cond true
    if(bubble_j == -1){ // initialize j if uninitialized
      bubble_j = 0;
    }
    if(bubble_j < n - bubble_i - 1){ // inner loop cond true
      if(arr[bubble_j] > arr[bubble_j+1]){ // SWAP
        bubble_temp = arr[bubble_j];
        arr[bubble_j] = arr[bubble_j+1];
        arr[bubble_j+1] = bubble_temp;
        swap1 = bubble_j;
        swap2 = bubble_j+1;
        swapped = true;
      }
      bubble_j++; // inner loop inc
      return false;
    } else { // inner loop cond false
      bubble_j = -1; // uninitialize j
    }
    bubble_i++; // outer loop inc
    return false;
  } else { // outer loop cond false
    bubble_i = -1; // uninitialize i
  }
  return true; // list is sorted when outer loop breaks
}

void setup(){
  size(800, 600);
  frameRate(60);
  
  initArray();
  background(#000000);
  drawArray();
}

void draw(){
  if(bubbleSortIter(array, arrSize)){
    noLoop();
  }
  background(#000000);
  drawArray(); //<>//
  if(swapped) drawSwap();
  
  fill(#ffffff);
  textSize(50);
  text(frameCount/frameRate, 0, 50);
}
