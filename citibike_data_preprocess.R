
## READ THE DATA INTO R - 07/2013 TO PRESENT #####################
df2013 <- read.csv("citibike/2013to082014citibike.csv",stringsAsFactors = F)
df2014 <- read.csv("citibike/092014to122014citibike.csv",stringsAsFactors = F)
df2015 <- read.csv("citibike/2015citibike.csv",stringsAsFactors = F)
df2016 <- read.csv("citibike/2016citibike.csv",stringsAsFactors = F)

df <- rbind(df2013,df2014,df2015,df2016)
df <- rm(df2013,df2014,df2015,df2016)

# time conversion
df$start_time <- strptime(as.character(df$starttime), "%m/%d/%Y %H:%M")
df$month <- months(df$start_time)
df$weekday <- weekdays(df$start_time)
df$quarters <- quarters(df$start_time)
df$hours <- df$start_time$hour

# convert gender from number to charator
df$gender[df$gender==1] = "male"
df$gender[df$gender==2] = "female"
df$gender[df$gender==0] = "unknown"   

# export csv file for tableau analysis
write.csv(df, file="citibike_all.csv",row.names = F)

############# time convertion practice ##################################
        # try to convert time. 
        a <- df$starttime
        a <- as.character(a)
        b <- a[1:10]
        c <- strptime(b, "%m/%d/%Y %H:%M")
        weekdays(c)
        quarters(c)
        months(c)
        c$hour


        # example for time conversion
        dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
        times <- c("23:03:20", "22:29:56", "01:03:30", "18:21:03", "16:56:26")
        x <- paste(dates, times)
        strptime(x, "%m/%d/% %H:%M:%S")
        

################# randomly select sample for excel analysis.##################################
        library(dplyr)
        df1 <- df[,c(-2,-3,-16)]
        #df2 <- group_by(df1, month)
        #summarize(df2, sum=sum(tripduration))
        #summarize(df2, a = sample(1:nrow(tripduration),(df2)))
        
        library(caret);set.seed(1001)
        intrain <- createDataPartition(y=df$month, p=0.01, list = F)
        df1 <- df[intrain,]
        write.csv(df1, file="bike2015_excel.csv",row.names = F)
        