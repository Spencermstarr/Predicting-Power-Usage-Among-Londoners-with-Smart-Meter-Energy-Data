library(rlang)
for(RPkg in c("DBI", "ggplot2", "plyr", "dplyr", "pander", "Metrics","summarytools", "tidyverse", "corrr", "PerformanceAnalytics",
             "corrplot", "stringi", "rpart.plot", "Hmisc", "ggcorrplot", "sqldf", "RMariaDB" , "gclus", "psych", "viridis", 
             "forestmangr", "nortest", "tidyquant", "tseries", "plotly", "lubridate", "randomForest","rms", "MASS", "caret", "rpart", "scales", 
             "purrr", "caTools", "tidyr", "stringr", "gdata")){
  eval(bquote(library(.(RPkg))))
}

# change the path to the filesystem location where you decide to save the SQLite database

mysqldb.connStrfile<-"C:\\Users\\Stavros Kalamatianos\\Downloads\\GMU\\Courses\\CS504\\Project\\passwd.txt"
mysqldb.db<-"SMIL"
dbConn<-dbConnect(RMariaDB::MariaDB(),default.file=mysqldb.connStrfile,group=mysqldb.db)

dbListTables(dbConn)

outlierLessAvg <- function(v){
    q <- quantile(v, probs=c(.25, .75), na.rm = TRUE)
    iqr <- IQR(v)
    
    upper <-  q[2]+1.5*iqr # upper outlier cutoff  
    lower <- q[1]-1.5*iqr  # lower outlier cutoff
    
    m <- v[v<upper][v>lower]
    m <- m[!is.na(m)]
    
    mn <- mean(m, trim=0, na.rm = TRUE)
    mn <- as.numeric(format(round(mn, 2), nsmall = 2))
    
    results <- shapiro.test(v[!is.na(v)])
    SWstatistic <- as.numeric(gsub('.*-([0-9]+).*','\\1',results$statistic))
    SWpValue <- as.numeric(results$p.value)

    r <- c(lower, upper, mn, SWstatistic, SWpValue)
    return(r)
}

hhblocks <- dbGetQuery(dbConn, 
"
select hh1.day, hh2.numbSmMtrs, hh_0, hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, hh_7, hh_8, hh_9, hh_10, hh_11, hh_12, hh_13, hh_14, hh_15, hh_16, hh_17, hh_18, hh_19, hh_20, hh_21, hh_22, hh_23, hh_24, hh_25, hh_26, hh_27, hh_28, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47
from 
(
    select day, sum(hh_0) as hh_0, sum(hh_1) as hh_1,  sum(hh_2) as hh_2,  sum(hh_3) as hh_3,  sum(hh_4) as hh_4,  sum(hh_5) as hh_5,  sum(hh_6) as hh_6,  sum(hh_7) as hh_7,  sum(hh_8) as hh_8,  sum(hh_9) as hh_9,  sum(hh_10) as hh_10,  sum(hh_11) as hh_11,  sum(hh_12) as hh_12,  sum(hh_13) as hh_13,  sum(hh_14) as hh_14,  sum(hh_15) as hh_15,  sum(hh_16) as hh_16,  sum(hh_17) as hh_17,  sum(hh_18) as hh_18,  sum(hh_19) as hh_19,  sum(hh_20) as hh_20,  sum(hh_21) as hh_21,  sum(hh_22) as hh_22,  sum(hh_23) as hh_23,  sum(hh_24) as hh_24,  sum(hh_25) as hh_25,  sum(hh_26) as hh_26,  sum(hh_27) as hh_27,  sum(hh_28) as hh_28,  sum(hh_29) as hh_29,  sum(hh_30) as hh_30,  sum(hh_31) as hh_31,  sum(hh_32) as hh_32,  sum(hh_33) as hh_33,  sum(hh_34) as hh_34,  sum(hh_35) as hh_35,  sum(hh_36) as hh_36,  sum(hh_37) as hh_37,  sum(hh_38) as hh_38,  sum(hh_39) as hh_39,  sum(hh_40) as hh_40,  sum(hh_41) as hh_41,  sum(hh_42) as hh_42,  sum(hh_43) as hh_43,  sum(hh_44) as hh_44,  sum(hh_45) as hh_45,  sum(hh_46) as hh_46,  sum(hh_47) as hh_47
    from hhblock
    group by day
) as hh1
left outer join
(
    select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day
) as hh2
on hh1.day = hh2.day
;
"
)

