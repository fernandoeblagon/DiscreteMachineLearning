The goal of this task is to evaluate the best model for a discrete component object recognition system.

The first task would be to obtain a reference. Typical MNIST classifiers are well below 5% error rate (https://en.wikipedia.org/wiki/MNIST_database#Classifiers). We'll use a reference random forest, with no pre-processing on our reduced dataset.

Benchmark model

The dataset was reduced using the tools shown in https://hackaday.io/project/170591/log/175172-minimum-sensor and evaluated using the same metrics from the previous task.
