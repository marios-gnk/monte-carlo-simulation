# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Normal Distribution - Accept-Reject Algorithm                             ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(microbenchmark)

# In this experiment, we would like to simulate observations from the 
# N(5, 4) distribution, using the accept-reject algorithm.

# The support of the Normal distribution family is the set of real numbers.

# The parameters μ and σ of the N(μ, σ ^ 2) distribution (where μ is 
# the mean and σ is the standard deviation of the distribution) are location  
# and scale parameters, respectively. Therefore, if Z ~ N(0, 1) and 
# X ~ N(5, 4) then X = 5 + 2 * Z . Thus, we can simulate from the N(0, 1) and 
# then perform the previously mentioned transformation.

# There's a wide range of choices for the proposal distribution.   
# I would personally propose from the Student's t(1) or the Logistic(0, 1)   
# distribution, because they share the same support and their PDFs are identical 
# to that of the N(0, 1) distribution (They are symmetric with respect to the 
# vertical axis). 

# First of all, we calculate the acceptance probability 1/M for each proposal  
# distribution.
c1 <- beta(1/2, 1/2) / sqrt(2 * pi)
M1 <- 2 * c1 / sqrt(exp(1)) 

# The acceptance probability in case 1, that t(1) is the proposal:
acc_prob1 <- 1 / M1
acc_prob1

# The acceptance probability in case 2, that the proposal distribution is the 
# Logistic(0, 1):
fraq <- function(x) {
  dnorm(x) / dlogis(x)
}
M2 <- optimise(fraq, interval = c(-1e2, 1e2), maximum = T)$objective
acc_prob2 <- 1 / M2
acc_prob2
# The acceptance probability in case 1 is slightly higher. Therefore, the t(1)
# distribution seems to be a better choice for the proposal distribution. The
# difference in efficiency is relatively small though.

# Finally, we implement the accept-reject algorithm to simulate n = 1000  
# observations from the N(5, 4) distribution. We perform two separate   
# implementations, one for each proposal.
accrej1 <- function(size, mu = 0, sigma = 1) {
  c <- beta(1/2, 1/2) / sqrt(2 * pi)
  M <- 2 * c / sqrt(exp(1))
  sam <- numeric(size)
  attempts <- 0
  for (i in seq_along(sam)) {
    acc <- F
    while (!acc) {
      attempts <- attempts + 1
      y <- rt(1, df = 1) ; u <- runif(1)
      if (u <= dnorm(y) / (M * dt(y, 1))) {
        acc <- T
        sam[i] <- y
      }
    }
  }
  sam <- mu + sigma * sam
  acc_prob <- size / attempts
  list(sam = sam, acc_prob = acc_prob)
}

accrej2 <- function(size, mu = 0, sigma = 1) {
  fraq <- function(x) {
    dnorm(x) / dlogis(x)
  }
  M <- optimise(fraq, interval = c(-1e2, 1e2), maximum = T)$objective
  sam <- numeric(size)
  attempts <- 0
  for (i in seq_along(sam)) {
    acc <- F
    while (!acc) {
      attempts <- attempts + 1
      y <- rlogis(1) ; u <- runif(1)
      if (u <= fraq(y) / M) {
        acc <- T
        sam[i] <- y
      }
    }
  }
  sam <- mu + sigma * sam
  acc_prob <- size / attempts
  list(sam = sam, acc_prob = acc_prob)
}
n <- 1e3 ; mu <- 5 ; sigma <- 2
sim1 <- accrej1(n, mu, sigma)
sim2 <- accrej2(n, mu, sigma)
sam1 <- sim1$sam
sam2 <- sim2$sam


# We plot a histogram of a sample, along with a density curve. We create two 
# separate graphs, one for each proposal distribution.

hist(sam1, freq = F, xlab = "", main = "Normal(5,4) in case t(1) is the proposal")
curve(dnorm(x, mean = mu, sd = sigma), from = -3, to = 13, col = "red", add = T)
hist(sam2, freq = F, xlab = "", main = "Normal(5,4) in case the Logistic(0, 1) is the proposal")
curve(dnorm(x, mu, sigma), from = -3, to = 13, col = "red", add = T)

# Then, we implement the box-muller algorithm and compare the three 
# implementations using the microbenchmark package.
boxmuller <- function(size, mu = 0, sigma = 1) {
  
  if(size %% 2 == 1){
    size <- size + 1
  }
  
  theta <- runif(size / 2, 0, 2 * pi) 
  U1 <- runif(size / 2)
  R <- sqrt(-2 * log(U1))
  Z <- c(R * cos(theta), R * sin(theta))
  if(size %% 2 == 1){
    Z <- Z[-1]
  }
  mu + sigma * Z
}
sam3 <- boxmuller(1e3, 5, 2)
hist(sam3, freq = F, xlab = "", main = "Normal(5,4) from boxmuller")
curve(dnorm(x, mu, sigma), from = -3, to = 13, col = "red", add = T)
microbenchmark(accrej1(1000, mu, sigma), times = 100, unit = "us")
microbenchmark(accrej2(1000, mu, sigma), times = 100, unit = "us")
microbenchmark(boxmuller(1000, mu, sigma), times = 100, unit = "us")
# The fastest algorithm is the box-muller, as expected.
