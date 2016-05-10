# 2013 ###########################
        c7 <- read.csv("c:/Users/Richard/Desktop/citibike/201307-citibike-tripdata.csv")
        c8 <- read.csv("c:/Users/Richard/Desktop/citibike/201308-citibike-tripdata.csv")
        c9 <- read.csv("c:/Users/Richard/Desktop/citibike/201309-citibike-tripdata.csv")
        c10 <- read.csv("c:/Users/Richard/Desktop/citibike/201310-citibike-tripdata.csv")
        c11 <- read.csv("c:/Users/Richard/Desktop/citibike/201311-citibike-tripdata.csv")
        c12 <- read.csv("c:/Users/Richard/Desktop/citibike/201312-citibike-tripdata.csv")
        
        df2013 <- rbind(c7,c8,c9,c10,c11,c12)
        write.csv(df2013, file="citibike/2013citibike.csv",row.names = F)


# 2014###########################
        c1 <- read.csv("c:/Users/Richard/Desktop/citibike/201401-citibike-tripdata.csv", stringsAsFactors = F)
        c2 <- read.csv("c:/Users/Richard/Desktop/citibike/201402-citibike-tripdata.csv",stringsAsFactors = F)
        c3 <- read.csv("c:/Users/Richard/Desktop/citibike/201403-citibike-tripdata.csv",stringsAsFactors = F)
        c4 <- read.csv("c:/Users/Richard/Desktop/citibike/201404-citibike-tripdata.csv",stringsAsFactors = F)
        c5 <- read.csv("c:/Users/Richard/Desktop/citibike/201405-citibike-tripdata.csv",stringsAsFactors = F)
        c6 <- read.csv("c:/Users/Richard/Desktop/citibike/201406-citibike-tripdata.csv",stringsAsFactors = F)
        c7 <- read.csv("c:/Users/Richard/Desktop/citibike/201407-citibike-tripdata.csv",stringsAsFactors = F)
        c8 <- read.csv("c:/Users/Richard/Desktop/citibike/201408-citibike-tripdata.csv",stringsAsFactors = F)
        old <- rbind(c1,c2,c3,c4,c5,c6,c7,c8)
        df_old <- rbind(df2013,old)
        df_old$starttime <- strptime(df_old$starttime,"%Y-%m-%d %H:%M:%S")
        df_old$stoptime <- strptime(df_old$stoptime,"%Y-%m-%d %H:%M:%S")
        
        write.csv(df_old, file="citibike/2013to082014citibike.csv",row.names = F)
        
        c9 <- read.csv("c:/Users/Richard/Desktop/citibike/201409-citibike-tripdata.csv",stringsAsFactors = F)
        c10 <- read.csv("c:/Users/Richard/Desktop/citibike/201410-citibike-tripdata.csv",stringsAsFactors = F)
        c11 <- read.csv("c:/Users/Richard/Desktop/citibike/201411-citibike-tripdata.csv",stringsAsFactors = F)
        c12 <- read.csv("c:/Users/Richard/Desktop/citibike/201412-citibike-tripdata.csv",stringsAsFactors = F)
        
        df2014 <- rbind(c9,c10,c11,c12)
        df2014$starttime <- strptime(df2014$starttime,"%m/%d/%Y %H:%M")
        df2014$stoptime <- strptime(df2014$stoptime,"%m/%d/%Y %H:%M")
        write.csv(df2014, file="citibike/092014to122014citibike.csv",row.names = F)


# 2015 ###########################
        c1 <- read.csv("c:/Users/Richard/Desktop/citibike/201501-citibike-tripdata.csv")
        c2 <- read.csv("c:/Users/Richard/Desktop/citibike/201502-citibike-tripdata.csv")
        c3 <- read.csv("c:/Users/Richard/Desktop/citibike/201503-citibike-tripdata.csv")
        c4 <- read.csv("c:/Users/Richard/Desktop/citibike/201504-citibike-tripdata.csv")
        c5 <- read.csv("c:/Users/Richard/Desktop/citibike/201505-citibike-tripdata.csv")
        c6 <- read.csv("c:/Users/Richard/Desktop/citibike/201506-citibike-tripdata.csv")
        c7 <- read.csv("c:/Users/Richard/Desktop/citibike/201507-citibike-tripdata.csv")
        c8 <- read.csv("c:/Users/Richard/Desktop/citibike/201508-citibike-tripdata.csv")
        c9 <- read.csv("c:/Users/Richard/Desktop/citibike/201509-citibike-tripdata.csv")
        c10 <- read.csv("c:/Users/Richard/Desktop/citibike/201510-citibike-tripdata.csv")
        c11 <- read.csv("c:/Users/Richard/Desktop/citibike/201511-citibike-tripdata.csv")
        c12 <- read.csv("c:/Users/Richard/Desktop/citibike/201512-citibike-tripdata.csv")
        
        df2015 <- rbind(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)
        df2015$starttime <- strptime(df2015$starttime,"%m/%d/%Y %H:%M")
        df2015$stoptime <- strptime(df2015$stoptime,"%m/%d/%Y %H:%M")
        write.csv(df2015, file="citibike/2015citibike.csv",row.names = F)


# 2016 ###########################
        c1 <- read.csv("c:/Users/Richard/Desktop/citibike/201601-citibike-tripdata.csv")
        c2 <- read.csv("c:/Users/Richard/Desktop/citibike/201602-citibike-tripdata.csv")
        c3 <- read.csv("c:/Users/Richard/Desktop/citibike/201603-citibike-tripdata.csv")
        
        df2016 <- rbind(c1,c2,c3)
        df2016$starttime <- strptime(df2016$starttime,"%m/%d/%Y %H:%M")
        df2016$stoptime <- strptime(df2016$stoptime,"%m/%d/%Y %H:%M")
        write.csv(df2016, file="citibike/2016citibike.csv",row.names = F)

        
        ### tranfor the format fo time from begining to 08/2013
        #c<- gsub("-","/",b)
        #d <- strptime(c, "%Y/%m/%d %H:%M:%S")
        e <- strptime(b,"%Y-%m-%d %H:%M:%S") #for time from begining to 08/2013
        f <- head(c1$starttime)
        g <- strptime(f, "%m/%d/%Y %H:%M") #fro time after 08/2013
        