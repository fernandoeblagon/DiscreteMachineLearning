# DiscreteMachineLearning
MNIST object recognition using discrete components

This project takes a lean approach to object recognition inspired by a recent paper from Mennel et. al., published in the March 2020 issue of Nature. 

The goal of this project is to make a discrete component "machine" that will recognize digist from the MNIST dataset with an error rate lower than 25%.

The project is divided into 4 tasks.
   1. Determine minimum requirements for sensor array
   1. Determine minimum requirements for ML model
   1. Determine minimum requirements for object recognition hardware
   1. Prototyping and final design
   
The directory structure is built around the tasks defined above.

## Project tools
The tools used in thsi project are as follows:
   * Rstudio - This was used for loading the MNIST database, test the sensor array requirements, compare ML models and create a tool to display MNIST dataset with different pixel density.
   * Arduino IDE - Used to create the prototype and test assumptions
   * Circuit Simulator version 2.2.12js. [http://www.falstad.com/circuit/](http://www.falstad.com/circuit/)
   
# Acknowledgement

Below is a list of the giant's shoulders I remembered to reference. Sorry if there are more which this work relied upon and did not get referenced. Please inform me if you see part of your code above unreferenced and I'll correct the list below.

* Loading the MNIST dataset onto R and training with an SVM, https://gist.github.com/primaryobjects/b0c8333834debbc15be4
* RStudio Team (2015). RStudio: Integrated Development for R. RStudio, Inc., Boston, MA URL http://www.rstudio.com/.
* Nature's paper, https://www.nature.com/articles/s41586-020-2038-x
* Progress bar, https://ryouready.wordpress.com/2009/03/16/r-monitor-function-progress-with-a-progress-bar/
* Plotting and calculations on Decision trees, https://www.guru99.com/r-decision-trees.html
* OCR acceptance level, https://ocrsolutions.com/typical-field-acceptance-rate-ocr-accuracy-level/
