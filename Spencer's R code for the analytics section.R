# Spencer Marlen-Starr's R code for his Project Objective

getwd()
setwd('C:/Users/spenc/OneDrive/Documents/George Mason University/Spring 2021/CS 504/Group Project/My contributions')

# load the libraries I will need
library(plm)
library(tidyverse)
library(rstatix)
library(coin)
library(fBasics)
library(canprot)
library(radiant)
library(lubridate)
library(RMariaDB)


mysqldb.connStrfile<-"C:\\Users\\spenc\\OneDrive\\Documents\\George Mason University\\Spring 2021\\CS 504\\Group Project\\AWS\\passwd.txt"
mysqldb.db<-"SMIL"
dbConn <- dbConnect(RMariaDB::MariaDB(),default.file=mysqldb.connStrfile,group=mysqldb.db)

dbListTables(dbConn)






# import a left join of the daily dataset and household
# information tables with only records during 2013 included
# into RStudio as a data frame
dd_hi <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31'; ")

str(dd_hi)

# change the datetime column to a date column
dd_hi$day <- ymd(dd_hi$day)

# add a numerical ID column
dd_hi$id <- substr(dd_hi$LCLid, 4, 9)
dd_hi$id <- as.integer(dd_hi$id)
dd_hi$LCLid <- dd_hi$id   # optional


# convert the stdorToU variable which is currently a chr variable to a factor
dd_hi$stdorToU <- as.factor(dd_hi$stdorToU)

# add a dummy variable column for time of use houses
dd_hi$ToU_dummy <- ifelse(dd_hi$stdorToU == "ToU", 1, 0)


# convert the Acorn_grouped column to a factor
dd_hi$Acorn_grouped <- as.factor(dd_hi$Acorn_grouped)

# add a dummy variable for affluent households
dd_hi$Affluent_dummy <- ifelse(dd_hi$Acorn_grouped == "Affluent", 1, 0)
# add a dummy variable for comfortable households
dd_hi$Comfortable_dummy <- ifelse(dd_hi$Acorn_grouped == "Comfortable", 1, 0)
# add a dummy variable for households facing financial adversity
dd_hi$Adversity_dummy <- ifelse(dd_hi$Acorn_grouped == "Adversity", 1, 0)
# add a dummy variable for households in the Acorn group "Acorn-U"
dd_hi$AcornU_dummy <- ifelse(dd_hi$Acorn_grouped == "ACORN-U", 1, 0)

# add a dummy variable for households in the Acorn-A
dd_hi$AcornA_dummy <- ifelse(dd_hi$Acorn == "ACORN-A", 1, 0)
# add a dummy variable for households in the Acorn-B
dd_hi$AcornB_dummy <- ifelse(dd_hi$Acorn == "ACORN-B", 1, 0)
# add a dummy variable for households in the Acorn-C
dd_hi$AcornC_dummy <- ifelse(dd_hi$Acorn == "ACORN-C", 1, 0)
dd_hi$AcornD_dummy <- ifelse(dd_hi$Acorn == "ACORN-D", 1, 0)
dd_hi$AcornE_dummy <- ifelse(dd_hi$Acorn == "ACORN-E", 1, 0)
dd_hi$AcornF_dummy <- ifelse(dd_hi$Acorn == "ACORN-F", 1, 0)
dd_hi$AcornG_dummy <- ifelse(dd_hi$Acorn == "ACORN-G", 1, 0)
dd_hi$AcornH_dummy <- ifelse(dd_hi$Acorn == "ACORN-H", 1, 0)
dd_hi$AcornI_dummy <- ifelse(dd_hi$Acorn == "ACORN-I", 1, 0)
dd_hi$AcornJ_dummy <- ifelse(dd_hi$Acorn == "ACORN-J", 1, 0)
dd_hi$AcornK_dummy <- ifelse(dd_hi$Acorn == "ACORN-K", 1, 0)
dd_hi$AcornL_dummy <- ifelse(dd_hi$Acorn == "ACORN-L", 1, 0)
dd_hi$AcornM_dummy <- ifelse(dd_hi$Acorn == "ACORN-M", 1, 0)
dd_hi$AcornN_dummy <- ifelse(dd_hi$Acorn == "ACORN-N", 1, 0)
dd_hi$AcornO_dummy <- ifelse(dd_hi$Acorn == "ACORN-O", 1, 0)
# add a dummy variable for households in the Acorn-P
dd_hi$AcornP_dummy <- ifelse(dd_hi$Acorn == "ACORN-P", 1, 0)
# add a dummy variable for households in the Acorn-Q
dd_hi$AcornQ_dummy <- ifelse(dd_hi$Acorn == "ACORN-Q", 1, 0)

