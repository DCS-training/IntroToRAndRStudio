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
head(iris) # Preview first 6 rows of the data. This can increased by setting "n = ...".
tail(iris) #Preview last 6 rows of the data. This can also be modified by setting n.
summary(iris) #Preview a summary of your data - mean, median, quartiles, ranges, count, and variable categories
boxplot(iris$Petal.Length) # Quick boxplot of your data. Use the $ to choose the variable you're interested in visualising.
hist(iris$Petal.Length) # Quick histogram of your data. $ is used in same way.

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

# Running analyses - Quick run through what we can do. Don't worry if the stats is intimidating. The purpose here is to demonstrate how effective R is for analysis, and to provide an example code reference to help you with your own analyses.

anova <- aov(Petal.Length ~ Species, data = iris) # anova coding template - aov(outcome variable ~ group variable, data = the relevant dataset)
summary(anova) # Output for the anova
TukeyHSD(anova) # Post-hoc Tukey Honest Significant Difference test - used to performing multiple pair wise comparison tests between groups.

linear_model <- lm(Petal.Length ~ Sepal.Length + Sepal.Width, data = iris) # linear regression coding. Use the plus sign to add additional variable. Use * to mark interaction effects.
summary(linear_model)


# #### PART 2: Importing and Data Wrangling ####

# ==== Importing .csv ====

# In order to work with your own data, you will need to import it into the working environment. Remember to keep your data in the correct directory.

# Create a new project and download the data folder into the working directory.
# This section uses data from the Scottish Parliament Election 2021 and general demographic data. Data was originally taken from House of Commons Library: https://commonslibrary.parliament.uk/research-briefings/cbp-9230/ (accessed 22/03/22) and https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/2011-based-special-area-population-estimates/spc-population-estimates (accessed 28/04/22).
# Tip - go to Session, and Set Working Directory
read_csv("Data/2021_election.csv") # The read_csv() function in 'readr' part of the tidyverse, is the easiest way to do this

Elec <- read_csv("Data/2021_election.csv") # Rather than just seeing a single output, you can assign the data to a variable

View(Elec) # To view the dataframe, or click on the object in the global environment

head(Elec) # head provides the first 5 entries
summary(Elec) # summary provides a summarised overview of all dataset variables

spec_csv("Data/2021_election.csv") # The spec_csv() function in readr provides information about the data 

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
Elec_transform$Region <- as_factor(Elec$Region)
Elec_transform <- Elec %>% mutate(Region = as.factor(Region))
is.factor(Elec_transform$Region)
class(Elec_transform$Region)
summary(Elec_transform$Region)

# ==== Creating New Data ====
# To calculate the winning party in each constituency, we can select the column with the largest vote share

# Dataset is currently in wide format. Whilst wide makes it easier for us humans to read the data, it can complicate the coding required to reach our goals.

# Our data is wide as there is a seperate column for each political party. But thankfully we can use tidyverse to merge these columns together to create a categorical "Political_Party" column, and a numerical "votes_earned" column. This will simplify the coding procedures needed for the future.

Long_Elec <- Elec %>% pivot_longer(
  cols = c("SNP", "CON", "LAB", "LD", "GRN", "OTH"), # telling R to identify the columns 
  names_to = "Political_Party", # Giving a name to our category column.
  values_to = "votes_earned"
) 

# Notice how we now have a new data set with 438 observations over 7 variables.
summary(Long_Elec)

# We can also use code to quickly visualise our data - details of how to produce prettier plots will be covered in future CDCS workshops. 
hist(Long_Elec$votes_earned) # histogram code
boxplot(Long_Elec$votes_earned) # boxplot code

# Now to transform our character variables to a factor variables. This allows R to help us identify the count values of the Constituencies, Regions and Political Parties.

# Two ways of transforming - safe way

Cat_Elec <- Long_Elec %>% mutate(Constituency = as.factor(Constituency),
                                   Region = as.factor(Region),
                                   Political_Party = as.factor(Politcal_Party))
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
  select(Constituency, Political_Party, Mean_age, votes_earned, Region) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>% 
  distinct() %>%
  summarise(Politcal_Party = Political_Party,
            Region = Region,
            Mean_age = Mean_age)%>%
  filter(Region == "Lothian") %>% 
  arrange(desc(Mean_age), .by_group = TRUE) %>% # Step 2 - This is the easier part, creating the plot)
