# Class 2 Solutions

# Merge the entirety of the two dataframes together using merge and ensuring that both are the correct case. Change the order of the columns if you like.

Merged_elec <- merge(Elec, Demog, by.x="Constituency", by.y="Constit")
Merged_elec[,1] <- str_to_title(Merged_elec[,1]) 

# Which constituency had the highest turnout?
# Rows can be arranged to convey the highest or lowest value of certain columns
Low_turnout <- Merged_elec %>%
  arrange(turnout) # Arranges data with lowest turnout first
view(Low_turnout)

High_turnout <- Merged_elec %>%
  arrange(desc(turnout)) # Arranges data with highest turnout first
view(High_turnout)

Merged_elec %>%
  arrange(desc(turnout)) %>%
  slice(1) %>%
  select(Constituency) # Output constituency with highest single turnout.

# Which constituency had the lowest turnout?
Merged_elec %>%
  arrange(turnout) %>%
  slice(1) %>%
  select(Constituency) # Output constituency with lowest single turnout.

# You can also just use view(Merged_elec) and click on the Turnout column to arrange by this column.

# Output the names of the five constituencies with the highest turnout, and the Region they were each in.
Merged_elec %>%
  arrange(desc(turnout)) %>%
  slice(1:5) %>%
  select(Constituency, Region)

# Which party won the most constituency seats?

Merged_elec %>%
  count(first_party) %>%
  arrange(desc(n))

Merged_elec %>%
  count(first_party) %>%
  arrange(desc(n)) %>%
  slice(1)

length(which(Merged_elec$first_party == 'CON')) # See the total count for specific occurrences. 
length(which(Merged_elec$first_party == 'SNP'))

# Compare mean turnout between winning parties.

Mean_turnout_by_party <- Elec %>%
         group_by(first_party) %>%
         summarise(Mean_turnout = mean(turnout)) %>%
         arrange(desc(Mean_turnout))

view(Mean_turnout_by_party)

# Create columns showing the percentage of male and female (note that this demography is based on total population, not just electorate, so the total numbers are higher that the total electorate).

Merged_elec$Female_perc <- (Merged_elec$Female/(Merged_elec$Female + Merged_elec$Male))*100
Merged_elec$Male_perc <- (Merged_elec$Male/(Merged_elec$Female + Merged_elec$Male))*100

# Compare percentage of female population between winning parties.

Female_percentage_by_party <- Merged_elec %>%
  group_by(first_party) %>%
  summarise(F_perc = mean(Female_perc)) %>%
  arrange(desc(F_perc))

view(Female_percentage_by_party)

# Compare mean age of population between winning parties.
Mean_age_by_party <- Merged_elec %>%
  group_by(first_party) %>%
  summarise(Mean_age = mean(Mean_age)) %>%
  arrange(desc(Mean_age))

view(Mean_age_by_party)

# Create a row with the Scotland wide total values for each column. For percentages, calculate mean values. You will also have to subset to discount character data and input your own value for these separately.  
Merged_elec["Total",c(3:11,14,15)] <- colSums(Merged_elec[,c(3:11,14,15)]) # Sum the column totals for the non character and non-percentage columns.

Merged_elec["Total",c(13,16:18)] <- colMeans(Merged_elec[1:73,c(13,16:18)]) # Be sure to exclude the empty Total row, or you will get NA values.

Merged_elec$Region <- as.character(Merged_elec$Region) # As 'Scotland' isn't a level in the Region factor, we need to change Region back to a character object to add a new level.
Merged_elec["Total",c(1,2,12)] <- c("Total", "Scotland", "SNP") # Manually add character 'totals'
Merged_elec$Region <- as.factor(Merged_elec$Region)