# which(is.na(as.numeric(as.character(hhblocks[2:48]))))
# hhblocks[,3:50][hhblocks[,3:50]==""]<-NA
# hhblocks[,3:50][hhblocks[,3:50]==" "]<-NA

hhblocks_stats <- cbind(hhblocks[,1:50], apply(hhblocks[,3:50], 1, outlierLessAvg)[1,], apply(hhblocks[,3:50], 1, outlierLessAvg)[2,], apply(hhblocks[,3:50], 1, outlierLessAvg)[3,], apply(hhblocks[,3:50], 1, outlierLessAvg)[4,], apply(hhblocks[,3:50], 1, outlierLessAvg)[5,])

# assigns column names to appended columns and renames column 1
names(hhblocks_stats)[1] <-  'time'
names(hhblocks_stats)[51] <- 'lowerOutlCutoff'
names(hhblocks_stats)[52] <- 'upperOutlCutoff'
names(hhblocks_stats)[53] <- 'outlierLessAvg'
names(hhblocks_stats)[54] <- 'SWstatistic'
names(hhblocks_stats)[55] <- 'SWpValue'
hhblocks_stats$outlierLessAvg <- hhblocks_stats$outlierLessAvg/hhblocks$numbSmMtrs

hhblocks_stats$time <- as.character(hhblocks_stats$time)
hhblocks_stats$time <- trim(hhblocks_stats$time)
hhblocks_stats <- hhblocks_stats %>% mutate(time = str_replace(time, " ", "|")) %>% separate(time, into = c("timeDate", "timeTime"), sep = "\\|")

head(hhblocks_stats)

options(repr.plot.width = 20, repr.plot.height = 10)

vars <- c("timeDate", "SWstatistic", "SWpValue")
hhblocks_stats_sub <- hhblocks_stats[vars]

hhblocks_stats_sub$timeDate <- as.Date(hhblocks_stats_sub$timeDate)

ggplot()+   
  geom_line(data=hhblocks_stats_sub, aes(x=timeDate,y=SWstatistic,col="Shapiro Test statistic"))+
  scale_y_continuous(breaks=seq(0,1,0.05), sec.axis = sec_axis(~.*1, name = "Shapiro Test p-Value", breaks=seq(0,1,0.05)))+
  scale_x_date(date_breaks = "months" , date_labels = "%m-%Y")+
  geom_line(data=hhblocks_stats_sub, aes(x=timeDate, y=SWpValue, col="Shapiro Test p-value"))+
  geom_hline(yintercept=0.05, linetype="dashed", color = "black", size = 1) +
  geom_hline(yintercept=0.01, linetype="dashed", color = "blue", size = 1) +
  scale_color_manual(values=c("red","blue"),
                     labels=c("p-Value","statistic"))+
  labs(title = "Shapiro Test statistic and p-Value across Time",
       x = "Month-Year",
       y = "statistic") +
theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=18, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "violetred4", size = 15), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm"))

ggplot(data = hhblocks_stats_sub, aes(x = SWstatistic, y = SWpValue)) +
  geom_point(aes(color = SWstatistic), size=1.2, linetype = "solid") + 
  labs(x='statistic', y='p-Value') +
  geom_hline(yintercept=0.05, linetype="dashed", color = "red", size = 1) +
  geom_hline(yintercept=0.01, linetype="dashed", color = "magenta", size = 1) +
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) +
  scale_y_continuous(labels = scales::comma_format(big.mark = ',', decimal.mark = '.'), trans='log10') +
  scale_x_continuous(breaks=seq(0,1,0.005))

