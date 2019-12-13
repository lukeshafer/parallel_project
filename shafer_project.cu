/*
 *  Parallel Implementaion of Hough Transform for Circle Detection in images
 *
 *  by Luke Shafer
 *  https://github.com/lukeshafer/parallel_project
 *
 *  nvcc shafer_project.cu -lm -lGL -lGLU -lglut
 */

#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main( void ) {

    Mat image = imread("/users/PES0798/lshafer/parallel_project/MoonOriginal.jpg");

     // Check for failure
    if (image.empty()) 
    {
        cout << "Could not open or find the image" << endl;
        cin.get(); //wait for any key press
        return -1;
    }

    String windowName = "The moon"; //Name of the window

    namedWindow(windowName); // Create a window

    imshow(windowName, image); // Show our image inside the created window.

    waitKey(0); // Wait for any keystroke in the window

    destroyWindow(windowName); //destroy the created window

    return 0;

}
