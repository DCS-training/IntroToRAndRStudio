# #### Introduction to R and RStudio- Class 2 ####
# #### Data Wrangling ####
library(tidyverse)

# ==== Default Datasets ====
# R comes with a number of example datasets ready to use. You will become familiar with these datasets while troubleshooting code in the future.

library(datasets)  # For example datasets
?datasets
library(help = "datasets")

# iris data
?iris
iris
head(iris)

# UCBAdmissions
?UCBAdmissions
UCBAdmissions

# viewing dataframes as tables

tibble(iris)

iris_table <- tibble(iris)
iris_table

# Subsetting data
iris_setosa <-  filter(iris_table, Species == 'setosa') # The filter() function in the dplyr package (included in the tidyverse) allows for subsetting.
# Note the '==' checks the truth of a statement.
# For an explanation of operators in R, see:
browseURL("https://www.tutorialspoint.com/r/r_operators.htm")

iris_setosa # We now have an Iris dataset including only those rows where the column 'Species' is equal to 'setosa'.

iris_setosa$Petal.Length # The '$' operator allows for the selection of specific columns or values from a list.


iris_set_petal_long <- subset(iris_setosa, iris_setosa$Petal.Length > 1.5) # The base subset() function works in a similar way to the filter() function above.
iris_set_petal_long

iris_set_petal_long[1,] # Specific rows
iris_set_petal_long[,2] # Columns
iris_set_petal_long[1,2] # And cells can also be selected using []

iris_set_petal_long[seq(4,8),c(2,3:4)] # This can be combined with the seq() function we used last week.

# #### PART 2: Importing and Data Wrangling ####

# ==== Importing .csv ====

# In order to work with your own data, you will need to import it into the working environment. Remember to keep your data in the correct directory.

# Create a new project and download the data folder into the working directory.
# This section uses data from the Scottish Parliament Election 2021 and general demographic data. Data was originally taken from House of Commons Library: https://commonslibrary.parliament.uk/research-briefings/cbp-9230/ (accessed 22/03/22) and https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/2011-based-special-area-population-estimates/spc-population-estimates (accessed 28/04/22).

read_csv("Data/2021_election.csv") # The read_csv() function in 'readr' part of the tidyverse, is the easiest way to do this

Elec <- read_csv("Data/2021_election.csv") # Rather than just seeing a single output, you can assign the data to a variable

View(Elec) # To view the dataframe, or click on the object in the global environment

head(Elec)

spec_csv("Data/2021_election.csv") # The spec_csv() function in readr provides information about the data 

Demog <- read_csv("Data/Demography.csv")
spec(Demog) # spec() without _csv can also be used for dataframe objects in the working environment


# ==== Tidy Data ====
# Data is often mislabelled or unorganised. Data wrangling and tidying is simply the process of organizing this data.

browseURL("https://www.researchgate.net/publication/309343107_Ten_Simple_Rules_for_Digital_Data_Storage")

# ==== Subsetting Data ====

# Finding Specific Data

Elec[,3] # Select column
Elec[5,] # Select row
Elec[15,1] # Select cell

Elec[,'Region'] # The name of columns can also be used
as_tibble(Elec) # Viewing as a table can make it easier to visualise, though removing as_tibble() will still show the data

# Extracting Specific Data

Row_15 <- Elec[15,]
Lothian <- subset(Elec, Elec$Region == 'Lothian')

# Change data class

class(Elec$Region)
Elec$Region <- as_factor(Elec$Region)
is.factor(Elec$Region)

# ==== Creating New Data ====
# To calculate the winning party in each constituency, we can select the column with the largest vote share

Elec$first_party <- colnames(Elec[,3:8])[max.col(Elec[,3:8], ties.method = "first")] # We can break this line of code down part by part to understand the process

Elec$first_party # selects the 'first_party' column in the data frame 'Elec'. Using <- we can assign a new value for this column, or in this case, assign values for a new column.

colnames(Elec[,3:8]) # uses the colnames() function. The first argument is the object we want the column names of.
# We then use [,3:8] to subset 'Elec' into only columns 3-8.

help(colnames) # More information on colnames function

max.col(Elec[,3:8], ties.method = "first") # selects the column of the highest value for each row. The output is a number between 1-6, because the data has been subsetted into 6 columns (Data[,3:8]). A value of '1' in this output means that 'SNP' had the highest value for this specific row, ie. the SNP had the most valid votes in this constituency.
# The ties.method argument simply tells max.col() what do do in the event that two columns have the same value.