weathDaily <- dbGetQuery(dbConn, 
"
Select 
trim(substring(convert(time, char(20)),1,locate(' ', time))) as time
, temperatureMax
,temperatureMaxTime
,windBearing
,icon
,dewPoint
,temperatureMinTime
,cloudCover
,windSpeed
,pressure
,apparentTemperatureMinTime
,apparentTemperatureHigh
,precipType
,visibility
,humidity
,apparentTemperatureHighTime
,apparentTemperatureLow
,apparentTemperatureMax
,uvIndex
,sunsetTime
,temperatureLow
,temperatureMin
,temperatureHigh
,sunriseTime
,temperatureHighTime
,uvIndexTime
,summary
,temperatureLowTime
,apparentTemperatureMin
,apparentTemperatureMaxTime
,apparentTemperatureLowTime
,moonPhase
from weather_daily_darksky wdd ;
"
)

# head(hhblocks_stats)
# head(weathDaily)

weathDailyhhblocks <- left_join(hhblocks_stats, weathDaily, by = c("timeDate"="time"))
weathDailyhhblocks$timeDate <- as.Date(weathDailyhhblocks$timeDate)
# head(weathDailyhhblocks)

head(weathDailyhhblocks)

options(repr.plot.width = 20, repr.plot.height = 10)

ggplot()+   
  geom_line(data=weathDailyhhblocks, aes(x=timeDate,y=outlierLessAvg,col="Consumption"))+
  scale_y_continuous(sec.axis = sec_axis(~.*60, name = "Average Temperature [Celsius]"))+
  scale_x_date(date_breaks = "months" , date_labels = "%m-%Y")+
  geom_line(data=weathDailyhhblocks, aes(x=timeDate, y=((temperatureMin + temperatureMax)/2)/60, col=" Avg Temperature"))+
  scale_color_manual(values=c("red","blue"),
                     labels=c("Temperature","Electricity Consumption"))+
  labs(title = "Daily Half Hour Avg [OUTLIERS FREE] Electricity Consumption across all monitored Smart Meters measured in KWhs vs Average Temperature in degrees Celsius",
       x = "Month-Year",
       y = "Daily 1/2 hr Average Electricity Consumption [KWhs]") +
theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=18, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "violetred4", size = 15), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) 

enrgConsvsTemp <- dbGetQuery(dbConn, 
"
select cast(dd.day as date) as day, cast(dd.all_meter_day_energy_mean as decimal(6,4)) as all_meter_day_energy_mean, wdd.temperatureMin, wdd.temperatureMax 
FROM 
(
select day, sum(energy_sum) / sum(energy_count) as all_meter_day_energy_mean
from daily_dataset
group by day
) dd
left outer join
weather_daily_darksky wdd
on substring(dd.day, 1, locate(' ', dd.day)) = substring(wdd.time, 1, locate(' ', wdd.time)) 
order by day
;
"
)

head(enrgConsvsTemp)

options(repr.plot.width = 20, repr.plot.height = 10)

ggplot()+   
  geom_line(data=enrgConsvsTemp, aes(x=day,y=all_meter_day_energy_mean,col="Consumption"))+
  scale_y_continuous(sec.axis = sec_axis(~.*60, name = "Average Temperature [Celsius]"))+
  scale_x_date(date_breaks = "months" , date_labels = "%m-%Y")+
  geom_line(data=enrgConsvsTemp, aes(x=day, y=(temperatureMin + temperatureMax)/2/60, col="Temperature"))+
  scale_color_manual("",values=c("blue","red"),
                     labels=c("Electricity Consumption","Temperature"))+
  labs(title = "Daily Avg Electricity Consumption across all monitored Smart Meters measured in KWhs vs Avg Temperature in degrees Celsius",
       x = "Month-Year",
       y = "Daily Average Electricity Consumption [KWhs]") +
theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "violetred4", size = 15), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) 

acornEnrgCons <- dbGetQuery(dbConn, 
"
select cast(day as date) as day, Acorn_grouped, sum(energy_sum) / sum(energy_count) as all_meter_day_energy_mean
FROM 
(
SELECT dd.LCLid , dd.day, ih.Acorn_grouped, energy_sum , energy_count 
FROM daily_dataset dd 
left outer join
informations_households ih
on ih.LCLid = dd.LCLid 
) hih 
group by day, Acorn_grouped
;
"
)

