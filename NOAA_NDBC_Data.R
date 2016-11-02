#############################################################################################################
##  Catherine Nowakowski "Catrina"
##  07-07-2016
##  Loads data from NOAA online text format and sorts it for use, writes csv file at end

#############################################################################################################
##  Loading the data from NOAA online text format
##  find more URLs from http://www.ndbc.noaa.gov
##  Pick a station
##  View Details
##  Scroll to bottom of page
##  Click Real Time Data
##  Click Real time standard meteorological data
##  Copy paste url like bellow
##  Change x for the location you want!

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
X = location_1

#############################################################################################################
##  This pulls the data from online and puts it in a table
raw_data <- read.table(X)

#############################################################################################################
##  This chuncks the names up
name <- scan(X, what = character ())

#############################################################################################################
##  Creats the variables from the names being cuncked up
number_of_var <- length(raw_data)
data_names <- name[1:number_of_var]
data_units <- name[(number_of_var+1):(number_of_var*2)]

#############################################################################################################
##  adds the names to the raw data set
names(raw_data) <- data_names

#############################################################################################################
##  Gives names to all of the units
names(data_units) <- data_names

#############################################################################################################
##  changes all the locations with MM to NA
raw_data[raw_data == "MM"] = NA

#############################################################################################################
##  Makes a new column with the dates
raw_data$dates <- ISOdate(year = raw_data[,"#YY"], month = raw_data[ ,"MM"], day = raw_data[ ,"DD"], 
                          hour = raw_data[ ,"hh"], min = raw_data[ ,"mm"], sec = 0, tz = "UTC")

#############################################################################################################
## Write a CSV file for input to Excel
write.table(raw_data, file = "NOAA_NDBC_Data.csv", sep = ",", col.names = NA,
            qmethod = "double")