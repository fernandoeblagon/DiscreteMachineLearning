library(doParallel)
library(Thermimage)
library(caret)
library(rpart)
library(rpart.plot)

# Enable parallel processing.
cl <- makeCluster(detectCores())
registerDoParallel(cl)

# Define containers
train <- data.frame()
test <- data.frame()

# Load data.
load_mnist()

# Variable definition
pix = 7 # This is the number by which the original 28 x 28 matrix will be divided 
ro = 30000 # Number of points in the dataset, maximum 60000
mu <- matrix(, nrow = ro, ncol = (28/pix)^2) # Define the data matrix
pu <- train$y[1:ro] # Define the response matrix

# Function to reduce the pixel density by [pix]
avpicLinear <- function (pic, pix) {
  a <- matrix(, nrow = 28/pix, ncol = 28/pix)
  d = 28/pix
  for (i in 1:d) {
    for (j in 1:d) {
      s = i*pix-(pix-1)
      t = i*pix
      u = j*pix-(pix-1)
      v = j*pix
      a[i,j] = mean(matrix(train$x[pic,], nrow=28)[,28:1][s:t,u:v])
    }
  }
  as.vector(mirror.matrix(a))
}


# Reduce the matrix. Progress bar to go and make coffee
pb <- txtProgressBar(min = 0, max = ro, style = 3)
for (i in 1:ro) {
  mu[i,] <- avpicLinear(i,pix)
  setTxtProgressBar(pb, i)
}

# Setup training data with digit and pixel values with 60/40 split for train/cv.
inTrain = data.frame(y=pu, mu)
inTrain$y <- as.factor(pu)
trainIndex = createDataPartition(pu, p = 0.60,list=FALSE)
training = inTrain[trainIndex,]
cv = inTrain[-trainIndex,]

# Train Decision tree
fitt2s30k <- rpart(y~., data = head(training, 10000), method = 'class', cp=0.01)
rpart.plot(fitt2s30k, extra = 103, roundint=FALSE, box.palette="RdYlGn", dev.set(4))

# Predict test using test portion of dataset
predict_unseen <-predict(fitt2s30k,cv, type = 'class')

# Create and display confusion table
table_mat2s30k <- table(cv$y, predict_unseen)
table_mat2s30k

#Define accuracy function
accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, cv, type = 'class')
  table_mat <- table(cv$y, predict_unseen)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  accuracy_Test
}

# Calculate accuracy
accuracy_tune(fitt2s30k)

# Calculate accuracy for individual digits
diag(table_mat2s30k)/apply(table_mat2s30k,1,sum)
