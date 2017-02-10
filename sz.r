## load the package "rvest"
library(RSelenium)

## set the working directory
setwd("/root/R_scripts")

## the url of SHENZHEN STOCK EXCHANGE
url <- "http://www.szse.cn/main/disclosure/rzrqxx/rzrqjy/"


## create a phantom server and connect to it
pJS <- phantom()
Sys.sleep(5)   ## give the binary a moment
remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open()

## get the web content
remDr$navigate(url)
Sys.sleep(10) ## give the browser a moment

## get the nodes of the data
webElems <- remDr$findElements(using = 'css selector', value = "table#REPORTID_tab1.cls-data-table-common.cls-data-table tbody tr td")
Sys.sleep(10) ## give the browser a moment

## get the data
RZMRE <- webElems[[1]]$getElementText()  ## ���������
RZYE <- webElems[[2]]$getElementText()  ## �������
RQMCL <- webElems[[3]]$getElementText()  ## ��ȯ������
RQYL <- webElems[[4]]$getElementText()  ## ��ȯ����
RQYE <- webElems[[5]]$getElementText()  ## ��ȯ���
RZRQYE <- webElems[[6]]$getElementText()  ## ������ȯ���


## get the date of the data
webElems <- remDr$findElements(using = 'css selector', value = "tr td span.cls-subtitle")
data_date <- webElems[[1]]$getElementText()


## close the connection and stop the phantom server
remDr$close()
pJS$stop()                                                                                                                                           


## read the history data from file
sz_data <- read.csv("SZ.csv", colClasses = "character")

## add the new data to the history data
if (!(data_date %in% sz_data[,1])) 
      sz_data[nrow(sz_data) + 1,] <- c(data_date, 
                                       RZMRE, RZYE, RQMCL, RQYL, RQYE, RZRQYE)

## write the data to the file
write.csv(sz_data, file = "SZ.csv", row.names = FALSE)

