# Time Series Analysis on Oil prices

## Business Understanding
#### The world has seen the increase in oil prices over a period of 20 years from January 1986 to January 2006 and in this project, we will perform time series forecasting to predict the trend for the next 12 months from data up to January 2005. To work on a shorter term forecast, we will also predict the trend of oil prices for the next 6 months from data up to July 2005.

Figure 1: Trend in oil price data (Jan 1986 - Dec 2004)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/Dataplot.jpeg" width="800" height="480">

Figure 2: Decompoosition of oil prices

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/decomposedata.jpeg" width="800" height="480">

#### From the plots in Figure 2, we observed an increasing trend in the dataset. There was a seasonality component in the dataset. Next, we explored different time series methods before determining the best algorithm to use for this set of data. We would predict (a) the next 12 months of oil prices (Feb 2005 - Jan 2006) and (b) the next 6 months of oil price from (Aug 2005 - Jan 2006).

## Modeling
### Exponential Smoothing

#### Since there was seasonality in the data, we used Holt-Winters exponential smoothing for the modeling. The table shows the smoothing parameters for (a) 12 months (b) 6 months

Table 1: Holt-Winters Parameters
| Parameter | (a) 12 Months | (b) 6 Months |
| --------- | ------------- | ------------ |
| Alpha     | 0.89          | 0.89         |
| Beta      | 0.008         | 0.008        |
| Gamma     | 1             | 1            |

#### As alpha value was high, this indicated that more weights were assigned to more recent values. The low beta value meant that less emphasis was given to compare recent data trend with older trends. Also, a high gamma parameter meant that more weight was given to seasonal component. Both (a) and (b) model plots show that data points were more affected by recent events than historical events. 

