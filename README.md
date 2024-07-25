# SortVisualizer  
SortVisualizer is a simple visualization tool for sorting algorithms.  
  
## About   
Sorts a shuffled array of integers using a specified sorting algorithm.  
The x-position of each segment represents an index, and the segment's height is proportional to the array's current value at that index.  
The comparison (if present) made on each frame is highlighted in red.  
If a comparison on a given frame results in any swaps, they will display on the following frame.  
Number of swaps and number of comparisons are displayed as the animation plays.  
Press the spacebar to pause/unpause.  
  
## Options 
  ``sortingAlg`` - SortType value representing the sorting algorithm to be performed on the array.  
  ``arrSize`` - size of array to sort, containing numbers from 0 to size-1 at random locations.  
  ``fps`` - frames per second, where a frame is (generally) one iteration of the sorting algorithm's inner loop.  
  ``size(<width>, <height>)`` - width and height of the window in pixels. (first line of ``setup()``)  

## Sorting Algorithms
```
enum SortType {
  BUBBLE,    // bubble sort
  SELECTION, // selection sort
  INSERTION, // insertion sort
  QUICK,     // quicksort
  HEAP,      // heapsort
  BOGO,      // bogosort
}
```
