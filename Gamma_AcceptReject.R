# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Gamma Distribution - Accept-Reject Algorithm                              ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# In this exercise, we would like to simulate observations from the 
# Gamma(2.5, 3) distribution (3 is a rate parameter), using the accept-reject
# algorithm.

# The support of the Gamma distribution family is the set of non-negative real 
# numbers.

# First of all, we create a function called dgam() that takes the following 
# three arguments:
# - x: the point of evaluation,
# - a: the shape parameter,
# - b: the rate parameter,
# and returns the density-up to a constant-of the Gamma(a, b) distribution,
# evaluated at x.
# The function returns 0 if x is not in the support.
dgam <- function(x, a = 2.5, b = 3) {
  ans <- numeric(length(x))
  ans[x >= 0] <- x[x >= 0] ^ (a - 1) * exp(-b * x[x >= 0])
  return(ans)
}

# The Exp(1) distribution seems like a good choice for the proposal, 
# since it shares the same support with the Gamma distribution family.
my_dexp <- function(x, rate = 1) {
  ans <- numeric(length(x))
  ans[x >= 0] <- rate * exp(-rate * x[x >= 0])
  ans
}
curve(dgamma(x, 2.5, 3), from = 0, to = 5, main = "PDFs of Gamma(2.5,3) and Exp(1)",
      ylim = c(0, 1.5), ylab = "Density", col = "blue")
curve(my_dexp, from = 0, to = 5, col = "red", add = TRUE)
text(0.7, 1, "Gamma(2.5,3)", col = "blue")
text(0.7, 0.33, "Exp(1)", col = "red")

# We calculate the acceptance probability 1/M (using pen and paper).
xstar <- .75
Mstar <- exp(1.5 * log(xstar) - 2 * xstar)
c_f <- 3 ^ 2.5 / gamma(2.5)
M <- c_f * Mstar
accprob <- 1 / M
accprob

# We implement the accept-reject algorithm to simulate n = 10000 observations 
# from the Gamma(2.5, 3) distribution.
accrej <- function(size) {
  sam <- numeric(size)
  attempts <- 0
  for (i in seq_along(sam)) {
    acc <- F
    while (!acc) {
      attempts <- attempts + 1
      y <- rexp(1)
      u <- runif(1)
      if (u <= dgamma(y, 2.5, 3) / (M * dexp(y))) {
        acc <- T
        sam[i] <- y
      }
    }
  }
  accprob_est <- size / attempts
  list(sam = sam, accprob_est = accprob_est)
}
n <- 1e4
sim <- accrej(n)
s <- sim$sam

# We plot a histogram of a sample, along with a density curve.
hist(s, freq = F, xlab = "Sample",
     main = "Simulated 10k-sample from Gamma(2.5,3)", ylim = c(0, 1))
curve(dgamma(x, 2.5, 3), from = 0, to = 2.5, col = "red", add = T)