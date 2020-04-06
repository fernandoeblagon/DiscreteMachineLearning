library(caret)
library(doParallel)
library(e1071)
library(rpart)
library(rpart.plot)
library(randomForest)
library(Thermimage)
library(shinyjs)

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


# Random forest training
fitRF <- train(y ~ ., data = head(training, 10000), method = 'rf')

# Random forest prediction using validation data
results <- predict(fitRF, newdata = head(cv, 10000))

# Create confusion matrix
ConRF <- confusionMatrix(results, head(cv$y, 10000))

# Display overall and individual vales accuracy
ConRF$overall
diag(ConRF$table)/apply(ConRF$table,1,sum)


#Decsion tree
fitt2s30k <- rpart(y~., data = head(training, 30000), method = 'class', cp=0.04)
rpart.plot(fitt2s30k, extra = 103, roundint=FALSE, box.palette="RdYlGn", dev.set(4))
dev.new()
# image(matrix(as.matrix(training[24,17:2]), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1))

predict_unseen <-predict(fitt2s30k,cv, type = 'class')
table_mat2s30k <- table(cv$y, predict_unseen)
table_mat2s30k
accuracy_tune(fitt2s30k)
diag(table_mat2s30k)/apply(table_mat2s30k,1,sum)


# Test cp values
cpM <- matrix(0,nrow=40, ncol=2)
for (i in seq(from=1, to=20)) {
  fitt2s30k <- rpart(y~., data = head(training, 30000), method = 'class', cp=0.1/(i*10))
  predict_unseen <-predict(fitt2s30k,cv, type = 'class')
  table_mat2s30k <- table(cv$y, predict_unseen)
  cpM[i,1] <- 0.1/(i*10)
  cpM[i,2] <- accuracy_tune(fitt2s30k)
  
}
plot(cpM)


# Function to calculate overall accuracy
accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, cv, type = 'class')
  table_mat <- table(cv$y, predict_unseen)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  accuracy_Test
}


# Plot test digits
for(i in 1:100) {
  colbreaks <- c(seq(1,256, length=257)) #add the last point
  image(matrix(as.matrix(training[i,17:2]), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[i,1], breaks=colbreaks)
  Sys.sleep(3)
  
}

# Draw single dataset record
record <- 2
training[record,]
colbreaks <- c(seq(1,256, length=257)) #add the last point
image(matrix(as.matrix(training[record,17:2]), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[record,1], breaks=colbreaks)
