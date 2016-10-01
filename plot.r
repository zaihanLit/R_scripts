## this script read data from SH.csv and SZ.csv, then draw a time series plot

## read data
sh_data <- read.csv("/root/R_scripts/SH.csv", colClasses = "character")
sz_data <- read.csv("/root/R_scripts/SZ.csv", colClasses = "character")

## plot of 上海融资买入额
png("/var/www/html/SH_RZMRE.png", width = 800, height = 480)
plot(as.Date(sh_data$Date), as.numeric(gsub(",", "",sh_data$RZMRE)), 
     type = "l", xlab ="Date", ylab = "RZMRE", 
     ylim = c(0, max(as.numeric(gsub(",", "",sh_data$RZMRE)))), 
     col = "blue", main = "RZMRE of ShangHai")
dev.off()

## plot of 深圳融资买入额
png("/var/www/html/SZ_RZMRE.png", width = 800, height = 480)
plot(as.Date(sz_data$Date),as.numeric(gsub(",", "",sz_data$RZMRE)), 
     type = "l", xlab ="Date", ylab = "RZMRE", 
     ylim = c(0, max(as.numeric(gsub(",", "",sz_data$RZMRE)))), 
     col = "blue", main = "RZMRE of Shenzhen")
dev.off()