ggplot(acornEnrgCons, aes(x = day, y = all_meter_day_energy_mean)) + 
  geom_line(aes(color = Acorn_grouped), size=1.2, linetype = "solid") +
  scale_color_manual(values = c("orange3", "purple2", "red2", "green", "brown")) +
  labs(x='Month-Year', y='Daily Average Electricity Consumption [KWhs]') +
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) +
  scale_y_continuous(labels = scales::comma_format(big.mark = ',', decimal.mark = '.')) +
scale_x_date(date_breaks = "months" , date_labels = "%m-%Y")

ctrlExpEnrgCons <- dbGetQuery(dbConn, 
"
select cast(day as date) as day, stdorToU, sum(energy_sum) / sum(energy_count) as all_meter_day_energy_mean
FROM 
(
SELECT dd.LCLid , dd.day, ih.stdorToU, energy_sum , energy_count 
FROM daily_dataset dd 
left outer join
informations_households ih
on ih.LCLid = dd.LCLid 
) hih 
group by day, stdorToU 
;
"
)

ggplot(ctrlExpEnrgCons, aes(x = day, y = all_meter_day_energy_mean)) + 
  geom_line(aes(color = stdorToU), size=1.2, linetype = "solid") +
  scale_color_manual(values = c("red2", "green")) +
  labs(x='day', y='all_meter_day_energy_mean') +
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) +
  scale_y_continuous(labels = scales::comma_format(big.mark = ',', decimal.mark = '.')) +
scale_x_date(date_breaks = "months" , date_labels = "%m-%Y")

weathEnrgCons <- dbGetQuery(dbConn, 
"
select Avg_Energy_Consump,  temperature, humidity
from daily_dataset_hhblocks_byHour a
left outer join
weather_hourly_darksky b
on a.`day` = b.`time`
;
"
)

chart.Correlation(weathEnrgCons, histogram=TRUE, method="pearson", pch=19)

weathHourly <- dbGetQuery(dbConn, 
"
select time, temperature, humidity, precipType 
from weather_hourly_darksky
;
"
)

weathHourly <- weathHourly %>% mutate(time = str_replace(time, " ", "|")) %>% separate(time, into = c("timeDate", "timeTime"), sep = "\\|")
weathHourly$timeDate <- trim(weathHourly$timeDate)
weathHourly$timeTime <- trim(weathHourly$timeTime)
weathHourly$humidity <- 100*(weathHourly$humidity)

head(weathHourly)

vars <- c("timeDate", "timeTime", "temperature")
htMapTimeTemp <- weathHourly[vars]

htMapTimeTemp$weekday = as.POSIXlt(htMapTimeTemp$timeDate)$wday #finding the day numb of the week
htMapTimeTemp$weekdayf<-factor(htMapTimeTemp$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE) #converting the day numb to factor 
htMapTimeTemp$weekdayf[is.na(htMapTimeTemp$weekdayf)] <- "Sun"
htMapTimeTemp$monthf<-factor(month(htMapTimeTemp$timeDate),levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE) # finding the month 
htMapTimeTemp$yearmonth<- factor(as.yearmon(htMapTimeTemp$timeDate)) #finding the year and the month from the date. Eg: Nov 2012 
htMapTimeTemp$week <- as.numeric(week(htMapTimeTemp$timeDate)) #finding the week of the year for each date 
htMapTimeTemp<-ddply(htMapTimeTemp,.(yearmonth),transform,monthweek=1+week-min(week)) #normalizing the week to start at 1 for every month 

ggplot(htMapTimeTemp, aes(monthweek, weekdayf, fill = temperature)) + 
geom_tile(colour = "white") + 
facet_grid(year(htMapTimeTemp$timeDate)~monthf) + 
scale_fill_gradient(low="green", high="red") + 
xlab("Week of Month") + ylab("") + 
ggtitle("Time-Series Calendar Temperature Time Map: London Weather") + 
labs(fill = "Temperature") 

