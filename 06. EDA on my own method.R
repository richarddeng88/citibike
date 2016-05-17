###### 1.month trips calculated by my own data;#############################
library(dplyr);library(ggplot2)
df$date <- as.Date(df$starttime)
df$count <- 1

calculation <-select(df, start.station.id,bikeid,gender,hour,weekday,date,count)

daily <- group_by(calculation, date)
by_day <- summarize(daily, trips=sum(count),bikes=length(unique(bikeid)))
by_day <- mutate(by_day,trips_m=rollsum(trips, k = 15, na.pad = TRUE, align = "right"),
                 bikes_m=rollmean(bikes, k = 35, na.pad = TRUE, align = "right"))

png("citibike/picts/1. monthly_total_trips.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = trips_m)) +
        labs(title="NYC MONTHLY CITIBIKE TRIPS") +
        geom_line(size = 1, color = "darkgreen") +
        scale_x_date("Month") +
        scale_y_continuous("Citi Bike trips, trailing 15 days/Unit: thousands") +
        expand_limits(y = 0) 
dev.off()

#########2 unique bikes used perday calculated by my own data;#########################
png("citibike/picts/2.unique_bike.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = bikes_m)) +
        labs(title="NYC unique bikes used") +
        geom_line(size = 1, color = "blue") +
        scale_x_date("Month") +
        scale_y_continuous("Number of unique bikes used perdday, trailing 25 days") +
        expand_limits(y = 0) 
dev.off()


####### 3. calculate trips by hour ####################################################
calculation$ifweekday <- 1
calculation[calculation$weekday=="Sunday",]$ifweekday  <- 0 
calculation[calculation$weekday=="Saturday",]$ifweekday  <- 0

hour <- group_by(calculation, date,hour)
hour_wday <- filter(hour,ifweekday==1)
hour_wend <- filter(hour,ifweekday==0)
by_hour_wday <- summarize(hour_wday, trips=sum(count))
by_hour_wend <- summarize(hour_wend, trips=sum(count))

by_hour_wday <- group_by(by_hour_wday,hour)
by_hour_wday <- summarize(by_hour_wday, avg=mean(trips))
by_hour_wend <- group_by(by_hour_wend,hour)
by_hour_wend <- summarize(by_hour_wend, avg=mean(trips))

by_hour_wday$ifweekday <- "weekday" ; by_hour_wend$ifweekday <- "weekend"
by_hour <- rbind(as.data.frame(by_hour_wend) ,as.data.frame(by_hour_wday))

png(filename = "citibike/picts/3.avg trips by hour.png", width = 640, height = 420)
ggplot(data = by_hour, aes(x = hour, y = avg,fill=ifweekday)) +
        geom_bar(stat="identity",position="dodge",color="black") +
        labs(title="NYC BIKE TRIPS BY HOUR OF THE DAY",y="Avg hourly trips")+
        facet_grid(ifweekday~.)
dev.off()

########## 4.  calculate how many unique bike station#################################
daily <- group_by(calculation, date)
by_day <- summarize(daily, station=length(unique(start.station.id)))
by_day <- mutate(by_day,
                 station_inuse = rollmean(station, k = 20, na.pad = TRUE, align = "right"))

png("citibike/picts/4.station in use.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = station_inuse)) +
        labs(title="NYC citibike station in use") +
        geom_line(size = 1, color = "darkblue") +
        scale_x_date("Month") +
        scale_y_continuous("Citi bike station in sue") +
        expand_limits(y = 0) 
dev.off()

########## 5. hot station by monthly avg #################################
# how many stations name & location
# here is caluculation the ranks for the last 31 month, so need to load the all 25m data. 
station <-select(df, tripduration,start.station.id,start.station.name,end.station.id,gender,date,count)
station$ym <- format(station$date, "%Y-%m")

by_station_start <- station %>% group_by(ym, start.station.id) %>% summarize(trips=sum(count)) %>% arrange(desc(trips))
top10 <- filter(by_station, row_number() <= 10)
top10$count <- 1
top10 <- group_by(top10, start.station.id)
a <- summarize(top10, num=sum(count))
rank_start <- arrange(a, desc(num))

by_station_stop <- station %>% group_by(ym, end.station.id) %>% summarize(trips=sum(count)) %>% arrange(desc(trips))
top10 <- filter(by_station_stop, row_number() <= 10)
top10$count <- 1
top10 <- group_by(top10, end.station.id)
b <- summarize(top10, num=sum(count))
rank_end <- arrange(b, desc(num))

rank <- cbind(head(rank_start,15),head(rank_end,15))
write.csv(rank, file="citibike/hot_station_ranking.csv",row.names = F)

########## 6. manhattan in and out #################################
#df <- read.csv("C:/Users/Richard/Desktop/citibike/citibike newest data/2016citibike.csv",stringsAsFactors = F )
df <- select(df, -starttime,-stoptime)
station <- distinct(df, end.station.name)
uni_station <- select(station, start.station.id, start.station.name,start.station.latitude,start.station.longitude)
names(uni_station) <- c("station.id","station.name","latitude","longitude")
write.csv(uni_station, file="citibike/station.csv",row.names = F)

#build up a unique station file. 
one_day <- filter(df, date=="2016-03-31")
write.csv(one_day, file="citibike/one_day.csv",row.names = F)

######## 7. speed & time differnce estimation by gender and age ########################################################
dis_est <- read.csv("citibike/dis_estimation.csv", stringsAsFactors = F)
one_day <- read.csv("citibike/one_day from 6am to 10pm.csv", stringsAsFactors = F)

merg <- merge(dis_est,one_day, by.x= "index", by.y="index", all.x=T, all.y = F)

new_df <- select(merg, index, duration, distance, tripduration, starttime,start.station.id,bikeid, usertype,birth.year,gender)
names(new_df) <- c('index', 'estimatd_time','distance','actual_time','starttime','station','bikeid','usertype','birth','gender')
#new_df <- filter(new_df, distance!=0)

miles_per_meter = (5280 * 12 * 2.54 / 100)
new_df$exp_speed <- new_df$distance/new_df$estimatd_time
new_df$act_speed <- new_df$distance/new_df$actual_time
new_df$actual_time <- new_df$actual_time/60; new_df$estimatd_time <- new_df$estimatd_time/60
new_df$diff <- new_df$actual_time - new_df$estimatd_time
new_df$distance <- new_df$distance/miles_per_meter

new_df$gender[new_df$gender==1] = "male"
new_df$gender[new_df$gender==2] = "female"
new_df$gender[new_df$gender==0] = "unknown"   
new_df$age <- 2016 - new_df$birth

# we see that there are some outliers, case that biker return the bike after a couple of days. 
    plot(new_df$distance,new_df$diff)
    plot(new_df$distance,new_df$actual_time)
    plot(new_df$distance,new_df$estimatd_time)
    # we take out those outlier to have an idea on the main points. 
    new_df1 <- filter(new_df, actual_time <=60, gender!="unknown", distance!=0, age<90)
    sum(is.na(new_df1$age))
    new_df1$expected_bucket = cut(new_df1$estimatd_time, breaks = c(0, 5, 10, 15, 20, 60), right = FALSE)
    new_df1$age_bucket = cut(new_df1$age, breaks = c(0, 22, 25, 30, 35, 40, 45, 50, 60, 100))
    new_df1$distance_bucket = cut(new_df1$distance, breaks = c(0,1, 1.5, 2,3, 8), right = FALSE)
    levels(new_df1$distance_bucket) = c("<1 mile", "1-2 miles", "2-3 miles", "3-4 miles",">4 miles")
    #plot(new_df1$distance,new_df1$diff)
    #plot(new_df1$distance,new_df1$actual_time)
    #plot(new_df1$distance,new_df1$estimatd_time)
    
    ggplot(new_df1, aes(x=distance, y=diff, color=gender)) + geom_point()

############## ploting speed by age, gender and distance###############
    buck <- group_by(new_df1, distance_bucket, gender, age_bucket)
    buck_data <-summarize(buck, 
              mean_diff = mean(diff),
              median_diff = median(diff),
              sd_diff = sd(diff),
              mean_mph = mean(act_speed),
              median_mph = median(act_speed),
              sd_mph = sd(act_speed),
              count = n(),
              mean_expected = mean(estimatd_time),
              mean_age = mean(age))
    
    png(filename = "citibike/picts/5.speed_by_age_gender_distance.png",width = 640, height = 480)
    ggplot(data = buck_data,
           aes(x = mean_age, y = mean_mph, color = gender)) +
        geom_line(size = 1) +
        facet_wrap(~distance_bucket, ncol = 2) +
        scale_x_continuous("Age") +
        scale_y_continuous("Speed - Miles/hr\n") +
        scale_colour_brewer(palette="Set1") +
        theme(legend.position = "right",
              strip.background = element_blank(),
              strip.text = element_text(size = rel(1)),
              panel.margin = unit(1.2, "lines"))
    dev.off()
    
    png("citibike/picts/6.Estimated_Speed_by_age_gender.png", width = 640, height = 480)
    ggplot(data = filter(buck_data,distance_bucket=="<1 mile"),
           aes(x = mean_age, y = mean_mph, color = gender)) +
        geom_line(size = 1) +
        labs(title="Estimated Speed by Google Maps when distance < 1 mile", x="age", y="estimated speed") +
        ylim(2,6) +
        scale_colour_brewer(palette="Set1") +
        theme(legend.position = "right",
              strip.background = element_blank(),
              strip.text = element_text(size = rel(1)),
              panel.margin = unit(1.2, "lines"))
    dev.off()
    
    
    png(filename = "citibike/picts/7.time_diff_by_age_gender_distance.png", width = 640, height = 480)
    ggplot(data = filter(buck_data, distance_bucket=="1-2 miles"),
           aes(x = mean_age, y = median_diff, color = gender)) +
        geom_line(size = 1) +
        labs(title="time difference when distance=1-2 miles",x="age", y="actual time - estimated time by googlemaps") +
        ylim(0,8)  +
        scale_colour_brewer(palette="Set1") +
        theme(legend.position = "right",
              strip.background = element_blank(),
              strip.text = element_text(size = rel(1)),
              panel.margin = unit(1.2, "lines"))
    dev.off()
    
    
######### some interesting insigh developed from the  ######
        use_less_time <- new_df[new_df$actual_time< new_df$estimatd_time,] 
        dim(use_less_time)[1]/dim(new_df)[1] # 28.49% use less time than google expected
        use_mroe_time <- new_df[new_df$actual_time >= new_df$estimatd_time,] 
        dim(use_mroe_time )[1]/dim(new_df)[1] # 71.50% use more time that google expected
        
        #we found that over 98.6% of ridership are less than 1hr, 98.4% less than 50min, 98.1% less than 45min,
        over_sometime <- new_df[new_df$actual_time >= 60,] 
        dim(over_sometime)[1]/dim(new_df)[1] # 1.40%   over 1hr
        over_sometime <- new_df[new_df$actual_time <= 45,] 
        dim(over_sometime)[1]/dim(new_df)[1] # 98.06%  less 45 min
        over_sometime <- new_df[new_df$actual_time <=30 ,] 
        dim(over_sometime)[1]/dim(new_df)[1] # 93.2%  less 30min
        over_sometime <- new_df[new_df$actual_time <=15 ,] 
        dim(over_sometime)[1]/dim(new_df)[1] # 70.2%  less 15min
        back_to_starting_point <- new_df[new_df$distance==0,] # 1.47% back to the original station

        trip_mile <- new_df[new_df$distance >= 6,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 0.2%   greater then 6 miles
        trip_mile <- new_df[new_df$distance <3,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 90%   less than 3 miles
        trip_mile <- new_df[new_df$distance <2,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 76%% 
        trip_mile <- new_df[new_df$distance <1.5,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 62%% 
        trip_mile <- new_df[new_df$distance <1,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 40% 
        trip_mile <- new_df[new_df$distance <0.5,] 
        dim(trip_mile )[1]/dim(new_df)[1] # 10% 

        
############## 8. weather and trips ##############################################