ggplot(aes(fill = Political_Party, y = Mean_age, x = fct_reorder(Constituency, Mean_age))) + # This first stage of the plot is to tell R which variables we are interested in. 
  geom_col()+ #We use geom to select our plot style. Note that geom_col cannot plot categories on its y axis.
  coord_flip() + # Coord_flip is something I like to use to ease the interpretation of the plot. It switches the x and y coordinates around.
  labs(title = "Mean voting age by Political party", 
  subtitle ="* Within Lothian Constituencies",
  x = "Constituency",
  y = "Mean voting age of winning party",
  fill = "Political Party")  # Here we use labs to create new labels for our plot.
  

# ==== Research Questions ====
# Let's try and answer some questions about the election data, by using some of the data wrangling techniques we have seen today.
# We have provided hints/skeletons for the early questions. Be sure to ask for help if you need it. Also, feel free to play around and experiment! It's the best way of getting an intuitaive understanding of what the code is doing. 
# Embrace mistakes and have fun!

# cheatsheets/data-transformation.pdf at main · rstudio/cheatsheets (github.com) 
# Useful functions: select(), mutate(), group_by(), summarise(), arrange(), slice(), head(), merge(),

# 1. Merge the entirety of the two dataframes together using merge and ensuring that both are the correct case. Be sure to merge on the constituency variables across both datasets. 

## Function used: merge()
##Datasets reccomended: Turnout_Elc, Long_Demog 
## Tip: using "%>% mutate_if(is.character, as.factor)" will save you time.

Meged_data <- merge(..., ..., by.x=..., by.y=...)

# 2. Which constituency had the highest turnout? 

## Here we recommend using select() to choose your variables, group_by(), summarise() , arrange() and head().
##Within arrange(), you can use desc() to modify the order by which variables are arranged.

### determening lowest turnout
... %>% 
  select(..., ...) %>% # focusing our variables 
 group_by(Constituency) %>% # Grouping by constituency as we want to determine the turnout by constituency
  summarise(Mean_turnout= mean(...))  %>% # we use summarise to provide a summarised output by constituency. 
  arrange(Mean_turnout) %>% head()

### determening highest turnout
... %>% 
  select(..., ...) %>%
  group_by(Constituency) %>% 
  summarise(Mean_turnout= ...())  %>%
  arrange(desc(...)) %>% # Arranges data with highest turnout first
  head()

### Which constituency had the highest turnout? 
... %>% 
  select(..., ...) %>%
  group_by(...) %>% 
  summarise(...= ...())  %>%
  arrange(...(...)) %>%
  head(n=...)  # We use head and set n to narrow down the output to the highest turnout. Try replacing head() with tail() and see what happens.
 
### Which constituency had the lowest turnout?
... %>% 
  select(..., ...) %>%
  group_by(...) %>% 
  summarise(...= ...())  %>%
  arrange(...) %>% #
  slice() #slice can also be used , remember to set how many rows you want to see

# 3. Output the names of the five constituencies with the highest turnout, and the Region they were each in.

## Again we recommend using select() to choose your variables, group_by(), summarise() arrange(), head()/tail()
## This will also use head(). You can choose how many rows you want to display by defining n within head. 
## You might also choose to use tail(), which provides the reverse of head().

... %>% 
  select(..., ..., turnout) %>%
  group_by(..., ...) %>% #Here we have to group_by the 2 grouping variables our question is interested in.
  summarise(Mean_turnout= mean(...))  %>%
  arrange(desc(...)) %>%
  head(n = ...) # simply define your n to determine how many are displayed


# 4. Which party won the most constituency seats? (tip - if using merged dataset here, be sure to remove duplicates, as the gender variable will cause copies so that both male and female are represented)

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), distinct() and summary()

... %>%
  select(..., ..., ...) %>%
  group_by(....) %>%  # we group by constituency as this is the domain we are interested in. (i.e., political parties win seats in constituencies, so we need to group by constituency).
    top_n(n= ..., wt = ...) %>% #top_n() can identify highest value across the grouped variable.
  distinct() %>% #distinct() used to removed duplicates
  summary(...) # summary at a variable to provide a focused summary. Leave this blank if you want a summary of all selected variables.


