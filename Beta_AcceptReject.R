# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Moment Estimator Properties - Beta Distribution                           ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# This function takes a random sample x (a vector) and returns the moment 
# estimators.
beta_moment_estimators <- function(x) {
  m1 <- mean(x) ; m2 <- mean(x ^ 2) ; commonfact <- (m1 - m2) / (m2 - m1 ^ 2)
  list(ahat = m1 * commonfact, bhat = (1 - m1) * commonfact)
}

# Implementation of Monte Carlo simulations with m = 10000 samples of size 
# n = 20 from the Beta(2, 3) distribution. 

# We simulate using Accept-Reject sampling.
# We use the Uniform distribution as the proposal.
beta_accept_reject <- function(size, a, b) {
  dbet <- function(x) {
    x ^ (a - 1) * (1 - x) ^ (b - 1) 
  }
  sam <- numeric(size)
  M <- optimise(dbet, interval = c(0, 1), maximum = T)$objective
  for (i in seq_along(sam)) {
    repeat{
      y <- runif(1) ; u <- runif(1)
      if (u <= dbet(y) / M) {
        sam[i] <- y
        break 
      }
    }
  }
  sam
}
m <- 1e4 ; n <- 20 ; a <- 2; b <- 3
obs <- acc.rej.beta(m * n, a, b)
hist(obs, freq = F, xlab = "",
     main = "Beta(2,3) from Accept-Reject Sampling")
curve(dbeta(x, 2, 3), from = 0, to = 1, col = "blue", add = T)
samples <- matrix(obs, nrow = m, ncol = n)

# Calculation of the moment estimators for each one of the m samples.
ahats <- apply(samples, 1, function(x) ebeta(x)$ahat)
bhats <- apply(samples, 1, function(x) ebeta(x)$bhat)

# We now have a sample of the moment estimators. Using this sample, we estimate
# the bias, variance, and root mean square error (RMSE) of the two
# estimators.

### Shape1
mean_ahat <- mean(ahats)
bias_ahat <- mean_ahat - a
bias_ahat # bias
var_ahat <- sum((ahats - mean_ahat) ^ 2) / (m - 1)
var_ahat # variance
RMSE_ahat <- sqrt(mean((ahats - a) ^ 2))
RMSE_ahat # RMSE 

### Shape2
mean_bhat <- mean(bhats)
bias_bhat <- mean_bhat - b
bias_bhat #bias
var_bhat <- sum((bhats - mean_bhat) ^ 2) / (m - 1)
var_bhat #variance
RMSE_bhat <- sqrt(mean((bhats - b) ^ 2))
RMSE_bhat #RMSE
