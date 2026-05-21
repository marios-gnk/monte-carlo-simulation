# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Laplace Distribution - Generalized Inverse Simulation                     ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# In this experiment, we are going to simulate from the Laplace(-5, 2)
# distribution, where the associated CDF is:
# F(x) = 1 / 2 exp{(x - m) / b},       if x < m, and
# F(x) = 1 - 1 / 2 exp{- (x - m) / b}, otherwise.

# First of all, we create the inverse function Finv(u) in R.
Finv <- function(u, m = -5, b = 2) {
  ans <- numeric(length(u))
  I1 <- u < 1/2 
  I2 <- u >= 1/2
  ans[I1] <- log(2 * u[I1])
  ans[I2] <- -log(2 * (1 - u[I2]))
  m + b * ans # m and b are location and scale parameters, respectively.
}

# Then, we create the density function f(x).
dens <- function(x, m = -5, b = 2) {
  ans <- -abs(x - m) / b - log(2 * b)
  exp(ans)
}

# We create a function that takes an argument n (number of observations) and
# simulates a sample of size n from the Laplace(-5, 2) distribution.
my_rlaplace <- function(n, m = -5, b = 2) {
  u <- runif(n)
  Finv(u)
}

# We plot a histogram of a sample of size 10k, along with a density curve.
n <- 1e4
sam <- my_rlaplace(n)
hist(sam, freq = F, xlab = "Sample", main = "Laplace(-5,2) from Uniform",
     ylim = c(0, .25), xlim = c(-30, 20))
curve(dens, from = -20, to = 10, col = "red", add = T)

