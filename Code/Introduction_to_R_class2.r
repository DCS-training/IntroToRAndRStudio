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
iris_set_petal_long <- filter(iris_setosa, Petal.Length > 1.5) # filter example.

iris_set_petal_long

# Viexing specific rows and columns

iris_set_petal_long[1,] # Specific rows
iris_set_petal_long[,2] # Columns
iris_set_petal_long[1,2] # And cells can also be selected using []

iris_set_petal_long[seq(4,8),c(2,3:4)] # This can be combined with the seq() function we used last week. However, this can look like an overwhelming number of numbers. Thankfully there are means of simplifying the process.
head(iris_set_petal_long) # View the first 5 rows
tail(iris_set_petal_long) # View the last 5 rows
iris_set_petal_long %>% slice_min(Sepal.Length, n =5) # A funky little demo of what tidyverse can offer.  'slice_min()' allows us to view the lowest values associated with a variable. Try changing _min to _max and see what happens. We will explain the %>% function later, but for now this of it as a instructing tool for R.

# #### PART 2: Importing and Data Wrangling ####

# ==== Importing .csv ====

# In order to work with your own data, you will need to import it into the working environment. Remember to keep your data in the correct directory.

# Create a new project and download the data folder into the working directory.
# This section uses data from the Scottish Parliament Election 2021 and general demographic data. Data was originally taken from House of Commons Library: https://commonslibrary.parliament.uk/research-briefings/cbp-9230/ (accessed 22/03/22) and https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/2011-based-special-area-population-estimates/spc-population-estimates (accessed 28/04/22).
# Tip - go to Session, and Set Working Directory
read_csv("Data/2021_election.csv") # The read_csv() function in 'readr' part of the tidyverse, is the easiest way to do this

Elec <- read_csv("2021_election.csv") # Rather than just seeing a single output, you can assign the data to a variable

View(Elec) # To view the dataframe, or click on the object in the global environment

head(Elec) # head provides the first 5 entries
summary(Elec) # summary provides a summarised overview of all dataset variables

spec_csv("2021_election.csv") # The spec_csv() function in readr provides information about the data 

Demog <- read_csv("Demography.csv")
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

# ==== Pipes ====
# We can also use pipes to make data wrangling more straightforward.

Elec %>%
  view() # Pipes '%>%' in R dplyr, take the output of a function or variable etc. (in this case 'Elec'), and use it as the input for the following function (in this case view())
# Essentially, functions that take one argument (function(argument)) can be re-written using pipes (argument %>% function).

Elec %>% select(Region) # This is the tidverse approach. The select() function is does what it says on the tin, and lets us "select" variables. 


as_tibble(Elec) # Viewing as a table can make it easier to visualise, though removing as_tibble() will still show the data

# Extracting Specific Data

Row_15 <- Elec[15,]
Lothian <- subset(Elec, Elec$Region == 'Lothian')
Lothian <- Elec %>% filter(Region == 'Lothian')

# Change data class

class(Elec$Region)
Elec$Region <- as_factor(Elec$Region)
is.factor(Elec$Region)
class(Elec$Region)

# ==== Creating New Data ====
# To calculate the winning party in each constituency, we can select the column with the largest vote share

# Dataset is currently in wide format. Whilst wide makes it easier for us humans to read the data, it can complicate the coding required to reach our goals.

# Our data is wide as there is a seperate column for each political party. But thankfully we can use tidyverse to merge these columns together to create a categorical "Political_Party" column, and a numerical "votes_earned" column. This will simplify the coding procedures needed for the future.

Long_Elec <- Elec %>% pivot_longer(
  cols = c("SNP", "CON", "LAB", "LD", "GRN", "OTH"), # telling R to identify the columns 
  names_to = "Politcal_Party", # Giving a name to our category column.
  values_to = "votes_earned"
) 

# Notice how we now have a new data set with 438 observations over 7 variables.
summary(Long_Elec)

# Now to transform our character variables to a factor variables. This allows R to help us identify the count values of the Constituencies, Regions and Political Parties.

# Two ways of transforming - safe way

