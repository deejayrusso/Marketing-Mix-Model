# Use devtools to pull amss library from Google's GitHub
install.packages('devtools')
library(devtools)

# Install Aggregate Marketing System Simulator (amss) library from Google's GitHub
install_github('google/amss')
library(amss)

# Simulate 4 years of weekly data
n.years <- 4
time.n <- n.years * 52


# Define Natural behavior of consumer in absence of marketing intervention
# Activity transition: Each consumer has 60%/30%/10% chance of entering the
# inactive/exploratory/purchase states at the beginning of each time interval.

activity.transition <- matrix(
  c(0.60, 0.30, 0.10,  # migration originating from inactive state
    0.60, 0.30, 0.10,  # exploratory state
    0.60, 0.30, 0.10),  # purchase state
  nrow = length(kActivityStates), byrow = TRUE)

# Define percent change of entering different favorability state:
favorability.transition <- matrix(
  c(0.03, 0.07, 0.65, 0.20, 0.05,  # migration from the unaware state
    0.03, 0.07, 0.65, 0.20, 0.05,  # negative state
    0.03, 0.07, 0.65, 0.20, 0.05,  # neutral state
    0.03, 0.07, 0.65, 0.20, 0.05,  # somewhat favorable state
    0.03, 0.07, 0.65, 0.20, 0.05),  # favorable state
  nrow = length(kFavorabilityStates), byrow = TRUE)


# Define seasonality:

# Sinusoidal pattern:
market.rate.nonoise <-
  SimulateSinusoidal(n.years * 52, 52,
                     vert.trans = 0.6, amplitude = 0.25)
# Added noise:
market.rate.seas <- pmax(
  0, pmin(1,
          market.rate.nonoise *
            SimulateAR1(length(market.rate.nonoise), 1, 0.1, 0.3)))

# Natural migration parameters:
nat.mig.params <- list(
  population = 2.4e8,
  market.rate.trend = 0.68,
  market.rate.seas = market.rate.seas,
  # activity states for newly responsive (in-market & un-satiated)
  prop.activity = c(0.375, 0.425, 0.2),
  # brand favorability, initial proportions.
  prop.favorability = c(0.03, 0.07, 0.65, 0.20, 0.05),
  # everyone is a switcher
  prop.loyalty = c(1, 0, 0),
  transition.matrices = list(
    activity = activity.transition,
    favorability = favorability.transition))


# Define  budget cycle for all media channels as tuning weekly spend to optimize for the year:
budget.index <- rep(1:n.years, each = 52)


# Define behavior of marketing interventions

# Television
# Weekly flighting pattern:
tv.flighting <-
  pmax(0,
       market.rate.seas + SimulateAR1(length(market.rate.seas), -0.7, 0.7, -0.7))
tv.flighting <- tv.flighting[c(6:length(tv.flighting), 1:5)]

# Consumer awareness and favorability changes in presence of TV marketing
tv.activity.trans.mat <- matrix(
  c(1.00, 0.00, 0.00,  # migration originating from the inactive state
    0.00, 1.00, 0.00,  # exploratory state
    0.00, 0.00, 1.00),  # purchase state
  nrow = length(kActivityStates), byrow = TRUE)
tv.favorability.trans.mat <- matrix(
  c(0.4,  0.0,  0.4, 0.2, 0.0,  # migration from the unaware state
    0.0,  0.9,  0.1, 0.0, 0.0,  # negative state
    0.0,  0.0,  0.6, 0.4, 0.0,  # neutral state
    0.0,  0.0,  0.0, 0.8, 0.2,  # somewhat favorable state
    0.0,  0.0,  0.0, 0.0, 1.0),  # favorable state
  nrow = length(kFavorabilityStates), byrow = TRUE)

#TV Parameters:
params.tv <- list(
  audience.membership = list(activity = rep(0.4, 3)),
  budget = rep(c(545e5, 475e5, 420e5, 455e5), length = n.years),
  budget.index = budget.index,
  flighting = tv.flighting,
  unit.cost = 0.005,
  hill.ec = 1.56,
  hill.slope = 1,
  transition.matrices = list(
    activity = tv.activity.trans.mat,
    favorability = tv.favorability.trans.mat))



# References:
"
[1] Zhang, S. and Vaver, J. (2017). The Aggregate Marketing System Simulator.
*[https://research.google.com/pubs/pub45996.html](https://research.google.com/pubs/pub45996.html)*.

Data generation code retrieved from Google GitHub: https://github.com/google/amss/blob/master/vignettes/amss-vignette.Rmd
"
