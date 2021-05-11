#this script will run exponential smoothing on the data set

#set working directory
rm(list=ls())
setwd("E:\\Storage\\Sch\\KE5108\\CA3")
path <- ('E:\\Storage\\Sch\\KE5108\\CA3\\oil.price.dat.txt')

#set package used
library(tidyverse)
library(fpp2)
library(ggplot2)
library(ggfortify)
library(scales)
library(forecast)

#import file
mydata <- read.table(path,header = TRUE, sep=" ")

#set as timeseries
myts <- ts(mydata$oil.price, start = c(1986,1), frequency = 12)
length(myts)

#There are 241 data observations in total.
#We will use the last 12 data observations as the test data set.
myts_training_12 <- ts(myts[174:229],start=c(2000,1), frequency = 12)
myts_test_12 <- ts(myts[230:241], start=c(2005,1), frequency = 12)

#We will use the last 6 data observations as the test data set.
myts_training_6 <- ts(myts[174:234],start=c(2000,1), frequency = 12)
myts_test_6 <- ts(myts[235:241], start=c(2005,7), frequency = 12)

#Step 1: Plot time series
autoplot(myts) + scale_y_continuous(labels = comma) + 
  xlab("Time Series (Yearly)") + ylab("Oil Price") + ggtitle("Monthly Oil Price")

#step 2: decompose the data
autoplot(decompose(myts))

#step 3B: from the decompose plot we observed some seasonality, hence we will be using Holt-winter exponential.
myts_hw6 <- HoltWinters(myts_training_6)
myts_hw6

#Step 4B: plot to see the fit of the model
plot(myts_hw6)
#Step 5B: forcast for next 6 months
myts_hw6_forecast <- forecast(myts_hw6, h=6)
#Step 6B: plot the forecast
plot(myts_hw6_forecast)
#step 7B: check RMSE
error <- myts_hw6_forecast$mean - myts_test_6
RMSE_hw6 <- sqrt(mean(error^2))

