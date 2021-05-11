#set working directory
rm(list=ls())
setwd("D:\\Storage\\Sch\\KE5108\\CA3")
path <- ('D:\\Storage\\Sch\\KE5108\\CA3\\oil.price.dat.txt')

#import file
mydata <- read.table(path,header = TRUE, sep=" ")

#set as timeseries
myts <- ts(mydata$oil.price, start = c(1986,1), frequency = 12)
length(myts)

#There are 241 data observations in total.
#We will use the last 12 data observations as the test data set.
myts_training_12 <- ts(myts[1:229],start=c(1986,1), frequency = 12)
myts_test_12 <- ts(myts[230:241], start=c(2005,1), frequency = 12)

#We will use the last 6 data observations as the test data set.
myts_training_6 <- ts(myts[1:234],start=c(1986,1), frequency = 12)
myts_test_6 <- ts(myts[235:241], start=c(2005,7), frequency = 12)

#Step 1: Plot time series
library(ggplot2)
library(ggfortify)
library(scales)
autoplot(myts) + scale_y_continuous(labels = comma) + 
  xlab("Time Series (Yearly)") + ylab("Oil Price") + ggtitle("Monthly Oil Price")

autoplot(decompose(myts))

#Step 2A: Examine stationary assumption
#a. Examine stationariy using ADF test or PP test
#b. Take difference of the original data if not stationary

# ADF test
#install.packages("fUnitRoots")
library(fUnitRoots)
adfTest(myts_training_12)
adfTest(diff(myts_training_12))

ts.plot(diff(myts_training_12), main = "Differenced Monthly Oil Price",
        xlab = "time", ylab = "Oil Price", col = "blue", lwd = 2,type = "b")

#Step 3A: Determine modelling parameters
#a. ACF plot for MA order
#b. PACF plot for AR order

#Create ACF and PACF plots by using "astsa" package
library(astsa)
acf2(diff(myts_training_12)[1:length(diff(myts_training_12))],main="ACF and PACF Plots for Differenced Data") #To show the actual lags 

#We can select the difference and lag order based on information criterion as well.
library(forecast)
tsmodel_12 <- auto.arima(myts_training_12, approximation = FALSE,stepwise = FALSE ) #To return the best ARIMA model according to either AIC or BIC value.
summary(tsmodel_12)

#Step 4A: Estimate modelling coefficients 
#Fit the model using "astsa" package
library(astsa)
sarima(myts_training_12,2,1,0)

tsmodel_12_manual <- arima(myts_training_12,order = c(1,1,1))
summary(tsmodel_12_manual)

#Step 5A: Predict future values using auto arima's model as it is a better model
fcast_12 <- forecast(tsmodel_12, level = c(95), h = 12)
autoplot(fcast_12)

#Calculate prediction error using RMSE:
error <- fcast_12$mean - myts_test_12
RMSE_12 <- sqrt(mean(error^2))
RMSE_12

#manually test the 6 months (aug 2005 onwards) prediction for report comparison
error_manual <- fcast_12$mean[7:12] - myts_test_12[7:12]
RMSE_12_manual_6 <- sqrt(mean(error_manual^2))


########################################################################################
#Step 2B: Examine stationary assumption
#a. Examine stationariy using ADF test or PP test
#b. Take difference of the original data if not stationary

# ADF test
#install.packages("fUnitRoots")
library(fUnitRoots)
adfTest(myts_training_6)
adfTest(diff(myts_training_6))

ts.plot(diff(myts_training_6), main = "Differenced Monthly Oil Price",
        xlab = "time", ylab = "Oil Price", col = "blue", lwd = 2,type = "b")

#Step 3B: Determine modelling parameters
#a. ACF plot for MA order
#b. PACF plot for AR order

#Create ACF and PACF plots by using "astsa" package
library(astsa)
acf2(diff(myts_training_6)[1:length(diff(myts_training_6))],main="ACF and PACF Plots for Differenced Data") #To show the actual lags 

#We can select the difference and lag order based on information criterion as well.
library(forecast)
tsmodel_6 <- auto.arima(myts_training_6,approximation = FALSE,stepwise = FALSE) #To return the best ARIMA model according to either AIC or BIC value.
summary(tsmodel_6)

#Step 4B: Estimate modelling coefficients 
#Fit the model using "astsa" package
library(astsa)
sarima(myts_training_6,4,1,1)

tsmodel_6_manual <- arima(myts_training_6,order = c(1,1,1))
summary(tsmodel_6_manual)

#Step 5B: Predict future values
fcast_6 <- forecast(tsmodel_6_manual, level = c(95), h = 6)
autoplot(fcast_6)

#Calculate prediction error using RMSE:
error <- fcast_6$mean - myts_test_6
RMSE_6 <- sqrt(mean(error^2))
RMSE_6