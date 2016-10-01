## load the package "rvest"
library(RSelenium)

## the url of SHENZHEN STOCK EXCHANGE
url <- "http://www.szse.cn/main/disclosure/rzrqxx/rzrqjy/"


date <- as.Date("2016-01-01")

remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open()
print("remote driver started")

## get the web content
remDr$navigate(url)
Sys.sleep(5) ## give the browser a moment


while (date < as.Date("2016-09-30")) {
  
  ## read the history data from file
  sz_data <- read.csv("SZ.csv", colClasses = "character")

  print(date)
  
  ## create a phantom server and connect to it
##  pJS <- phantom()
##  Sys.sleep(5)   ## give the binary a moment
##  print("phantom server started")  

##  remDr <- remoteDriver(browserName = 'phantomjs')
##  remDr$open()
##  print("remote driver started")
  
##  ## get the web content
##  remDr$navigate(url)
##  Sys.sleep(5) ## give the browser a moment
  
  ## get the elements of the webpage
  webElem_datepicker <- remDr$findElement(using = 'xpath', 
                                          value = "//input[@class='cls-datepicker']")
  webElem_datepicker$clearElement()
  webElem_datepicker$sendKeysToElement(list(as.character(date)))
  webElem_datepicker$clickElement()
  
  
  ## set the datepicker and increment date with 1
  webElem_submit <- remDr$findElement(using = 'xpath', 
                                      value = "//input[@class='cls_search_button']")
  webElem_submit$clickElement()
  print("submitted")
  Sys.sleep(5)

  date <- date + 1;
  
  ## get the date of the data
  webElem_date <- remDr$findElements(using = 'xpath', 
                                     value = "//span[@class='cls-subtitle']")
  
  print(length(webElem_date))

  if (length(webElem_date) > 0) {
    data_date <- webElem_date[[1]]$getElementText()
    print(data_date)
    
    ## get the data
    webElems <- remDr$findElements(using = 'xpath', 
                                   value = "//td[@class='cls-data-td']")
    
    RZMRE <- webElems[[1]]$getElementText() 
    RZYE <- webElems[[2]]$getElementText()  
    RQMCL <- webElems[[3]]$getElementText() 
    RQYL <- webElems[[4]]$getElementText()  
    RQYE <- webElems[[5]]$getElementText()  
    RZRQYE <- webElems[[6]]$getElementText()  
    
    ## add the new data to the history data
    if (!(data_date %in% sz_data[,1])) 
      sz_data[nrow(sz_data) + 1,] <- c(data_date, 
                                       RZMRE, RZYE, RQMCL, RQYL, RQYE, RZRQYE)
  }

  ## close the connection and stop the phantom server
##  remDr$close()
##  Sys.sleep(5)
##  print("remote driver closed")

##  pJS$stop()
##  Sys.sleep(5)  
##  print("phantom server closed")

  ## write the data to the file                                                                                                                        
  write.csv(sz_data, file = "SZ.csv", row.names = FALSE)        
  Sys.sleep(3)
}

  ## close the connection and stop the phantom server                                                                                                
  remDr$close()                                                                                                                                      
  Sys.sleep(5)                                                                                                                                       
  print("remote driver closed")          




