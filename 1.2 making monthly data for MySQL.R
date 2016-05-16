

df_old <- read.csv("c:/Users/Richard/Desktop/citibike/201307-citibike-tripdata.csv", stringsAsFactors = F)
df_old$starttime <- strptime(df_old$starttime,"%Y-%m-%d %H:%M:%S")
df_old$stoptime <- strptime(df_old$stoptime,"%Y-%m-%d %H:%M:%S")
write.csv(df_old, file="citibike/201307citibike.csv",row.names = F)


# for loop to load and revise the data files
        num <- c("01","02","03","04","05","06","07","08","09","10","11","12")
        for (i in num) { 
        path <- paste("c:/Users/Richard/Desktop/citibike/","2014",i,"-citibike-tripdata.csv",sep="")
        df_old <- read.csv(path, stringsAsFactors = F)
        df_old$starttime <- strptime(df_old$starttime,"%Y-%m-%d %H:%M:%S")
        df_old$stoptime <- strptime(df_old$stoptime,"%Y-%m-%d %H:%M:%S")
        cat(i,"has been read")
        savepath <- paste("2014",i,"citibike.csv",sep="")
        write.csv(df_old, file=savepath,row.names = F)
        cat(i,"is successfully revised", "      ")
        }
        
        
        num <- c("01","02","03","04","05","06","07","08","09","10","11","12")
        
        num <- c("01","02","03")
        for (i in num) { 
                path <- paste("c:/Users/Richard/Desktop/citibike/","2016",i,"-citibike-tripdata.csv",sep="")
                df_old <- read.csv(path, stringsAsFactors = F)
                df_old$starttime <- strptime(df_old$starttime,"%m/%d/%Y %H:%M")
                df_old$stoptime <- strptime(df_old$stoptime,"%m/%d/%Y %H:%M")
                cat(i,"has been read","  ")
                savepath <- paste("2016",i,"citibike.csv",sep="")
                write.csv(df_old, file=savepath,row.names = F)
                cat(i,"is successfully revised", "        ")
        }
        
        
        