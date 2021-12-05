# Marketing-Mix-Model
Simple marketing mix model exploring sales as a function of media spend. 
Demo: https://www.youtube.com/watch?v=WSF941rR6jE

# Introduction
Advertisers use marketing mix models, also known as media mix models, to measure the effectiveness of various advertising channels on improving a metric [1], such as sales or return on investment (ROI). These models use time series data to model an outcome resulting from advertising variables, usually marketing or media spend [1]. <Br>

The purpose of this project is to explore building a marketing mix model using simulated weekly marketing and sales data. The model will attempt to predict a change in sales volume based on changes in spend for TV and paid search advertisements.

# Data
The data for this model was generated using the Aggregate Marketing System Simulator (AMASS) [4], an open source R package provided by Google, Inc for research purposes. Code was obtained from [Google GitHub](https://github.com/google/amss/blob/master/vignettes/amss-vignette.Rmd) [2].

[R Code](https://github.com/deejayrusso/Marketing-Mix-Model/blob/main/Data%20Generation%20-%20AMSS.R)<br>
[Simulated Data](https://github.com/deejayrusso/Marketing-Mix-Model/blob/main/ObservedData.csv)

Variables used:<br>
* <b>tv.spend:</b> Weekly dollar spend on TV advertisement 
* <b>search.spend: </b> Weekly dollar spend on paid search advertisement
* <b>revenue: </b> Weekly dolllar sales

The AMASS was used to generate 208 rows representing 4 years of weekly data. The first 52 rows were dropped to allow the simulator time to normalize and produce more consistent data. The next 52 rows were dropped after feature engineering to remove null values produced after shifting data to create lag variables, leaving 104 rows representing 2 years. 
  
# Method
  Ordinary least squares regressions, a polynomial regression, and multiple regularized regression models are explored to see which predicts sales based on tv and search advertising spend with the lowest error. 

<b>Steps and contents:</b>
1. Generate data and loadsimulated data.<br>
2. Explore data<br>
3. Select features and target variable for models<br>
4. Feature engineering: Lag variables and rolling averages for marketing spend.<br>
5. Prepare data for model training and testing<br>
6. Create data pipeline<br>
7. Calculate baseline metrics<br>
8. Explore regression models<br>
    * Ordinary least squares<br>
    * Polynomial<br>
    * Lasso<br>
    * Ridge<br>
    * Elastic net<br>
    * Stochastic gradient<br>
9. Compare models and select best model<br>
10. Interpret findings<br>
  
# Summary 
Of the models explored, four were very similar in terms of lowest error. The ordinary linear regression with lag variables (lin_reg_lag), elastic net (elastic_net), stochastic gradient descent (SGD), lasso regression (lasso), and ridge regression (ridge) models all had RMSE of approximately 7.1 million and  MAPE around 5%.

The "best" of those models is lasso as it has the lowest RMSE in addition to having a low test MAPE and low variation between test and train MAPE. The exact interpretation of this data warrants further investigation due to the nature of the Yeo-Johnson transformation used, which handles negative and positive values differently during the transformation [3]. However, as expected, it does appear there is a positive relationship between advertising spend and revenue based on the beta coefficients produced.
  
# Conclusion
Marketing mix models have been used by advertisers for decades to measure how effective their advertising campaigns are [1]. However, there are challenges in using these models to produce reliable estimates, extending those estimates to infer causation (not just correlation), and parameterizing the models in a way that accounts for complex marketing interactions such as carryover (lag) and diminishing returns [1].

Of the eight models explored here, four models were extremely similar in terms of error reduction with the lasso regression model being slightly better than the others. Unfortunately, interpretability of the model is not straightforward due to the Yeo-Johnson power transformations that were used to normalize the data. 

Areas for future improvement include:
* Full interpretation of applying the model to guide decision making
    * Further research into Yeo-Johnson transformations
    * Explore using more easily explained transformations (ie: log, square-root, etc.) if error is not increased
* Exploring the use of an ensemble model
    * Create additional model for lag effects of advertising
    * Create additional model for diminishing returns on advertising spend
    * A base sales model could also be used to simulate lift over base sales
    * Stack additional models with media mix model to explore modeling more complex interactions
* Dashboard or web application for stakeholder interface
    * Deploy model with user interface once models are acceptable for production
    * Options could include using a Model-View-Control (MVC) framework in C# or Model-Template-View (MTV) framework in  python (Django)
    * User interface should allow for input of spend scenarios to simulate revenue outcomes to help stakeholders optimize marketing budgets across channels
        * This will help inform decisions to fund each channel sufficiently without overspending past the point of diminishing returns
    * Interface could also use data entry fields to add new actual spends and revenue to keep data current on a weekly basis
 
# Sources
[1] Chan, D., & Perry, M. (2017). Challenges and opportunities in media mix modeling. https://services.google.com/fh/files/misc/challenges_and_opportunities_in_media_mix_modeling.pdf

[2] Google, Inc. (2017) Google AMSS GitHub page. https://github.com/google/amss/blob/master/vignettes/amss-vignette.Rmd

[3] Yeo, I.-K., & Johnson, R. A. (2000). A New Family of Power Transformations to Improve Normality or Symmetry. Biometrika, 87(4), 954–959. http://www.jstor.org/stable/2673623

[4] Zhang, S. and Vaver, J. (2017). The Aggregate Marketing System Simulator.
*[https://research.google.com/pubs/pub45996.html](https://research.google.com/pubs/pub45996.html)*.