dd_hi
str(dd_hi)
categories <- unique(dd_hi$Acorn_grouped) 
categories
categories2 <- unique(dd_hi$Acorn)
categories2
categories3 <- unique(dd_hi$file)
categories3
length(categories3)
categories4 <- unique(dd_hi$id)
categories4
length(categories4)


# create a new dataframe without the duplicate LCLid column
dd_hi_2013 <- dd_hi[c(1:5, 8, 11, 13, 16:37)]
dd_hi$LCLid <- dd_hi$id
str(dd_hi_2013)





dd_hi_ToU <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND 
informations_households.stdorToU = 'ToU' AND energy_sum IS NOT NULL; ")
class(dd_hi_ToU)
str(dd_hi_ToU)

summary(dd_hi_ToU$energy_sum)
kurtosis(dd_hi_ToU$energy_sum)
skewness(dd_hi_ToU$energy_sum)

kurtosis(dd_hi_ToU$energy_sum, na.rm = FALSE, method = c("excess", "moment", "fisher"))

summary(dd_hi_ToU$energy_max)
skewness(dd_hi_ToU$energy_max)
kurtosis(dd_hi_ToU$energy_max)


dd_hi_Std <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND 
informations_households.stdorToU = 'Std' AND energy_sum IS NOT NULL; ")
class(dd_hi_Std)
str(dd_hi_Std)

summary(dd_hi_Std$energy_sum)
kurtosis(dd_hi_Std$energy_sum)
skewness(dd_hi_Std$energy_sum)

summary(dd_hi_Std$energy_max)
kurtosis(dd_hi_Std$energy_max)
skewness(dd_hi_Std$energy_max)


 


# also run a Wilcoxon Rank Sum Test on the sum of daily energy 
# use because the daily usage data appears to have 
# much more variation than a Gaussian distribution
n1 <- 4567
n2 <- 1100

n3 <- length(dd_hi_2013$energy_sum[dd_hi_2013$stdorToU == "Std"])
n3
n4 <- length(dd_hi_2013$energy_sum[dd_hi_2013$stdorToU == "ToU"])
n4

dd_hi_2013 <- round_df(dd_hi_2013, dec = 2)
head(dd_hi_2013)
attach(dd_hi_2013)

rm(Std)
ToU_sum <- dd_hi_2013$energy_sum[dd_hi_2013$stdorToU == "ToU"]
class(ToU)
head(ToU)
tail(ToU)
Std_sum <- dd_hi_2013$energy_sum[dd_hi_2013$stdorToU == "Std"]

CLES(ToU_sum, Std_sum, distribution = NA)


?wilcox.test
wilcox.test(energy_sum ~ stdorToU, mu = 0, alternative = "greater", 
            conf.int = TRUE, paired = FALSE)
U1 <- wilcox.test(energy_sum ~ stdorToU, mu = 0, alternative = "greater", 
            conf.int = TRUE, paired = FALSE)
(n1*(n1 + 1))/2
U1$statistic <- U1$statistic + (n1*(n1 + 1))/2
names(U1$statistic)
str(U1)
class(U1)
U1


W1 <- U1[[1]]
W1

# calculate the common language effect size
f1 = W1/(n3 * n4)
f1

# add a dummy variable column for standard households
dd_hi$Std_dummy <- ifelse(dd_hi_2013$stdorToU == "Std", 1, 0)

wilcox.test(ToU_dummy, energy_sum, mu = 0, alternative = 'l', 
            paired = FALSE)