colnames(Elec[,3:8])[max.col(Elec[,3:8], ties.method = "first")] # Combining all of this, instead of the output being numbers 1-6, we instead use the 6 column names for Elec[,3:8].

view(Elec[,c(1,12)]) # We now have a column showing the winning party in each constituency.

# Or to calculate voter turnout as a percentage, we can compare total votes cast against the electorate

Elec$turnout <- ((Elec$`Votes Cast`)/Elec$Electorate)*100 # This is somewhat more straightforward. Again, we assign values to a new column Elec$turnout. To get this, we add the values in the columns Votes Cast and divide it by the total electorate in each constituency. Multiplying it by 100 gives us the value as a percentage.

view(Elec[,c(1,12,13)])

# ==== Pipes ====
# We can also use pipes to make data wrangling more straightforward.

Elec %>%
  view() # Pipes '%>%' in R dplyr, take the output of a function or variable etc. (in this case 'Elec'), and use it as the input for the following function (in this case view())
# Essentially, functions that take one argument (function(argument)) can be re-written using pipes (argument %>% function).

Elec %>%
  filter(turnout >70) %>%
  view() # A series of different functions can be 'chained' using multiple pipes, creating a pipeline. This can help to simplify your code, and increase reproducibility.

assign("Mean_turnout_by_region", Elec %>%
           group_by(Region) %>%
           summarise(Mean_turnout = mean(turnout)) %>%
           arrange(desc(Mean_turnout)))

view(Mean_turnout_by_region)


# Code can be streamlined through using pipes, the code above would require multiple long winded steps and variables to replicate without pipes. Using pipes, we can more easily take it step by step.
# assign() takes two arguments, an object to assign a value to ("Mean_turnout_by_region") and a new value, our pipeline (separated by a comma). First we take Elec, which we pipe into the group_by() function. This groups Elec by a specified column, eg. Region (you can also try with first_party).
# We then pipe this into the summarise function, which creates a new column called "Mean_turnout" which has the value of the mean(turnout) function (which just calculates the mean of a specified column, turnout in this case).
# The arrange function then arranges the piped data by a specified value, in this case Mean_turnout, in descending (desc()) order.

browseURL("https://www.datacamp.com/community/tutorials/pipe-r-tutorial")

# ==== Tidy Data ====
# Let's combine the two datasets we have, Elec and Demog. However, the shared columns are case sensitive, so we have to ensure the data are actually compatible with one another

Demog <- Demog %>% 
  mutate(Constit = toupper(Constit)) # This line of code uses a number of functions and the pipe.
# The mutate() function in dplyr allows data to be changed. The first argument (Constit) is the data to be changed, the second (following =) is the new data that will replace the first argument.
# toupper() changes all characters to upper case.

Merged_elec <- merge(Elec[,c(1,2,12)], Demog[,c(1:4)], by.x="Constituency", by.y="Constit") # We covered the merge function last week, but we can go over the arguments again and use the ability to subset data.

# We can rearrange the order of the columns to keep it tidier.

Merged_elec <- Merged_elec[,c(1,2,4:6,3)] # Note that the order of c() is based on the order within the function, not a numerical order.

Merged_elec[,1] <- str_to_title(Merged_elec[,1]) # str_to_title() simply changes the case of characters to begin with upper case with the rest being lower case. This is purely to keep the data tidy.

# ==== Research Questions ====
# Let's try and answer some questions about the election data, by using some of the data wrangling techniques we have seen today.

# Merge the entirety of the two dataframes together using merge and ensuring that both are the correct case. Change the order of the columns if you like.

# Which constituency had the highest turnout?
# Try using the arrange() function.

# Which constituency had the lowest turnout?

# Output the names of the five constituencies with the highest turnout, and the Region they were each in.
# Look at slice() and select()- help(slice) and help(select).

# Which party won the most constituency seats?
# Look at count()- help(count)

# Compare mean turnout between winning parties.
# Try creating a new dataframe using group_by() and summarise().

# Create columns showing the percentage of male and female (note that this demography is based on total population, not just electorate, so the total numbers are higher that the total electorate).
# Compare percentage of female population between winning parties.

# Compare mean age of population between winning parties.

# Create a row with the Scotland wide total values for each column. For percentages, calculate mean values. You will also have to subset to discount character data and input your own value for these separately. 

# Feel free to play around with this data, or your own, and we can help answer any questions that arise.

#### END ####