#########################################################################################################
library(dplyr);library(caret);set.seed(1001)

## take 1/100 data from year 2013 
        df2013 <- read.csv("citibike/2013to082014citibike.csv",stringsAsFactors = F)
        
        df <- df2013
        df$starttime <- as.POSIXlt(df$starttime)
        df$month <- months(df$starttime)

        intrain <- createDataPartition(y=df$month, p=0.04, list = F)
        df1 <- df[intrain,]
        df2 <- select(df1, -month)
        write.csv(df2, file="database_inputto082014.csv",row.names = F)

## take 1/100 data from year 2014    
        df2014 <- read.csv("citibike/092014to122014citibike.csv",stringsAsFactors = F)
        
        df <- df2014
        df$starttime <- as.POSIXlt(df$starttime)
        df$month <- months(df$starttime)

        intrain <- createDataPartition(y=df$month, p=0.04, list = F)
        df1 <- df[intrain,]
        df2 <- select(df1, -month)
        write.csv(df2, file="database_input2014.csv",row.names = F)
        
## take 1/100 data from year 2015    
        df2015 <- read.csv("citibike/2015citibike.csv",stringsAsFactors = F)
        
        df <- df2015
        df$starttime <- as.POSIXlt(df$starttime)
        df$month <- months(df$starttime)

        intrain <- createDataPartition(y=df$month, p=0.04, list = F)
        df1 <- df[intrain,]
        df2 <- select(df1, -month)
        write.csv(df2, file="database_input2015.csv",row.names = F)   

## take 1/100 data from year 2016    
        df2016 <- read.csv("citibike/2016citibike.csv",stringsAsFactors = F)
        
        df <- df2016
        df$starttime <- as.POSIXlt(df$starttime)
        df$month <- months(df$starttime)
        library(dplyr)
        library(caret);set.seed(1001)
        intrain <- createDataPartition(y=df$month, p=0.04, list = F)

        df1 <- df[intrain,]
        df2 <- select(df1, -month)
        write.csv(df2, file="database_input2016.csv",row.names = F)         
        
        
        

#### split 1/10 data for several months #########################################################################
        m <- read.csv("c:/Users/Richard/Desktop/citibike/201603-citibike-tripdata.csv")
        m$starttime <- strptime(m$starttime,"%m/%d/%Y %H:%M")
        df$month <- months(df$start_time)
        
        library(caret);set.seed(1001)
        intrain <- createDataPartition(y=m$month, p=0.1, list = F)
        df1 <- df[intrain,]
        write.csv(df1, file="bike2015_excel.csv",row.names = F)

############## split 1/10 data for one months #####  ################      
        m <- read.csv("c:/Users/Richard/Desktop/citibike/201603-citibike-tripdata.csv")
        m$starttime <- strptime(m$starttime,"%m/%d/%Y %H:%M")
        m$stoptime <- strptime(m$stoptime,"%m/%d/%Y %H:%M")
        df$month <- months(df$start_time)
        
        split <- sample(dim(m)[1],dim(m)[1]/10)
        m_new <- m[split,]
        
        write.csv(m_new, file="201603-citibike-tripdata.csv",row.names = F)
        

        
        
        
        
        
        
        