wilcox.test(Std_dummy, energy_sum, alternative = 'g', 
            paired = FALSE)



# also run a Wilcoxon Rank Sum Test on the max amount of daily energy usage
wilcox.test(energy_max ~ stdorToU, data = dd_hi, alternative = "greater")

U2 <- wilcox.test(energy_max ~ stdorToU, mu = 0, alternative = "greater",
            conf.int = TRUE, paired = FALSE)
U2$statistic <- U2$statistic + (n1*(n1 + 1))/2
U2



# calculate the Wilcoxon effect size of the difference
dd_hi %>% wilcox_effsize(energy_sum ~ stdorToU, paired = FALSE,
                         alternative = "greater", mu = 0, ci = FALSE,
                         conf.level = 0.95, ci.type = "perc", nboot = 1000)

# calculate the Wilcoxon effect size of the difference
dd_hi %>% wilcox_effsize(energy_max ~ stdorToU, paired = FALSE,
               alternative = "greater", mu = 0, ci = FALSE,
               conf.level = 0.95, ci.type = "perc", nboot = 1000)






# estimate a fixed effects regression of the impacts of time of use
# energy pricing on total daily energy use with plm()
# Status <- cbind(Affluent_dummy, Comfortable_dummy, Adversity_dummy, AcornU_dummy)
# Acorn <- cbind(AcornA_dummy, AcornB_dummy, AcornC_dummy, AcornD_dummy, AcornE_dummy,
# AcornF_dummy, AcornG_dummy, AcornH_dummy, AcornI_dummy, AcornJ_dummy, AcornK_dummy,
# AcornL_dummy, AcornM_dummy, AcornN_dummy, AcornO_dummy, AcornP_dummy, AcornQ_dummy)
# file <- dd_hi$file
# entity_FEs <- cbind(Status, Acorn)
# str(entity_FEs)
# head(entity_FEs)

df <- dd_hi[c(1:9, 11:36)]
head(df)
str(df)
rm(df)
attach(dd_hi_2013)
# fixed effects regression specification for energy_sum
Total_Energy_FE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                  Adversity_dummy + AcornU_dummy + AcornA_dummy + AcornB_dummy 
                  + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                  + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                  + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                  + AcornO_dummy + AcornP_dummy, 
                   data = dd_hi_2013, model = "within", index = "day")
summary(Total_Energy_FE)


# random effects regression specification for energy_sum
Total_Energy_RE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                           Adversity_dummy  + AcornU_dummy + AcornA_dummy + AcornB_dummy 
                       + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                       + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                       + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                       + AcornO_dummy + AcornP_dummy, 
                       data = dd_hi_2013, model = "random", index = "day")
summary(Total_Energy_RE)

# run a Hausman test to see whether I should use fixed effects or random effects
phtest(Total_Energy_FE, Total_Energy_RE)







# run a FE and a RE on the data but with energy_max as the dependent variable 
EnergyMax_FE <- plm(formula = energy_max ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                        Adversity_dummy + AcornU_dummy + AcornA_dummy + AcornB_dummy 
                    + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                    + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                    + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                    + AcornO_dummy + AcornP_dummy, 
                    data = dd_hi_2013, model = "within", index = "day")
summary(EnergyMax_FE)



# estimate a random effects regression model
EnergyMax_RE <- plm(formula = energy_max ~ ToU_dummy + Affluent_dummy + 
                  Comfortable_dummy + Adversity_dummy + AcornU_dummy + 
                  AcornA_dummy + AcornB_dummy + AcornC_dummy + AcornD_dummy +
                  AcornE_dummy + AcornF_dummy + AcornG_dummy + AcornH_dummy +
                  AcornI_dummy + AcornJ_dummy + AcornK_dummy + AcornL_dummy +
                  AcornM_dummy + AcornN_dummy + AcornO_dummy + AcornP_dummy, 
                  data = dd_hi_2013, index = "day", model = "random")
summary(EnergyMax_RE)

# run a Hausman test to see whether I should use fixed effects or random effects
phtest(EnergyMax_FE, EnergyMax_RE)