vars <- c("timeDate", "timeTime", "humidity")
htMapTimeTemp <- weathHourly[vars]

htMapTimeTemp$weekday = as.POSIXlt(htMapTimeTemp$timeDate)$wday #finding the day numb of the week
htMapTimeTemp$weekdayf<-factor(htMapTimeTemp$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE) #converting the day numb to factor 
htMapTimeTemp$weekdayf[is.na(htMapTimeTemp$weekdayf)] <- "Sun"
htMapTimeTemp$monthf<-factor(month(htMapTimeTemp$timeDate),levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE) # finding the month 
htMapTimeTemp$yearmonth<- factor(as.yearmon(htMapTimeTemp$timeDate)) #finding the year and the month from the date. Eg: Nov 2012 
htMapTimeTemp$week <- as.numeric(week(htMapTimeTemp$timeDate)) #finding the week of the year for each date 
htMapTimeTemp<-ddply(htMapTimeTemp,.(yearmonth),transform,monthweek=1+week-min(week)) #normalizing the week to start at 1 for every month 

ggplot(htMapTimeTemp, aes(monthweek, weekdayf, fill = humidity)) + 
geom_tile(colour = "white") + 
facet_grid(year(htMapTimeTemp$timeDate)~monthf) + 
scale_fill_gradient(low="green", high="red") + 
xlab("Week of Month") + ylab("") + 
ggtitle("Time-Series Calendar Humidity Time Map: London Weather") + 
labs(fill = "Humidity") 

vars <- c("timeDate", "timeTime", "precipType")
htMapTimeTemp <- weathHourly[vars]

htMapTimeTemp$precipType <- gsub("rain", 1, htMapTimeTemp$precipType)
htMapTimeTemp$precipType <- gsub("snow", 2, htMapTimeTemp$precipType)
htMapTimeTemp$precipType <- as.numeric(htMapTimeTemp$precipType)

htMapTimeTemp$weekday = as.POSIXlt(htMapTimeTemp$timeDate)$wday #finding the day numb of the week
htMapTimeTemp$weekdayf<-factor(htMapTimeTemp$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE) #converting the day numb to factor 
htMapTimeTemp$weekdayf[is.na(htMapTimeTemp$weekdayf)] <- "Sun"
htMapTimeTemp$monthf<-factor(month(htMapTimeTemp$timeDate),levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE) # finding the month 
htMapTimeTemp$yearmonth<- factor(as.yearmon(htMapTimeTemp$timeDate)) #finding the year and the month from the date. Eg: Nov 2012 
htMapTimeTemp$week <- as.numeric(week(htMapTimeTemp$timeDate)) #finding the week of the year for each date 
htMapTimeTemp<-ddply(htMapTimeTemp,.(yearmonth),transform,monthweek=1+week-min(week)) #normalizing the week to start at 1 for every month 

ggplot(htMapTimeTemp, aes(monthweek, weekdayf, fill = precipType)) + 
geom_tile(colour = "white") + 
facet_grid(year(htMapTimeTemp$timeDate)~monthf) + 
scale_fill_gradient(low="green", high="red") + 
xlab("Week of Month") + ylab("") + 
ggtitle("Time-Series Calendar Precipitation Time Map: London Weather, 1 -> rain and 2 -> snow") + 
labs(fill = "Precipitation") 

hourlyEnergConsump <- dbGetQuery(dbConn, 
"
select day as timeDate, Avg_Energy_Consump
from daily_dataset_hhblocks_byHour
;
"
)

head(hourlyEnergConsump)

hourlyEnergConsump$timeDate <- trim(as.character(hourlyEnergConsump$timeDate))

hourlyEnergConsump$weekday = as.POSIXlt(hourlyEnergConsump$timeDate)$wday #finding the day numb of the week
hourlyEnergConsump$weekdayf<-factor(hourlyEnergConsump$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE) #converting the day numb to factor 
hourlyEnergConsump$weekdayf[is.na(hourlyEnergConsump$weekdayf)] <- "Sun"
hourlyEnergConsump$monthf<-factor(month(hourlyEnergConsump$timeDate),levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE) # finding the month 
hourlyEnergConsump$yearmonth<- factor(as.yearmon(hourlyEnergConsump$timeDate)) #finding the year and the month from the date. Eg: Nov 2012 
hourlyEnergConsump$week <- as.numeric(week(hourlyEnergConsump$timeDate)) #finding the week of the year for each date 
hourlyEnergConsump<-ddply(hourlyEnergConsump,.(yearmonth),transform,monthweek=1+week-min(week)) #normalizing the week to start at 1 for every month 

