library(serial)
#
# Script
#

# Set up serial connection
con <- serialConnection(name = "test_con",
                        port = "COM8",
                        mode = "9600,n,8,1",
                        buffering = "none",
                        newline = 1,
                        translation = "cr")

# Measure the sensors (up to three) with intensity 0 and register the voltage values
newText <- ""
colbreaks <- c(seq(1,256, length=257)) #add the last point

image(matrix(as.matrix(training[3,17:2]*0), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
open(con)
Sys.sleep(2)
newText <- read.serialConnection(con)
c(as.numeric(substr(newText, 3, 6)), as.numeric(substr(newText, 8, 11)), as.numeric(substr(newText, 13, 16)))
# print(newText)
# cat("\r\n", newText, "\r\n")
close(con)

v0b <- as.numeric(substr(newText, nchar(newText)-13, nchar(newText)-10))
v1b <- as.numeric(substr(newText, nchar(newText)-8, nchar(newText)-5)) 
v2b <- as.numeric(substr(newText, nchar(newText)-3, nchar(newText)-0))  

# Measure the sensors (up to three) with intensity 256 and register the voltage values
image(matrix(as.matrix(training[3,17:2]*0+256), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
open(con)
Sys.sleep(2)
newText <- read.serialConnection(con)
c(as.numeric(substr(newText, 2, 5)), as.numeric(substr(newText, 7, 10)), as.numeric(substr(newText, 12, 15)))
# print(newText)
# cat("\r\n", newText, "\r\n")
close(con)

v0t <- as.numeric(substr(newText, nchar(newText)-13, nchar(newText)-10))
v1t <- as.numeric(substr(newText, nchar(newText)-8, nchar(newText)-5)) 
v2t <- as.numeric(substr(newText, nchar(newText)-3, nchar(newText)-0))  

# Define the slope (Not used)
# v0slope <- v0b-v0t
# v1slope <- v1b-v1t
# v2slope <- v2b-v2t

# Measure the sensors (up to three) with intensity of the split at node 1 and register the voltage values
image(matrix(as.matrix(training[3,17:2]*0+33), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
open(con)
Sys.sleep(2)
newText <- read.serialConnection(con)
c(as.numeric(substr(newText, 3, 6)), as.numeric(substr(newText, 8, 11)), as.numeric(substr(newText, 13, 16)))
# print(newText)
# cat("\r\n", newText, "\r\n")
close(con)

v133 <- as.numeric(substr(newText, nchar(newText)-8, nchar(newText)-5)) 


# Measure the sensors (up to three) with intensity of the split at node 2 and register the voltage values
image(matrix(as.matrix(training[3,17:2]*0+26), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
open(con)
Sys.sleep(2)
newText <- read.serialConnection(con)
c(as.numeric(substr(newText, 3, 6)), as.numeric(substr(newText, 8, 11)), as.numeric(substr(newText, 13, 16)))
# print(newText)
# cat("\r\n", newText, "\r\n")
close(con)

v226 <- as.numeric(substr(newText, nchar(newText)-3, nchar(newText)-0))  

# Measure the sensors (up to three) with intensity of the split at node 0 and register the voltage values
image(matrix(as.matrix(training[3,17:2]*0+46), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
open(con)
Sys.sleep(2)
newText <- read.serialConnection(con)
c(as.numeric(substr(newText, 3, 6)), as.numeric(substr(newText, 8, 11)), as.numeric(substr(newText, 13, 16)))
# print(newText)
# cat("\r\n", newText, "\r\n")
close(con)

v037 <- as.numeric(substr(newText, nchar(newText)-13, nchar(newText)-10))

# Reference values
# 6 < 33 (voltage1)
# 1.4 for 0 - 0.7 for 176 - 1.45 for 38 (1.4 just to be sure)
# 3 >= 26 (voltage2)
# 3.5 for 0 - 0.61 for 176 - 3.47 for 23
# 10 >= 37 (voltage)
# 3.92 for 0 - 1.08 for 176 - 3.94 for 38

# Try to identify the first 200 records and fill the confusion matrix
newText <- ""
conf <- matrix(0,10,10)
last <- 1
for(i in last:200) {
  last <- i
  image(matrix(as.matrix(training[i,17:2]), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[i,1], breaks=colbreaks)
  Sys.sleep(1)

  open(con)
  Sys.sleep(3)
  newText <- read.serialConnection(con)
  c(as.numeric(substr(newText, 2, 5)), as.numeric(substr(newText, 7, 10)), as.numeric(substr(newText, 12, 15)))
  # print(newText)
  # cat("\r\n", newText, "\r\n")
  close(con)
  print(c((substr(newText, nchar(newText)-13, nchar(newText)-10)), round((1-(((as.numeric((substr(newText, nchar(newText)-13, nchar(newText)-10)))-v0t)/v0slope)))*256)))
  print(c((substr(newText, nchar(newText)-8, nchar(newText)-5)), round((1-(((as.numeric((substr(newText, nchar(newText)-8, nchar(newText)-5)))-v1t)/v1slope)))*256)))
  print(c((substr(newText, nchar(newText)-3, nchar(newText)-0)), round((1-(((as.numeric((substr(newText, nchar(newText)-3, nchar(newText)-0)))-v2t)/v2slope)))*256)))
  if(as.numeric((substr(newText, nchar(newText)-8, nchar(newText)-5)))>v133){
    print("Looks like a 1")
    if(as.numeric(as.character(factor(training[i,1])))==1){
    print("It is a 1!")
      conf[1,1] <- conf[1,1] +1
    }
    else{
      print("Not really :o(")
      conf[1,as.numeric(as.character(factor(training[i,1])))] <- conf[1,as.numeric(as.character(factor(training[i,1])))] + 1
    }
  } else
  {
    if(as.numeric((substr(newText, nchar(newText)-3, nchar(newText)-0)))<v226){
        if(as.numeric((substr(newText, nchar(newText)-13, nchar(newText)-10)))<v037){
          print(c("Looks like a 7 and it's a ", as.numeric(as.character(factor(training[i,1])))))
          conf[7,as.numeric(as.character(factor(training[i,1])))] <- conf[7,as.numeric(as.character(factor(training[i,1])))] + 1
        } else
      {
        print(c("Looks like a 4 and it's a ", as.numeric(as.character(factor(training[i,1])))))
        conf[4,as.numeric(as.character(factor(training[i,1])))] <- conf[4,as.numeric(as.character(factor(training[i,1])))] + 1
      }
      }    else
    {
      print(c("Looks like I don't know much"))
      conf[10,as.numeric(as.character(factor(training[i,1])))] <- conf[10,as.numeric(as.character(factor(training[i,1])))] + 1
    }
  }
  print(last)
#  Sys.sleep(3)
  
}

  

# Verify the response of the sensors (optional)
v0m <- matrix(0,nrow=256, ncol=4)
for(i in 99:256){
  image(matrix(as.matrix(training[3,17:2]*0+30), nrow=4), col=gray.colors(256, rev = TRUE, start = 0, end = 1), xlab = training[3,1], breaks=colbreaks)
  open(con)
  Sys.sleep(2)
  newText <- read.serialConnection(con)
  c(as.numeric(substr(newText, 3, 6)), as.numeric(substr(newText, 8, 11)), as.numeric(substr(newText, 13, 16)))
  # print(newText)
  # cat("\r\n", newText, "\r\n")
  close(con)
  v0m[i,1] <- i
  v0m[i,2] <- as.numeric(substr(newText, nchar(newText)-13, nchar(newText)-10))
  v0m[i,3] <- as.numeric(substr(newText, nchar(newText)-8, nchar(newText)-5)) 
  v0m[i,4] <- as.numeric(substr(newText, nchar(newText)-3, nchar(newText)-0))  
  
}


# Plot the response of the sensors
plot( v0m[,1], v0m[,2], col="red" , xlab = "Time [s]", ylab="Voltage [V]", xlim = c(1, 56), ylim = c(2.5,4), pch=19)
par(new=TRUE)
plot( v0m[,1], v0m[,3], col="green" , xlab = "Time [s]", ylab="Voltage [V]", xlim = c(1, 56), ylim = c(2.5,4), pch=19 )
par(new=TRUE)
plot( v0m[,1], v0m[,4], , col="blue"  , xlab = "Time [s]", ylab="Voltage [V]", xlim = c(1, 56), ylim = c(2.5,4), pch=19)
legend(50, 3.75, legend=c("Pixel 10", "Pixel 3", "Pixel 6"),
       col=c("red", "blue", "green"), pch=19, cex=0.8,
       title="Signals", text.font=4, bg='lightblue')
rect(0, 3.52, 50, 3.52, col = "red", border = "red") # coloured
rect(0, 3.04, 50, 3.04, col = "blue", border = "blue") # coloured
rect(0, 2.85, 50, 2.85, col = "green", border = "green") # coloured
