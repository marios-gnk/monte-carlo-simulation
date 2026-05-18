# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Geometric Distribution - Generalized Inverse Simulation                   ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# In this exercise, we are going to simulate from the Geom(1/3) + 1
# distribution.

# We create a vector called prob, holding the values F(x) for x = 1, ..., 49.
?pgeom
prob <- pgeom(1:49 - 1, 1/3)

# Then, we create the inverse function Finv(u) in R.
Finv <- function(u) {
  ceiling(log(1 - u) / log(2/3))
}

# We simulate a sample of size 10k using the generalized inverse we created and
# another one using the R function rgeom() + 1.
n <- 1e4
u <- runif(n)
X <- Finv(u)
Y <- rgeom(n, 1/3) + 1

# We compare the two barplots.
k <- 1:max(X, Y)
tabX <- table(factor(X, levels = k))
tabY <- table(factor(Y, levels = k))
barplot(rbind(tabX, tabY), beside = T)
## We can see that the frequency of each value is almost the same for 
## the two samples, as expected.