ggplot(hourlyEnergConsump, aes(monthweek, weekdayf, fill = Avg_Energy_Consump)) + 
geom_tile(colour = "white") + 
facet_grid(year(hourlyEnergConsump$timeDate)~monthf) + 
scale_fill_gradient(low="green", high="red") + 
xlab("Week of Month") + ylab("") + 
ggtitle("Time-Series Calendar Average Energy Consumption Time Map: London Weather") + 
labs(fill = "Avg_Energy_Consump")  + 
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=18, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm"))

hourlyEnergConsumpbyAcornAndKnowTariff <- dbGetQuery(dbConn, 
"
select Acorn_grouped , Avg_Energy_Consump , hblock 
from daily_dataset_hhblocks_byACORN_transp
where stdorToU = 'Std'
order by Acorn_grouped , hblock 
;
"
)

hourlyEnergConsumpbyAcornAndKnowTariff$Avg_Energy_Consump <- as.numeric(hourlyEnergConsumpbyAcornAndKnowTariff$Avg_Energy_Consump)
hourlyEnergConsumpbyAcornAndKnowTariff$hblock <- as.numeric(substr(as.character(hourlyEnergConsumpbyAcornAndKnowTariff$hblock),1,2))

qplot(x=hblock, y=Avg_Energy_Consump, 
           data=hourlyEnergConsumpbyAcornAndKnowTariff, 
           colour=Acorn_grouped, 
           main="Avg Hourly Energy Consumption by tariff UNaware group") +
      geom_line(size=1.0) + 
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) +
  scale_y_log10(labels = scales::comma_format(big.mark = ',', decimal.mark = '.')) +
  xlab("Hour Block") +
  scale_x_continuous(breaks=seq(0,23,1))

hourlyEnergConsumpbyAcornAndKnowTariff <- dbGetQuery(dbConn, 
"
select Acorn_grouped , Avg_Energy_Consump , hblock 
from daily_dataset_hhblocks_byACORN_transp
where stdorToU = 'ToU'
order by Acorn_grouped , hblock 
;
"
)

hourlyEnergConsumpbyAcornAndKnowTariff$Avg_Energy_Consump <- as.numeric(hourlyEnergConsumpbyAcornAndKnowTariff$Avg_Energy_Consump)
hourlyEnergConsumpbyAcornAndKnowTariff$hblock <- as.numeric(substr(as.character(hourlyEnergConsumpbyAcornAndKnowTariff$hblock),1,2))

qplot(x=hblock, y=Avg_Energy_Consump, 
           data=hourlyEnergConsumpbyAcornAndKnowTariff, 
           colour=Acorn_grouped, 
           main="Avg Hourly Energy Consumption by tariff aware group") +
      geom_line(size=1.0) + 
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=14, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm")) +
  scale_y_log10(labels = scales::comma_format(big.mark = ',', decimal.mark = '.')) +
  xlab("Hour Block") +
  scale_x_continuous(breaks=seq(0,23,1))

acornAnnualTariffEnrgCons <- dbGetQuery(dbConn, 
"
select Acorn_grouped, Tariff, dayDate, sum(energy_sum)/sum(energy_count) as Avg_Energy_Consump
from (
    select distinct a.LCLid, a.dayDate, ih.stdorToU , ih.Acorn_grouped, c.Tariff, energy_median, energy_mean, energy_max, energy_count, energy_std, energy_sum, energy_min
    from 
    (
        select dd.*, substr(day, 1, locate(' ', day)) as dayDate
        from daily_dataset dd
    ) a
    left outer join
    SMIL.informations_households ih
    on a.LCLid = ih.LCLid 
    left outer join 
    (
    select *, substr(t.TariffDateTime, 1, locate(' ', t.TariffDateTime)) as tariffDate
    from tariffs t 
    ) c
    on a.dayDate = c.TariffDate
) d
where (stdorToU = 'std') and (Tariff != 'NA')
group by Acorn_grouped, Tariff, dayDate
;
"
)

