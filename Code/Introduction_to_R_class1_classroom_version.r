# #### Introduction to R and RStudio- Class 1 ####

# #### WELCOME TO R STUDIO ####
# This is the interface you are going to get used to

# We have four main windows- console, environment/history, files/plots and the source window.
# The source window shows the file or object you are currently viewing

# The current file is an RScript

# What you are reading now is a comment, and not part of a code in the script, use '#' for a comment, or keyboard shortcut 'shift+ctrl+c'

# THIS IS A LEVEL 1 HEADER #################################

## This Is a Level 2 Header ================================

### This is a level 3 header. ------------------------------

# You can change the visualisation by going to 'Tools > Global Options'
# Use the Soft-wrap R Source files with 'Tools > Global Options > Code > Editing' to prevent text running off screen

# #### Basic Operations and Syntax ####

# ==== Calculations and Operators ====
1+1 # Use 'ctrl+Enter' to run the code on the selected line in the source, or type it out in the console
8*5
11/6*4+2-7

# The output of the calculations should appear in the console below
# The colon ':' basic operator can be used to generate a sequence of numbers
1:5 # Generates the numbers 1-5
1:10

# ==== Functions ====
# Functions can also be used to generate sequences with more control.
seq(10) # Print numbers from 1 to 10
seq(30, 0, by = -5) # Print numbers from 30 to 0 every 3 (note '-' will count down)

# Functions follow the basic syntax of R. Many require inputs/arguments to perform certain tasks

help(seq) # The help() function will provide documentation for the function you input as the argument. This explains the arguments that can be used in the function, among other things.
?seq # ? has the same effect. (You can also just search the function online)

# Arguments are separated by commas ',' and if they are not specified (eg. 'by = ') they should be in the order set out in the function documentation

seq(30,0,-3) # This produces the same result as above, as the order of arguments for seq() is from = , to = , by = .

c(6,7,8,9,10) # c() is a function that combines arguments into a single output

c(6,7,8,9,10, seq(30,0,-3)) # functions can themselves be combined. Note seq() is an argument of c() in this example
# Functions require inputs with (brackets). Remember to open and close. Note seq() is entirely within c() above

# ==== Variables ====
# Variables 'contain' an input, whether it be values or functions
x <- 1:5 # Puts the numbers between 1-5 into the variable x
x # Displays the values we have set in x. x should appear in your environment window

x <- 15
x

Y <- 1+1
Y

y <- 5*5
y

# 'Alt+-' shortcut for <-, to create an assignment statement
# R is case sensitive, 'y' is not the same as 'Y'

y <- c(6,7,8,9,10) # puts numbers between 6-10 in y. Note, this will replace y as 5*5
y

y2 <- c(6,3,4:5,seq(30, 0, by = -3))
y2


# Assign the same value to multiple variables
a <- b <- c <- 3
a
b
c

# ---- Variable Calculations ----
x + y # sum the variable x and the variable y, remember 'x <- 15', and 'y <- c(6,7,8,9,10)'.

1:5 + c(6,7,8,9,10) # This produces the exact same output, because 'x <- 1:5' and 'y <- c(6,7,8,9,10)'

y*2 # multiply each number in x by 2

# To remove variables from the environment, use the rm() function
rm(x) # Remove an object 'x'
rm (a, b) # Remove multiple variables
rm (list = ls()) # Remove all variables in current project. This very simple code uses multiple functions and arguments. Or we can click the little broom image in the Environment box. 

help(rm)
help(ls) # Using help(), we can breakdown what 'rm(list = ls())' is actually doing.

# rm() removes objects based on the arguments inputted. 'list=' is an argument of rm(), that allows a list of objects to be removed. ls(), by default, lists all of the objects in the current working environment. So 'rm(list = ls())' removes all of the objects in the working environment.


# ==== Data types ====
print('Hello World!') # Prints 'Hello World!' in the console
print(1+1)
print('1+1')

# Printing a function will print the output of the function. Using 'inverted commas' will print as a character string. These represent different data types in R.

Numeric   <- c(1, 2, 3) # A numeric object
Character <- c("a", "b", "c", "c") # A character object
Logical   <- c(T, F, T) # A logical/boolean object

Category <- as.factor(Character)

str(Numeric)
str(Character)
str(Logical)
str(Category)
summary(Category)

# The type of data can be changed using as.() functions
T_F_Character <- as.character(c(T, F, T))
str(T_F_Character)

Numeric   <- c(1.3, 2.7, 3.9)
Integer <- as.integer(c(1.3, 2.7, 3.9)) # Note, as.integer() does not round
Integer

Factor <- as.factor(c("a", "b", "c")) # A factor object essentially functions as a logical, but with more than a binary 1 or 0/ TRUE or FALSE.


# Different types of data can and cannot be used as arguments in specific functions. Some cannot be changed to the other, eg., character strings to numeric
A_B_C_Numeric <- as.numeric(c("a", "b", "c"))


# ==== Vectors, Matrices, Arrays and Data Frames ====

# ==== Vector ====
# One dimensional collection of data
y <- c(6,7,8,9,10)
is.vector(y) # is.vector() tests if an input object is a vector and returns a logical TRUE or FALSE.
is.numeric(y)

x <- c("b","d","a","f","h")
is.vector(x)
is.numeric(x)

# Note that both are one dimensional collections of data, ie. vectors. Though one is numeric object, the other character.

