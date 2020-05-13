#############################################################################################################
##  Catherine Nowakowski "Catrina"
##  07-07-2016
##  Updated 05-13-2020
##  Loads data from NOAA online text format and sorts it for use, writes csv file at end

#############################################################################################################
##  Loads the data from NOAA online text format
##  find more URLs from http://www.ndbc.noaa.gov
##  Pick a station
##  View Details
##  Scroll to bottom of page
##  Click Real Time Data
##  Click Real time standard meteorological data
##  Copy paste url like bellow

location_1 <- "http://www.ndbc.noaa.gov/data/realtime2/LDLC3.txt"  #Station LDLC3, Location: 41.306N 72.077W
#Mouth of Thames River CT
location_2 <- "http://www.ndbc.noaa.gov/data/realtime2/44039.txt"  #Station 44039, Location: 41.138N 72.655W
#Middle of LIS
location_3 <- "http://www.ndbc.noaa.gov/data/realtime2/TIQC1.ocean"#Station TIQC1 San Diego
#National Estuarine Research Reserve System
#Location: 32.568N 117.131W
location_4 <- "http://www.ndbc.noaa.gov/data/realtime2/41029.txt"  #Station 41029
#CaroCOOPS, SC coast,grandma pick
#Location: 32.800N 79.62W
location_5 <- "http://www.ndbc.noaa.gov/data/5day2/46035_5day.txt" #Station 46035
#The Middle of the Bering Sea
#Location: 57.026N 177.738W
location_6 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=thlo1h2007.txt.gz&dir=data/historical/stdmet/"
#Station THLO1
#Lake Erie, West Basin, 2007
location_7 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=bufn6h2007.txt.gz&dir=data/historical/stdmet/"
#Station BUFN6
#Lake Erie, East Basin, 2007

##Locations for DHS
location_8 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=buzm3h1991.txt.gz&dir=data/historical/stdmet/"
#Station BUZM3 (1991)
#Buzzards Bay
#(41.397 N, 71.033 W) 
location_9 <-"http://www.ndbc.noaa.gov/view_text_file.php?filename=41001h1991.txt.gz&dir=data/historical/stdmet/"
# Station 44066 - Texas Tower #4 - 75 NM East of Long Beach, NJ
# Owned and maintained by National Data Buoy Center
# 39.568 N 72.586 W (39°34'6" N 72°35'8" W)


location_10 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=pgbp792017.txt.gz&dir=data/stdmet/Sep/"
# #Argo
# Station PGBP7 - 1631428 - Pago Bay, Guam
# Owned and maintained by NOAA's National Ocean Service
# 13.428 N 144.796 E (13°25'41" N 144°47'47" E)
# 
# Historical data for station PGBP7 available from NDBC include:



read_data <- function(html){
  #############################################################################################################
  ##  This pulls the data from online and puts it in a table
  raw_data <- read.table(X, header = TRUE, comment.char = "", stringsAsFactors = FALSE)
  
  #############################################################################################################
  ##  Units get removed, look them up online if you are interested...
  raw_data <- raw_data[2:nrow(raw_data), ]
  
  #############################################################################################################
  ##  changes all the locations with MM to NA
  raw_data[raw_data == "MM"] = NA
  raw_data[raw_data == "99.00"] = NA
  raw_data[raw_data == "99.0"] = NA
  raw_data[raw_data == "999"] = NA
  raw_data[raw_data == "999.0"] = NA
  
  #############################################################################################################
  ##  Fix the Year
  #raw_data$YY <- raw_data$YY + 1900
  
  #############################################################################################################
  ##  Makes a new column with the dates
  raw_data$dates <- ISOdate(year = raw_data[,"X.YY"], month = raw_data[ ,"MM"], day = raw_data[ ,"DD"], 
                            hour = raw_data[ ,"hh"], sec = 0, tz = "UTC")
  
  return(raw_data)
}

#############################################################################################################
#############################################################################################################
### Example 1: read a location
data <- read_data(location_1)

#############################################################################################################
#############################################################################################################
#### Example 2: Read historical data
date_range <- 1991:1995
data_names <- rep(NA, length(date_range))
i = 1
for(year in date_range){
  x = paste0("http://www.ndbc.noaa.gov/view_text_file.php?filename=buzm3h", year, ".txt.gz&dir=data/historical/stdmet/")
  data <- read_data(x)
  assign(paste0("data_", year), data)
  data_names[i] <- paste0("data_", year)
  i = i +1
}

data <-rbind(get(data_names[1]), 
            get(data_names[2]),
            get(data_names[3]),
            get(data_names[4]),
            get(data_names[5]))


#############################################################################################################
#############################################################################################################
## Write a CSV file for input to Excel

file_name <- "NOAA_NDBC_Data_ARGO.csv"

write.table(merged_data, file = file_name, sep = ",", col.names = NA,
            qmethod = "double")