head(acornAnnualTariffEnrgCons)

ggplot()+   
  geom_boxplot(data=acornAnnualTariffEnrgCons, aes(x = Tariff, y = Avg_Energy_Consump, fill=Acorn_grouped), alpha=0.4)+
  scale_fill_manual("",values=c("skyblue4","indianred4","green4","orange3"))+
  labs(title = "Annual Electricity Consumption across acorn groups for all tariffs and tariff-UNAWARE consumers",
       x = "Tariff",
       y = "Electricity consumption in Kwhs")+
  theme_linedraw() + 
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=16, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm"))

acornAnnualTariffEnrgCons <- dbGetQuery(dbConn, 
"
select Acorn_grouped, Tariff, dayDate, sum(energy_sum)/sum(energy_count) as Avg_Energy_Consump
from (
    select distinct a.LCLid, a.dayDate, ih.stdorToU , ih.Acorn_grouped, c.Tariff, energy_median, energy_mean, energy_max, energy_count, energy_std, energy_sum, energy_min
    from 
    (
        select dd.*, substr(day, 1, locate(' ', day)) as dayDate
        from daily_dataset dd
    ) a
    left outer join
    SMIL.informations_households ih
    on a.LCLid = ih.LCLid 
    left outer join 
    (
    select *, substr(t.TariffDateTime, 1, locate(' ', t.TariffDateTime)) as tariffDate
    from tariffs t 
    ) c
    on a.dayDate = c.TariffDate
) d
where (stdorToU = 'ToU') and (Tariff != 'NA')
group by Acorn_grouped, Tariff, dayDate
;
"
)

head(acornAnnualTariffEnrgCons)

ggplot()+   
  geom_boxplot(data=acornAnnualTariffEnrgCons, aes(x = Tariff, y = Avg_Energy_Consump, fill=Acorn_grouped), alpha=0.4)+
  scale_fill_manual("",values=c("skyblue4","indianred4","green4","orange3","red2"))+
  labs(title = "Annual Electricity Consumption across Ccorn groups for all tariffs and consumers AWARE of tariff price range",
       x = "Tariff",
       y = "Electricity consumption in Kwhs")+
  theme_linedraw() + 
 theme(axis.text.x = element_text(size=14, angle=65, vjust=0.6, color="black"), 
        axis.text.y = element_text(size=14, angle=30, vjust=0.6, color="black"),
        axis.title=element_text(size=16, face="bold", color="brown"),
        plot.caption = element_text(color= "red", size=14, angle=0, vjust=0.6),
        plot.title = element_text(color= "blue", size=16, angle=0, vjust=0.6),
        plot.subtitle = element_text(color= "blue", size=14, angle=0, vjust=0.6, face="italic"),
        legend.title = element_text(size = 13), legend.text = element_text(color = "blue", size = 13), 
        legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5,"cm"))

#weathHourly %>%
  
# Data wrangling
#as_tibble() %>%

# Change temperature to numeric
# mutate(temperature=as.numeric(temperature)) #%>%

# Heat Map
#    ggplot(aes(timeTime, timeDate, fill= temperature)) + 
#    geom_tile() +
#    theme_classic() +
#    theme(legend.position="none")

vars <- c("timeDate", "timeTime", "temperature")
htMapTimeTempVer2 <- weathHourly[vars]

dt <- spread(htMapTimeTempVer2, timeTime, temperature, fill = NA, convert = FALSE)

dt2plot <- dt[-1]
row.names(dt2plot) <- dt$timeDate 
dt2plot <- as.matrix(dt2plot)

heatmap(dt2plot, scale="row", col = heat.colors(256)) 
legend(x="right", legend=c("max", "med", "min"),fill=heat.colors(3)) 




