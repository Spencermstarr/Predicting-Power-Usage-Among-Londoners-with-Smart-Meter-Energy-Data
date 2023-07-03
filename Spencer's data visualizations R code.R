# Spencer's R code for the data visualization part of the group project


getwd()
setwd('C:/Users/spenc/OneDrive/Documents/George Mason University/Spring 2021/CS 504/Group Project/My contributions')

# load the libraries I will need
library(dplyr)
library(lubridate)
library(RMariaDB)
library(ggplot2)



mysqldb.connStrfile<-"C:\\Users\\spenc\\OneDrive\\Documents\\George Mason University\\Spring 2021\\CS 504\\Group Project\\AWS\\passwd.txt"
mysqldb.db<-"SMIL"
dbConn <- dbConnect(RMariaDB::MariaDB(),default.file=mysqldb.connStrfile,group=mysqldb.db)

dbListTables(dbConn)



# import a left join of the daily dataset and household
# information tables into RStudio as a data frame that
# only includes records during 2013
dd_hi <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31'; ")

# change the datetime column to a date column
dd_hi$day <- ymd(dd_hi$day)

# add a numerical ID column
dd_hi$id <- substr(dd_hi$LCLid, 4, 9)
dd_hi$id
dd_hi$id <- as.integer(dd_hi$id)

# convert the stdorToU variable/column which is currently a 
# chr variable to a factor
dd_hi$stdorToU <- as.factor(dd_hi$stdorToU)
str(dd_hi$stdorToU)

# add a dummy variable column for time of use houses
dd_hi$ToU_dummy <- ifelse(dd_hi$stdorToU == "ToU", 1, 0)

str(dd_hi)
dd_hi
class(dd_hi$energy_count)




hist(dd_hi_ToU$energy_sum,
     xlab = 'Total Daily Energy Consumption Level',
     ylab = 'Frequency',
     main = 'Histogram of energy_sum for the treatment group',
     xlim = c(0, 100), breaks = c(0, seq(10, 200, 10)))


hist(dd_hi_Std$energy_sum,
     xlab = 'Total Daily Energy Consumption Level',
     ylab = 'Frequency',
     main = 'Histogram of energy_sum for the control group', 
     xlim = c(0, 100), breaks = c(0, seq(10, 350, 10)))



    
    
    
# create a Q-Q plot of the daily_dataset for the energy_sum versus
# whether a house is on time of use pricing or not
qqplot(dd_hi$energy_sum[dd_hi$ToU_dummy == 1],
       dd_hi$energy_sum[dd_hi$ToU_dummy == 0],
       xlab = 'Houses on Dynamic Time of Use Energy Rate',
       ylab = 'Houses on the Standard Flat Energy Rate',
       main = 'Q-Q Plot of Total Daily Energy Usage vs Time of Use Pricing')



# create a Q-Q plot of the distribution of the energy_sum column in the 
# daily_dataset table for all households
qqnorm(dd_hi$energy_sum, main = 'Q-Q Plot of the Observed Distribution of energy_sum \nvs a Theoretical Gaussian')
qqline(dd_hi$energy_sum)


# create a Q-Q plot of the distribution of the energy_sum column in the 
# daily_dataset table for houses on time of use pricing 
# versus the Normal distribution
qqnorm(dd_hi$energy_sum[dd_hi$ToU_dummy == 1],
       xlab = 'Theoretical Quantiles',
       ylab = 'Sample Quantiles', 
main = 'Q-Q Plot of the Observed Distribution of energy_sum for \nToU Houses vs a Theoretical Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 1])

#create a Q-Q plot of the distribution of the energy_sum column in the 
# daily_dataset table for houses on flat rate pricing 
# versus the standard "Normal" distribution
qqnorm(dd_hi$energy_sum[dd_hi$ToU_dummy == 0],
       xlab = 'Theoretical Quantiles',
       ylab = 'Sample Quantiles', 
       main = 'Q-Q Plot of the Observed Distribution of energy_sum for \nStandard Houses vs a Theoretical Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 0])





# create a Q-Q plot of the distribution of the energy_max field 
# in the daily_dataset table for all households
qqnorm(dd_hi$energy_max, 
main = 'Q-Q Plot of the Observed Distribution of energy_max \nvs a Theorical Gaussian Distribution')
qqline(dd_hi$energy_max)



q1 <- qqnorm(dd_hi$energy_max[dd_hi$ToU_dummy == 1],
       xlab = 'Theoretical Quantiles',
       ylab = 'Sample Quantiles', 
       main = 'Q-Q Plot of the Observed Distribution of energy_max for \nToU Houses vs a Theoretical Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 1])



qqnorm(dd_hi$energy_max[dd_hi$ToU_dummy == 0], xlab = 'Theoretical Quantiles',
       ylab = 'Sample Quantiles', 
       main = 'Q-Q Plot of the Observed Distribution of energy_max for \nStd Houses vs a Theoretical Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 0])


graph(par(mfrow=c(1, 2)))