Cat_Elec <- Long_Elec %>% mutate(Constituency = as.factor(Constituency),
                                   Region = as.factor(Region),
                                   Politcal_Party = as.factor(Politcal_Party))
summary(Cat_Elec)

# Speedier way, but need to be confident that all character variables are suitable for factorising.

Cat_Elec <- Long_Elec %>% mutate_if(is.character, as.factor) # This works as an "if" function. Simply put, the first command (here:"is.character") tells R to identify all character variables and select them for transformation. The second command (here:"as.factor") applies as function to all the variables that meet the desired criteria. 
summary(Cat_Elec)

# Now that our data is prepared, lets start preparing it address our task: To calculate the winning party in each constituency. 

# Step 1: Grouping data
## As we are interested in identifying the winning party in each constituency, we need to group the data around each constituency. 

Group_Elec <- Cat_Elec %>% 
  group_by(Constituency) %>% #Step 2 - Identifying the party with most votes (notice here how we can link our pipes)
  top_n(n=1, wt = votes_earned) # n=1 tells the function to identify the highest rank, wt tells the function which variable to perform the calculations in
summary(Group_Elec)
view(Group_Elec)


# This can also be done in through fewer lines of code, but in my opinion it is less intuitive and user friendly. This can create reproduce-ability issues, and make it difficult to interpret what is actually happening in the code.
Elec$first_party <- colnames(Elec[,3:8])[max.col(Elec[,3:8], ties.method = "first")] 
# We can break this line of code down part by part to understand the process. The coding and breakdown is below for reference for those who are interested. However, for now we will skip to line 179.

Elec$first_party # selects the 'first_party' column in the data frame 'Elec'. Using <- we can assign a new value for this column, or in this case, assign values for a new column.

colnames(Elec[,3:8]) # uses the colnames() function. The first argument is the object we want the column names of.
# We then use [,3:8] to subset 'Elec' into only columns 3-8.

help(colnames) # More information on colnames function

max.col(Elec[,3:8], ties.method = "first") # selects the column of the highest value for each row. The output is a number between 1-6, because the data has been subsetted into 6 columns (Data[,3:8]). A value of '1' in this output means that 'SNP' had the highest value for this specific row, ie. the SNP had the most valid votes in this constituency.
# The ties.method argument simply tells max.col() what do do in the event that two columns have the same value.

colnames(Elec[,3:8])[max.col(Elec[,3:8], ties.method = "first")] # Combining all of this, instead of the output being numbers 1-6, we instead use the 6 column names for Elec[,3:8].

view(Elec[,c(1,12)]) # We now have a column showing the winning party in each constituency.

# Calculating voter turnout  
Turnout_Elec <- Cat_Elec %>% mutate(turnout = (`Votes Cast`/Electorate)*100) #Here we are using mutate to create a new variable by diving existing variables and multiplying by 100 to calculate a percentage. 
summary(Turnout_Elec)

Turnout_Elec %>%
  filter(turnout >70) %>%
  view() 
# A series of different functions can be 'chained' using multiple pipes, creating a pipeline. This can help to simplify your code, and increase reproducibility.

Mean_turnout_by_region <- Turnout_Elec %>%
         group_by(Region) %>%
         summarise(Mean_turnout = mean(turnout)) %>%
         arrange(desc(Mean_turnout))

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

#Much like the Elec dataset, Demog is also wide. 
Long_Demog <- Demog %>% pivot_longer(cols = c(Male, Female),
                                     names_to = "Gender",
                                     values_to = "votes_by_gender") %>% 
  mutate(Gender = as.factor(Gender), 
         Constit = as.factor(Constit)) #Transforming our Gender and Consitit variables to be categorical again.
summary(Long_Demog)

Merged_elec <- merge(Turnout_Elec, Long_Demog, by.x="Constituency", by.y="Constit")  %>% mutate_if(is.character, as.factor)

Merged_elec <- merge(Elec, Demog, by.x="Constituency", by.y="Constit") %>% mutate_if(is.character, as.factor) #%>% distinct()

summary(Merged_elec)
 # We covered the merge function last week, but we can go over the arguments again and use the ability to subset data.

