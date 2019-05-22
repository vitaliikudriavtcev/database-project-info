# Working with Data

# Set the working directory
setwd("C:/Pluralsight")

# Read a tab-delimited data file
cars <- read.table(
    file = "Cars.txt",
    header = TRUE,
    sep = "\t",
    quote = "\"")

# Peek at the data
head(cars)

# Load the dplyr library
library(dplyr)

# Select a subset of columns
temp <- select(
    .data = cars, 
    Transmission,
    Cylinders,
    Fuel.Economy)

# Inspect the results
head(temp)

# Filter a subset of rows
temp <- filter(
    .data = temp, 
    Transmission == "Automatic")

# Inspect the results
head(temp)

# Compute a new column
temp <- mutate(
    .data = temp, 
    Consumption = Fuel.Economy * 0.425)

# Inspect the results
head(temp)

# Group by a column
temp <- group_by(
    .data = temp,  
    Cylinders)
    
# Inspect the results
head(temp)

# Aggregate based on groups
temp <- summarize(
    .data = temp, 
    Avg.Consumption = mean(Consumption))
    
# Inspect the results
head(temp)

# Arrange the rows in descending order
temp <- arrange(
    .data = temp, 
    desc(Avg.Consumption))
    
# Inspect the results
head(temp)

# Convert to data frame
efficiency <- as.data.frame(temp)

# Inspect the results
print(efficiency)

# Chain methods together
efficiency <- cars %>%
    select(Fuel.Economy, Cylinders, Transmission) %>%
    filter(Transmission == "Automatic") %>%
    mutate(Consumption = Fuel.Economy * 0.425) %>%
    group_by(Cylinders) %>%
    summarize(Avg.Consumption = mean(Consumption)) %>%
    arrange(desc(Avg.Consumption)) %>%
    as.data.frame()

# Inspect the results
print(efficiency)

# Save the results to a CSV file
write.csv(
    x = efficiency,
    file = "Fuel Efficiency.csv",
    row.names = FALSE)