# ==== Matrix ====
# Two dimensional collection of data

m1 <- matrix(c(T, T, F, F, T, F), nrow = 3)
m1

m2 <- matrix(c("a", "b","c", "d"), nrow = 2, byrow = F)
m2

is.matrix(m1)

# Both vectors and matrices have data all of the same type

m3 <- matrix(c(1,2,3, "b", 
               "c", "d"), 
             nrow = 2,
             byrow = F)
m3

# ==== Array ====
# Multidimentional collection of data 
# Give data, then dimensions (rows, columns, tables)
a1 <- array(c(1:24), c(4, 3, 2))
a1

# ==== Data Frame ====

# Can combine vectors of the same length
# different type variables (similar to a table in a spreadsheet)
Numeric   <- c(1, 2, 3)
Character <- c("a", "b", "c")
Logical   <- c(T, F, T)

df1 <- c(Numeric, Character, Logical)
df1  # c() Coerces all values to most basic data type, in this case, character
str(df1) # str() checks the structure - here we can see that df1 has a chr format
summary(df1)

df2 <- data.frame(Numeric, Character, Logical)
df2  # Makes a data frame with three different data types
str(df2) # After creating a dataframe, str() provides the format for each seperate column/variable
summary(df2)
df2
head(df2)

# Clear Workspace
rm(list = ls())
cat("\014")  # shortcut 'ctrl+l' (Clears terminal)


# ==== Operations and Functions with Data Frames ====
Numeric1 <- seq(1,100,2)
Numeric2 <- c(5, 20, 50, seq(80, 34, -1))
Numeric3 <- 251:300

df1 <- data.frame(Numeric1,Numeric2,Numeric3) # Create a dataframe
df1
summary(df1)
head(df1, 10)

df2 <- df1*2 # Multiply all values in a dataframe by 2
df2

df3 <- df1 + df2 # Sum all values in two dataframes
df3
summary(df3)
head(df3)
tail(df3)

# ---- The merge() Function and Dataframes ----
Numeric <- as.numeric(c(73, 32, 75, 77))
Character <- as.character(c("Feather", "Borromean", "Triquetra", "Zoso"))
Logical <- as.logical(c(T, F, T, T))
Factor <- as.factor(c("Vocal", "Percussion", "String", "String"))


# Merge two dataframes with no shared columns
df1 <- data.frame(Numeric, Character)
df2 <- data.frame(Logical, Factor)
summary(df1)
summary(df2)

df3 <- merge(df1, df2) 
df3
summary(df3)
head(df3)

summary(df3) # Used to provide a summarised overview of our dataframe

help(merge) # To check the function of merge

# This merges both dataframes simply by adding all possible combinations together in one dataframe.

# We have more control using arguments merge, if there is a shared column. Merge two dataframes with shared column names
Name <- c("Robert", 'John', 'John Paul', 'Jimmy')

df1 <- data.frame(Name, Numeric, Character)
summary(df1)
head(df1)
df2 <- data.frame(Name, Logical, Factor)
summary(df2)
head(df2)
df3 <- merge(df1, df2, by = 'Name')
df3
summary(df3)
head(df3)
# Merge two dataframes with shared column values but different names
df4 <- data.frame(First_name=c("Robert", "John", "John Paul", "Jimmy"), Surname=c("Plant", "Bonham", "Jones", "Page"))

df5 <- merge(df3,df4, by.x = 'Name', by.y = 'First_name') # Note the new arguments by.x and by.y, allowing us to select columns with different names in each of the x (first argument) and y (second argument) dataframes.
df5

# #### Packages ####
# Packages provide some of the most powerful and specific functions in R

# list of packages available by subject
browseURL("https://cran.r-project.org/web/views/")

# list of packages available by name
browseURL("https://cran.r-project.org/web/packages/available_packages_by_name.html")

library() # List the available packages
search() # List the mounted packages

## ==== Install Packages ====
# you can use: tools > Install packages
# or directly
install.packages("ggplot2")
install.packages("tidyverse") # Note that ggplot2 is included in tidyverse
?install.packages

## ==== Mount packages ====
# After installation, packages have to be mounted before they can be used. Packages have to be mounted each time you start a new session, but only installed once.

library(ggplot2)
library(tidyverse)
summary(iris)
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species, size = Sepal.Width , )) +
  geom_point()+
  geom_smooth(method = "lm") +
  facet_wrap(~ Species) +
  labs(x = "Petal Length",
       y = "Petal Width",
       title = "My lovely flower plot",
       subtitle = "I mean it, its really lovely")



# to get info on the packages and browse available examples
browseVignettes(package = "ggplot2" )
browseVignettes() # this would open all available vignettes of all installed packages in your browser

update.packages() # Updates packages, running install.packages("ggplot2") will also update the specific ggplot2 package

# ==== To unload packages ====
# unflag or reboot (everytime you close the system the non default packages will be unloaded)
detach ("package:tidyverse", unload = TRUE)


# ==== Next Week ====
# Using additional functions and packages, we can make dataframes easier to work with and read, but this data wrangling will be explained in detail during next weeks class.

library(tidyverse)

colnames(df5) <- c("First Name", "Age", "Sigil", "Active", "Instrument", "Surname")
df5
summary(df5)
Led_Zeppelin <- select(df5, c(Age, Sigil))
Led_Zeppelin

# #### END ####