Figure 3.1: Holt-Winters Training Plot (12 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/HW_12_Model.jpeg" width="800" height="480">

Figure 3.2: Holt-Winters Training Plot (6 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/HW_6_Model.jpeg" width="800" height="480">

Table 2: RMSE Holt-Winters Model
| Forecasted Result | (a) 12 Months | (b) 6 Months |
| ----------------- | ------------- | ------------ |
| RMSE              | 11.44         | 5.96         |

Figure 4.1: Holt-Winters Forecasted Plot (12 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/HW_12_fcast.jpeg" width="800" height="480">

Figure 4.2: Holt-Winters Forecasted Plot (6 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/HW_6_fcast.jpeg" width="800" height="480">

#### From the RMSE result of (a), exponential smoothing may not give a good prediction if the forecast was too far from the known data. A simple RMSE test was done by predicting 6 months instead of 12 months for (a) shows the RMSE drop by nearly 50% (11.44, 12 months) vs (6.33, 6 months). 

### Autoregressive Integrated Moving Average (ARIMA)

#### Before applying ARIMA model, we tested for stationarity of the data. We conducted an Augmented Dickery-Fuller (ADF) test on the training dataset for (a) and (b).

Table 3: ADF statistic
| | (a) 12 Months | | (b) 6 Months | |
| --- | --- | --- | --- | --- |
|   |No Differencing | 1 Differencing |No Differencing | 1 Differencing |
| Dickey-Fuller | 0.5114 | -11.216 | 1.0367 | -11.3078 |
| P-Value | 0.7789 | < 0.01 | 0.9182 | < 0.01 |

#### From the test, we noted that the training data in (a) and (b) was not stationary as the P-value was higher than 0.05. This implied that the time series had a unit root and was not stationary. We proceeded to do first order differencing on the data and the end result was that both (a) and (b) satisfied the stationarity requirement. Next, we examined the AutoCorrelation Function (ACF) and Partial AutoCorrelation Function (PACF) plot of both (a) and (b) to determine the lag order.

Figure 5.1: ACF and PACF plot (12 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/ACF_PACF_12.jpeg" width="800" height="480">

Figure 5.2: ACF and PACF plot (6 Months)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/ACF_PACF_6.jpeg" width="800" height="480">

#### From the PACF values, we estimated the lag for AutoRegression (AR) component in both (a) and (b). In the PACF plot of (a) and (b), first significant lag occured at 1 and we chose AR(1) model. The ACF values of both (a) and (b) occurred at lag 1,hence we concluded an ARIMA(1,1,1) model for both (a) and (b). However, we noted that the significance did not fall steadily with increasing lag, this suggests that there might be other AR component that is more significant. We ran Auto ARIMA to give us a rough parameters of an optimised ARIMA model. Auto ARIMA returns ARIMA (1,1,1) model for (a) and ARIMA(4,1,1) model for (b). We will compare the parameters determined by us ARIMA(1,1,1) against the suggested model by auto arima in R.

Figure 6: ACF of Residuals, Normal Probability and Ljung Box Test P-values Plots (ARIMA (1,1,1), 12 Months forcast plot)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/111_12.jpeg" width="800" height="480">

#### From the above plot, ACF and Ljung-Box test residuals that were not significantly correlated, indicating model fitted well to the data. The normal plot of residuals showed a linear trend indicating that the normality assumption was satisfied. Both auto-arima in R and our suggested parameters agrees for part (a)

Figure 7: ACF of Residuals, Normal Probability and Ljung Box Test P-values Plots (ARIMA (4,1,1), 6 Months forcast plot)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/411_6.jpeg" width="800" height="480">

Figure 8: ACF of Residuals, Normal Probability and Ljung Box Test P-values Plots (ARIMA (1,1,1), 6 Months forcast plot)
<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/ARIMA111_6.jpeg" width="800" height="480">

#### From the above Ljung-Box test residual p-value plots, ARIMA(4,1,1) seem to have a better evaluation plot than ARIMA(1,1,1) despite both models’s ACF residuals showing goodness of fit. The normal plot of residuals showed a linear trend which meant that normality condition was met. However, given that ARIMA(4,1,1) have an AR(4) component, the model is rather complicated compared to ARIMA(1,1,1) model. Since ARIMA(1,1,1) evaluation plot shows that it is an adequate model, we will proceed to use ARIMA(1,1,1) for 6 months forecast.

Table 4: RMSE ARIMA model
| Forecasted Result | (a) 12 Months | (b) 6 Months |
| ----------------- | ------------- | ------------ |
| RMSE              | 12.71         | 5.30         |

### Decomposition Method

#### In this section, we applied addictive and multiplicative decomposition method to perform time series forecasting.

#### For the first run, we used data up to January 2005 to fit the model. In Figure 9, we can observe the trend and seasonality of our data extracted using multiplicative model.

Figure 9: Multiplicative Model

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/Multimodel.png" width="800" height="480">

#### The same data are fitted to additive model and it gave us different trend and seasonality information as shown in Figure 10.

Figure 10: Additive Model

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/AddModel.png" width="800" height="480">

#### Once the seasonality and trend was extracted, missing values for the trend was imputed with linear interpolation. Trend and seasonality were used to estimate the target Y. Once the target was forecasted, we validated it. 

#### The RMSE results for the combination of decomposition method with 2 different training sets were below.

Table 5: Decomposition Results
| Forecasted Result | Additive | Multiplicative |
| ----------------- | ------------- | ------------ |
| 12 Months           | 2.28        | 2.27        |
| 6 Months           | 2.32       | 2.31        |

### Time Series Regression

#### We ran a time series regression model to predict the values for (a) 12 months forecast and (b) 6 months forecast. We performed a loop of 10 degrees and identified the lowest RMSE. 

Table 6: Regression Results
| | 12 Months | | | 6 Months | | |
| --- | --- | --- | --- | --- | --- | --- |
| Degree | RMSE | AIC | BIC | RMSE | AIC | BIC |
| 0 | 7.20 | 1555.85 | 1559.28 | 8.65 |1683.21 | 1686.67 |
| 1 | 5.59 | 1442.42 | 1449.28 | 6.56 |1555.11 | 1562.03 |
| 2 | 4.80 | 1374.48 | 1384.78 | 5.29 |1456.06 | 1466.44 |
| 3 | 3.97 | 1289.60 | 1303.34 | 4.08 |1335.31 | 1349.15 |
| 4 | 3.97 | 1291.42 | 1308.59 | 4.04 |1332.61 | 1349.90 |
| 5 | 3.96 | 1292.52 | 1313.12 | 3.98 |1328.39 | 1349.15 |
| 6* | 3.77 | 1271.77 | 1295.81 | 3.74 |1301.18 | 1325.40 |
| 7 | 5.40 | 1433.97 | 1454.57 | 5.35 |1466.81 | 1487.57 |
| 8 | 6.54 | 1521.87 | 1542.48 | 6.48 |1557.40 | 1578.16 |
| 9 | 7.80 | 1600.49 | 1617.66 | 7.75 |1639.05 | 1656.34 |

#### From the table, we observed that degree 6 had the lowest RMSE, AIC and BIC which made it the best model parameter to fit both (a) and (b). 

Figure 11.1: Training Model (12 Months)

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/Train12.png" width="400" height="240">

Figure 11.2: Training Model ( 6 Months)

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/Train6.png" width="400" height="240">

Figure 12.1: Test Model (12 Months)

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/fcast12.png" width="400" height="240">

Figure 12.2: Test Model ( 6 Months)

<img src="https://github.com/alannqt/R_TimeSeries/blob/master/img/fcast6.png" width="400" height="240">

Table 7: RMSE Regression model
| Forecasted Result | (a) 12 Months | (b) 6 Months |
| ----------------- | ------------- | ------------ |
| RMSE              | 5.73       | 6.73         |

#### Based on the plot, we noted that we might have over fitted the data. The test RMSE performed better than exponential smoothing and ARIMA for 12 months prediction. In addition, the model performance worsened in presence of downward trend as the polynomial degree was fixed. The model might be better suited for long term than short term predictions. 

## Optimised Model (Holt-Winters with modified dataset)

#### While it was important to use historical data to train the model, we noted that the data in the 1980s had a different trend from more recent data. This was supported by the fact that most models concluded that recent data had more weightage than historical data. Thus, we performed forecasting using data from 2000 onwards as we saw an exponential increase in overall trend starting from 2000. We used ARIMA and Exponential Smoothing to forecast 6 months data (Aug 2005 to Jan 2006) as we see a forecast of 12 months data seems to have a larger error and it would be best to shorten the forecasting period. 

#### For ARIMA, we observed the ACF and PACF plot and manually obtained a model ARIMA(5,1,0) (auto arima - ARIMA(5,1,0)) The RMSE of both models were as follows. 

Table 8: RMSE optimised model
| 6 Months | ARIMA (5,1,0) | Holt-Winters (0.65,0.10,1) |
| ----------------- | ------------- | ------------ |
| RMSE              | 0.28       | 1.27         |

#### Although ARIMA(5,1,0) had a significantly lower RMSE, it was a more complicated model than Holt-Winters as the AR component was 5. Given that Holt-Winters’ with revised dataset outperforms any other methods (decomposition / time series regression) and a comparable RMSE difference against the ARIMA model, Holt-Winters result was preferred.

## Deployment

#### We noted the importance of obtaining optimised parameters (e.g. alpha, beta, gamma of Holt-Winters with the training data) and doing model evaluation with training and testing data set. However, to deploy the model, we should include test data and retrain the final model using the full set of the data. RMSE scoring should be built to monitor the model performance and if necessary retrain the whole model if the performance falls below a user set target.

## Conclusion

#### From the methods used, both exponential smoothing and ARIMA demonstrated that predicted values were highly dependent on recent values. Using exponential smoothing and ARIMA models, the RMSE of the 6 months forecast was lower than 12 months forecast. While for decomposition and time series regression, a 12 months forecast yields a lower RMSE. This might suggest that oil prices tends to fluencates in the short term, while over a long period the overall trend is consistent.

#### In addition, we noted that having more data did not necessarily yield better model performance. As shown in the optimised model (3.5), we greatly improved the result of ARIMA and Holt-Winters by removing data before 2000. We posit that current world economics is vastly different from the past due to the emergence of technology. Hence, we decided to remove some historical data and leave enough for training. Finally, given today’s economic outlook a much better model will be a rolling window time series algorithm. As we have discovered in this exercise, recency of the data plays a huge part in getting good prediction and rolling windows continues to be trained on new data that was provided.


Author: Ng Qing Ting
Co- Author: Mohamed Dhameem Mohamed