Merged_elec[,1] <- str_to_title(Merged_elec[,1]) # str_to_title() simply changes the case of characters to begin with upper case with the rest being lower case. This is purely to keep the data tidy.

#We can now use this merged dataset to explore voting patterns of winning parties by age across regions and constituencies. Tidyverse makes this very easy through the ggplot function - to covered in more depth in future CDCS sessions! But for now, here is a quick example:

#Step 1 - This is the tricky part: summarising our data to get the values we want. We will cover these steps in the tasks below.
New_Merged_elec %>%
  select(Constituency, Politcal_Party, Mean_age, votes_earned, Region) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>% 
  distinct() %>%
  summarise(Politcal_Party = Politcal_Party,
            Region = Region,
            Mean_age = Mean_age)%>%
  filter(Region == "Lothian") %>% 
  arrange(desc(Mean_age), .by_group = TRUE) %>% # Step 2 - This is the easier part, creating the plot)
ggplot(aes(fill = Politcal_Party, y = Mean_age, x = fct_reorder(Constituency, Mean_age))) + # This first stage of the plot is to tell R which variables we are interested in. 
  geom_col()+ #We use geom to select our plot style. Note that geom_col cannot plot categories on its y axis.
  coord_flip() + # Coord_flip is something I like to use to ease the interpretation of the plot. It switches the x and y coordinates around.
  labs(title = "Mean voting age by Politcal party", 
  subtitle ="* Within Lothian Constituencies",
  x = "Constituency",
  y = "Mean voting age of winning party",
  fill = "Political Party")  # Here we use labs to create new labels for our plot.
  

# ==== Research Questions ====
# Let's try and answer some questions about the election data, by using some of the data wrangling techniques we have seen today.
# cheatsheets/data-transformation.pdf at main · rstudio/cheatsheets (github.com) 
# Useful functions: select(), mutate(), group_by(), summarise(), arrange(), slice(), head(), merge(),

# Class 2 Solutions

# 1. Merge the entirety of the two dataframes together using merge and ensuring that both are the correct case. Change the order of the columns if you like.

## Function used: merge()
##Datasets reccomended: Turnout_Elc, Long_Demog 
## Tip: using "%>% mutate_if(is.character, as.factor)" will save you time.


# 2. Which constituency had the highest turnout? 

## Here we recommend using select() to choose your variables, group_by(), summarise() , arrange() and head().
##Within arrange(), you can use desc() to modify the order by which variables are arranged.

### determening lowest turnout


### determening highest turnout


### Which constituency had the highest turnout? 


### Which constituency had the lowest turnout?


# 3. Output the names of the five constituencies with the highest turnout, and the Region they were each in.

## Again we recommend using select() to choose your variables, group_by(), summarise() arrange(), head()/tail()
## This will also use head(). You can choose how many rows you want to display by defining n within head. 
## You might also choose to use tail(), which provides the reverse of head().

# 4. Which party won the most constituency seats? (tip - if using merged dataset here, be sure to remove duplicates, as the gender variable will cause copies so that both male and female are represented)

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), distinct() and summary()


# 5. Compare mean turnout between winning parties.

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), summarise() and arrange().


# 6. Create columns showing the percentage of male and female (note that this demography is based on total population, not just electorate, so the total numbers are higher that the total electorate).

## Step 1 - create updated demography dataset. Here we will need to use group_by(), mutate(), and ungroup().
## ungroup() allows us to ensure that our new total variable is usable across the data in its original un-grouped format.


## Step 2 - Create a percentage vote by gender variable (mutate() is your friend here)


# 7. Compare percentage of female population between constituencies.

## Step 1 - update merged dataset

## Step 2 - summarise gender and percentage votes, by gender and by constituency.
### Functions reccomended: select(), group_by(), summarise(), arrange(), distinct(). 
### Tip: when using arrange(), use ".by_group=TRUE" command within the function. 

# 8. Compare mean age of population by region between winning parties.

## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.


# 9. Calculate the mean mean_age across all winning parties

## This one is tricky, as you will need to use group_by() and distinct() twice.
## Be sure to provide a mean() to your mean age in the summarise()
## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.


# Feel free to play around with this data, or your own, and we can help answer any questions that arise.

#### END ####
