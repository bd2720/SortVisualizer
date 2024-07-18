# SortVisualizer #  
A simple visualization tool for sorting algorithms.  
  
*ABOUT*  
The application sorts a shuffled array of integers using a given sorting algorithm.  
The x-position of each animated segment represents an index, and the segment's height is proportional to the array's current value at that index.  
The comparison made on each frame is highlighted in red.  
If a comparison on a given frame results in a swap, the swap displays on the following frame.  
Number of swaps and number of comparisons are displayed as the animation plays.  
Press the spacebar to pause/unpause to application.  
  
*OPTIONS*  
  arrSize: size of array to sort, containing numbers from 0 to size-1 at random locations.  
  sortingAlg: enum representing the sorting algorithm to be performed on the array.  
  fps: frames per second, where a frame is (generally) one iteration of the sorting algorithm's inner loop.  

*SORTING ALGORITHMS*  
  SortType.BUBBLE (bubble sort)  
  SortType.SELECTION (selection sort)  
  SortType.INSERTION (insertion sort)  
  
