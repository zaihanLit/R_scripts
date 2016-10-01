## load the package "rvest"
library(RSelenium)

## set the working directory
setwd("/root/R_scripts")

## the url of SHENZHEN STOCK EXCHANGE
url <- "http://www.sse.com.cn/market/othersdata/margin/sum/"

## create a phantom server and connect to it
pJS <- phantom()
Sys.sleep(5)   ## give the binary a moment
remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open()

## get the web content
remDr$navigate(url)
Sys.sleep(10) ## give the browser a moment

## get the nodes of the data
webElems <- remDr$findElements(using = 'css selector', value = "table tbody tr td")
Sys.sleep(10) ## give the browser a moment

## get the data
RZMRE <- webElems[[3]]$getElementText()  ## ÈÚ×ÊÂòÈë¶î
RZYE <- webElems[[2]]$getElementText()  ## ÈÚ×ÊÓà¶î
RQMCL <- webElems[[6]]$getElementText()  ## ÈÚÈ¯ÂòÈëÁ¿
RQYL <- webElems[[4]]$getElementText()  ## ÈÚÈ¯ÓàÁ¿
RQYE <- webElems[[5]]$getElementText()  ## ÈÚÈ¯Óà¶î
RZRQYE <- webElems[[7]]$getElementText()  ## ÈÚ×ÊÈÚÈ¯Óà¶î

## get the date of the data
data_date <- webElems[[1]]$getElementText()

data_date_new <- paste0(substr(data_date, 1, 4), "-", substr(data_date, 5, 6), "-", substr(data_date, 7, 8))

## close the connection and stop the phantom server
remDr$close()
pJS$stop()

## read the history data from file
sh_data <- read.csv("SH.csv", colClasses = "character")




## add the new data to the history data
if (!(data_date %in% sh_data[,1])) 
  sh_data[nrow(sh_data) + 1,] <- c(data_date_new, 
                                   RZMRE, RZYE, RQMCL, RQYL, RQYE, RZRQYE)

## write the data to the file
write.csv(sh_data, file = "SH.csv", row.names = FALSE)


