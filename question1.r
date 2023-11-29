#######################################################################
#Q1 P is time when the temperature is positive ; temp is normal with mean 0 , var delta t


#define a function that takes delta t as a parameter and then calculates the positve temps
sim_temp <- function(delta_t){
  
nsim <- 100000
proportions <- numeric(nsim)

for(i in 1:nsim){
times <- seq(from = 0, to = 1, length.out = floor(1 / delta_t) + 1)
temp_changes <- rnorm(length(times), mean = 0, sd = sqrt(delta_t))
temperatures <- cumsum(c(0, temp_changes))

#calculate positive temperatures
proportions[i] <- mean(temperatures > 0)

  
}

return (proportions)

}

#delta t values 
delta_t_vals <- c(0.01, 0.001, 0.0001, 0.00001, 0.000001)

delta_t <- 0.01
#perform simulation with the for loop 
for(delta_t in delta_t_vals){
  proportions <- sim_temp(sim_temp(delta_t))
  
  hist(proportions, main = paste("Distribution of P (delta t =", delta_t, ")"), xlab = "Proportion of time with positive temperature", ylab = "Frequency", col = "lightblue", border = "black")

}


## matching histograms to prob distribution 

# Create a histogram
hist_obj <- hist(proportions, main = paste("Distribution of P (delta t =", delta_t, ")"), xlab = "Proportion of time with positive temperature", ylab = "Frequency", col = "lightblue", border = "black")

# Get histogram data
bin_midpoints <- hist_obj$mids
bin_width <- hist_obj$breaks[2] - hist_obj$breaks[1]
observed_freq <- hist_obj$counts

# Normalize frequencies
normalized_probs <- observed_freq / sum(observed_freq)

# Compute estimated PDF
estimated_pdf <- normalized_probs / bin_width

# Plot the estimated distribution
plot(bin_midpoints, estimated_pdf, type = "h", lwd = 2, col = "blue",
     main = "Estimated Distribution from Histogram", xlab = "Variable", ylab = "Density")

# Compare to a candidate distribution (e.g., normal)
curve(dnorm(x, mean = mean(data), sd = sd(data)), col = "red", add = TRUE)
legend("topright", legend = c("Estimated", "Normal"), col = c("blue", "red"), lwd = 2)

##################################################################################
#KERNEL DISTRIBUTION ESTIMATOR 

# Function to perform KDE and plot the estimated distribution
estimate_P_distribution <- function(delta_t) {
  # Simulate Tmax values
  P_values <- sim_temp(delta_t)
  
  # Perform KDE
  kde <- density(P_values)
  
  # Plot the estimated distribution
  plot(kde, main = paste("Kernel Density Estimation for P (delta_t =", delta_t, ")"), 
       xlab = "Time at Positive Temperature", ylab = "Density", col = "blue", lwd = 2)
  
  # Add true distribution if known (optional)
  # curve(dnorm(x, mean = true_mean, sd = true_sd), col = "red", add = TRUE)
}

# Example usage with a specific delta_t value
estimate_P_distribution(0.001)
  

##Q2 

## For the Tmax distribution
## Same simulation appraoch 
## use KDE, inspection by eye and the statistical tests 
## overall conclusion / comment on the results of my graph

#define a function that takes delta t as a parameter and then calculates the positve temps

#change this for Tmax
# Function to simulate Tmax
simulate_Tmax <- function(delta_t) {
  # Number of simulations
  num_simulations <- 10000
  
  # Initialize a vector to store Tmax values
  Tmax_values <- numeric(num_simulations)
  
  for (i in 1:num_simulations) {
    # Simulate temperature process
    time_points <- seq(from = 0, to = 1, length.out = floor(1 / delta_t) + 1)  # Adjusted 'seq' arguments
    temperature_changes <- rnorm(length(time_points), mean = 0, sd = sqrt(delta_t))
    temperatures <- cumsum(c(0, temperature_changes))
    
    # Find time at which maximum temperature occurs
    time_of_max <- time_points[which.max(temperatures)]
    
    # Store Tmax value
    Tmax_values[i] <- time_of_max
  }
  
  return(Tmax_values)
}

# Values of delta_t to experiment with
delta_t_values <- c(0.01, 0.001, 0.0001)

# Perform simulation for each delta_t
for (delta_t in delta_t_values) {
  Tmax_values <- simulate_Tmax(delta_t)
  
  # Plot the histogram of Tmax values
  hist(Tmax_values, main = paste("Distribution of Tmax (delta_t =", delta_t, ")"), 
       xlab = "Time at Maximum Temperature", ylab = "Frequency", col = "lightgreen", border = "black")
}

  # Add true distribution if known (optional)
  # curve(dnorm(x, mean = true_mean, sd = true_sd), col = "red", add = TRUE)

################################################################################
##KDE on this function 

# Function to perform KDE and plot the estimated distribution
estimate_Tmax_distribution <- function(delta_t) {
  # Simulate Tmax values
  Tmax_values <- sim_temp(delta_t)
  
  # Perform KDE
  kde <- density(Tmax_values)
  
  # Plot the estimated distribution
  plot(kde, main = paste("Kernel Density Estimation for P (delta_t =", delta_t, ")"), 
       xlab = "Time at Positive Temperature", ylab = "Density", col = "blue", lwd = 2)
  
  # Add true distribution if known (optional)
  # curve(dnorm(x, mean = true_mean, sd = true_sd), col = "red", add = TRUE)
}

# Example usage with a specific delta_t value
estimate_P_distribution(0.001)



## Use the statistical tests to check if it is independent (built in R functions)


# Fit a distribution to the observed data
fit_result <- fitdist(observed_Tmax, "beta")  # You may need to choose an appropriate distribution
summary(fit_result)  # Print the summary of the fit

# Kolmogorov-Smirnov test
ks_test_result <- ks.test(observed_Tmax, "pbeta", shape1 = fit_result$estimate[1], shape2 = fit_result$estimate[2])
print(ks_test_result)

# Anderson-Darling test
ad_test_result <- ad.test(observed_Tmax, "pbeta", shape1 = fit_result$estimate[1], shape2 = fit_result$estimate[2])
print(ad_test_result)

##Important to choose the right distribution to compare to, for Q1 it is beta, might be a different dist for Q2

##QQ plot could make one to test for normality , but it usually isn't normal ... could do it for one to show
##do slightly different method for part ii so as to show more variability in my code