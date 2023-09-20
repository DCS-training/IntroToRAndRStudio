# Class 2 Solutions

#1. Merge the entirety of the two dataframes together using merge and ensuring that both are the correct case. Change the order of the columns if you like.

## Function used: merge()
##Datasets reccomended: Turnout_Elc, Long_Demog 
## Tip: using "%>% mutate_if(is.character, as.factor)" will save you time.

Merged_elec <- merge(Turnout_Elec, Long_Demog, by.x="Constituency", by.y="Constit") %>% mutate_if(is.character, as.factor)


#2. Which constituency had the highest turnout? 

## Here we recommend using select() to choose your variables, group_by(), summarise() , arrange() and head().
##Within arrange(), you can use desc() to modify the order by which variables are arranged.

### determening lowest turnout
Merged_elec %>% 
  select(Constituency, turnout) %>% # focusing our variables 
 group_by(Constituency) %>% # Grouping by constituency as we want to determine the turnout by constituency
  summarise(Mean_turnout= mean(turnout))  %>% # we use summarise to provide a summarised output by constituency. 
  arrange(Mean_turnout) %>% head() # Arranges data with lowest turnout first

### determening highest turnout
Merged_elec %>% 
  select(Constituency, turnout) %>%
  group_by(Constituency) %>% 
  summarise(Mean_turnout= mean(turnout))  %>%
  arrange(desc(Mean_turnout)) %>% # Arranges data with highest turnout first
  head()

### Which constituency had the highest turnout? 
Merged_elec %>% 
  select(Constituency, turnout) %>%
  group_by(Constituency) %>% 
  summarise(Mean_turnout= mean(turnout))  %>%
  arrange(desc(Mean_turnout)) %>%
  head(n=1) # We use slice to narrow down the output to the highest turnout
 

### Which constituency had the lowest turnout?
Merged_elec %>% 
  select(Constituency, turnout) %>%
  group_by(Constituency) %>% 
  summarise(Mean_turnout= mean(turnout))  %>%
  arrange(Mean_turnout) %>% #by removing desc, we get the lowest.
  slice(1)

#### Tip - You can also just use view (Merged_elec) and click on the Turnout column to arrange by this column.


#3. Output the names of the five constituencies with the highest turnout, and the Region they were each in.

## Again we recommend using select() to choose your variables, group_by(), summarise() arrange(), head()/tail()
## This will also use head(). You can choose how many rows you want to display by defining n within head. 
## You might also choose to use tail(), which provides the reverse of head().

Merged_elec %>% 
  select(Constituency, Region, turnout) %>%
  group_by(Constituency, Region) %>% #Here we have to group_by both Constituency and Region here
  summarise(Mean_turnout= mean(turnout))  %>%
  arrange(desc(Mean_turnout)) %>%
  head(n = 5) # simply define your n to determine how many are displayed


#4. Which party won the most constituency seats? (tip - if using merged dataset here, be sure to remove duplicates, as the gender variable will cause copies so that both male and female are represented)

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), distinct() and summary()

Merged_elec %>%
  select(Constituency, Politcal_Party, votes_earned) %>%
  group_by(Constituency) %>%  # we group by constituency as this is the domain we are interested in. (i.e., political parties win seats in constituencies, so we need to group by constituency).
    top_n(n=1, wt = votes_earned) %>% #top_n() can identify highest value across the grouped variable.
  distinct() %>% #distinct() used to removed duplicates
  summary(Politcal_Party) # summary at Politcal_Party as we are interested in which party won the most seats. Leave this blank if you want a summary of the other selected variables.

##Alternative solution using un-merged dataset  
Turnout_Elec %>%
  select(Constituency, Politcal_Party, votes_earned) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>%
  summary() #No need for 'distinct()' if using Turnout_Elec


#5. Compare mean turnout between winning parties.

## We recommend using select() to choose your variables, group_by(), top_n(n=..., wt=...), summarise() and arrange().

Mean_turnout_by_party <- Turnout_Elec %>%
  select(Constituency, Politcal_Party, votes_earned, turnout) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>%
  summarise(Mean_turnout = mean(turnout),
            Politcal_Party = Politcal_Party) %>%
  arrange(desc(Mean_turnout))

view(Mean_turnout_by_party)

#6. Create columns showing the percentage of male and female (note that this demography is based on total population, not just electorate, so the total numbers are higher that the total electorate).

## Step 1 - create updated demography dataset. Here we will need to use group_by(), mutate(), and ungroup().
## ungroup() allows us to ensure that our new total variable is usable across the data in its original un-grouped format.

Demog_1 <- Long_Demog %>% 
  group_by(Constit) %>% 
  mutate(total_votes = sum(votes_by_gender))  %>%
  ungroup() #ungroup() is used so that data is returned to ungrouped format

## Step 2 - Create a percentage vote by gender variable (mutate() is your friend here)
New_Demog <- Step1 %>% 
  mutate(Percentage_votes_by_gender = (votes_by_gender/total_votes)*100)


#7. Compare percentage of female population between constituencies.

## Step 1 - update merged dataset

New_Merged_elec <- merge(Turnout_Elec, New_Demog, by.x="Constituency", by.y="Constit") %>% mutate_if(is.character, as.factor)

## Step 2 - summarise gender and percentage votes, by gender and by constituency.
### Functions reccomended: select(), group_by(), summarise(), arrange(), distinct(). 
### Tip: when using arrange(), use ".by_group=TRUE" command within the function. 

Gender_percentage_by_Constituency <- New_Merged_elec %>%
  select(Constituency, Gender, Percentage_votes_by_gender) %>%
  group_by(Constituency) %>%
  summarise(Gender = Gender,
    Percentage_votes_by_gender = Percentage_votes_by_gender)%>%
  arrange(desc(Percentage_votes_by_gender), .by_group = TRUE) %>% 
  distinct()

view(Gender_percentage_by_Constituency)

#8. Compare mean age of population by region between winning parties.

## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.

Mean_age_by_region_winning_party <- New_Merged_elec %>%
  select(Constituency, Politcal_Party, Mean_age, votes_earned) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>% 
  distinct() %>%
  summarise(Politcal_Party = Politcal_Party,
            Mean_age = Mean_age)%>%
  arrange(desc(Mean_age), .by_group = TRUE) 

view(Mean_age_by_region_winning_party)

#9. Calculate the mean mean_age across all winning parties

## This one is tricky, as you will need to use group_by() and distinct() twice.
## Be sure to provide a mean() to your mean age in the summarise()
## Functions reccomended: select(), group_by(), top_n(n=..., wt=...), distinct(), summarise(), arrange().
##Remember to arrange by group.

Mean_age_by_winning_party <- New_Merged_elec %>%
  select(Constituency, Politcal_Party, Mean_age, votes_earned) %>%
  group_by(Constituency) %>%
  top_n(n=1, wt = votes_earned) %>% 
  distinct() %>%
  group_by(Politcal_Party) %>% # We group by Politcal_Party again here, as we need greater focus within the hierarchy. 
  summarise(Politcal_Party = Politcal_Party,
            Mean_age = mean(Mean_age))%>% # This is the mean(Mean_age). Just a weird zen concept that we sometimes come across with descriptive statistics.
  arrange(desc(Mean_age), .by_group = TRUE)  %>%
  distinct()

view(Mean_age_by_winning_party)