# 5. Compare mean turnout between winning parties.

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), summarise() and arrange().
### This Q has been left blank to challenge you code by yourself. Solutions are provided if you get stuck!


# 6. Create columns showing the percentage of male and female (note that this demography is based on total population, not just electorate, so the total numbers are higher that the total electorate).

## Step 1 - create updated demography dataset. Here we will need to use group_by(), mutate(), and ungroup().
## ungroup() allows us to ensure that our new total variable is usable across the data in its original un-grouped format.

Demog_1 <- Long_Demog %>% 
  group_by(...) %>% 
  mutate(total_votes = sum(votes_by_gender))  %>%
  ungroup() #ungroup() is used so that data is returned to ungrouped format

summary(...)

## Step 2 - Create a percentage vote by gender variable (mutate() is your friend here)
New_Demog <- Demog_1 %>% 
  mutate(Percentage_votes_by_gender = (.../...)*100)

# 7. Compare percentage of female population between constituencies.

## Step 1 - update merged dataset, replacing Long_Demog with New_Demog

New_Merged_elec <- merge(Turnout_Elec, ..., by.x="Constituency", by.y="Constit") %>%
mutate_if(is.character, as.factor) #This is provided to make life easier for remaining Q's.

## Step 2 - summarise gender and percentage votes, by gender and by constituency.
### Functions reccomended: select(), group_by(), summarise(), arrange(), distinct(). 
### Tip: when using arrange(), use ".by_group=TRUE" command within the function. This allows the arrangement to occur within groups, making our data easier to read.

Gender_percentage_by_Constituency <- New_Merged_elec %>%
  ...(..., ..., Percentage_votes_by_gender) %>%
  ...(...) %>%
  ...(Gender = Gender,
    Percentage_votes_by_gender = Percentage_votes_by_gender)%>%
  ...(desc(...), .by_group = TRUE) %>% 
  distinct()

summary(...)

# 8. Compare mean age of population by region between winning parties.

## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.

Mean_age_by_region_winning_party <- ... %>%
  ...(..., ..., ..., ...) %>%
  ...(...) %>%
  top_n(n=..., wt = ...) %>% 
  distinct() %>%
 ...(Political_Party = Political_Party,
            Mean_age = Mean_age)%>%
  ...(desc(...), .by_group = ...) 

view(Mean_age_by_region_winning_party)

# 9. Calculate the mean mean_age across all winning parties

## This one is tricky, as you will need to use group_by() and distinct() twice.
## Be sure to provide a mean() to your mean age in the summarise()
## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.

Mean_age_by_winning_party <- ... %>%
  ...(..., ..., ..., ...) %>%
  group_by(...) %>% #Think carefully about which categorical variable you want to group by first
  top_n(n=1, wt = ...) %>% 
  distinct() %>%
  group_by(...) %>% # Group by the second category here to show greater focus within the hierarchy. 
  summarise(... = ..., #define the group you want a count of
            ... = mean(...))%>% # Here we a need a mean of a mean... Just a weird zen concept that we sometimes come across with descriptive statistics.
  ...(desc(...), .by_group = ...)  %>%
  distinct()

view(Mean_age_by_winning_party)

# Feel free to play around with this data, or your own, and we can help answer any questions that arise.
# If you want to play around with plotting/data vis, here's a basic skeleton to experiment with.
# You can also pipe in a solution from above (as I did with the previous example data vis). If you choose to do this, remove your "dataset," from the start of the ggplot command.

ggplot(dataset_name, aes(x = ..., y=..., #fill in and delete the hashtags below to suit your needs.
                        # color = ...,
                        # fill = ..., 
                        # shape = ...,
                         )) +
 # geom_point() + # some layers can be combined, such as geom_point() + geom_smooth()
# geom_smooth(method = "lm") 
# geom_col() # column charts have plenty of ways to customise. Try adding - position = "dodge" if your plot looks a little strange
# +facet_wrap(~...) #faceting allows you to split your charts by a category. Try it to see what happens!

                         

#### END ####
