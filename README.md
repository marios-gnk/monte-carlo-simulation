# Monte Carlo Simulation of Random Variables (R)
This repository contains an academic assignment completed as part of the course **Computational Statistics**.
## Overview
The assignment contains four main exercises that focus on the implementation and analysis of Monte Carlo simulation techniques for generating random variables from non-trivial probability distributions.

The assignment includes custom implementations of:

- Accept-Reject Sampling
- Generalized Inverse Simulation
- Box-Muller Algorithm

The emphasis is placed on understanding the underlying statistical methodology rather than relying exclusively on built-in R functions.

## Exercises Included

### 1. Gamma Distribution via Accept-Reject Sampling
Implementation of the accept-reject algorithm for simulating observations from the $\text{Gamma}(2.5, 3)$ distribution using the $\text{Exp}(1)$ distribution as the proposal.

Main components:

- Construction of an unnormalized Gamma density
- Calculation of the acceptance probability
- Simulation of 10,000 observations
- Empirical acceptance probability estimation
- Histogram and theoretical density comparison

### 2. Geometric Distribution via Generalized Inverse Simulation 
Simulation from the $\text{Geometric}\left\(\tfrac{1}{3}\right\) + 1$ distribution using the generalized inverse CDF method.

Main components:

- Derivation and implemantation of the generalized inverse CDF
- Simulation of 10,000 observations
- Comparison against R's built-in `rgeom()` function.

### 3. Laplace Distribution via Inverse Transform Sampling
Custom simulation of the $\text{Laplace}(-5, 2)$ distribution using the inverse CDF method.

Main components:

- Piecewise derivation of the inverse CDF 
- Custom density construction
- Histogram and theoritical density visualization

### 4. Normal Distribution via Accept-Reject-Sampling 
Simulation from the $\mathcal{N}(5, 4)$ distribution using two different proposal distributions:


- Student's $\mathcal{t}(1)$
- $\text{Logistic}(0,1)$

The exercise also includes:

- Comparison of proposal efficiency
- Custom implementation of the Box-Muller algorithm
- Runtime benchmarking using the `microbenchmark` package

## Running the Code

Open the `MonteCarloSimulation.Rproj` file in RStudio and run the individual scripts separately.

Note: Before running the `microbenchmark` package





