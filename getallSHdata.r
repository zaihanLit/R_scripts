## load the package "rvest"
library(RSelenium)

## the url of SHENZHEN STOCK EXCHANGE
url <- "http://www.sse.com.cn/market/othersdata/margin/sum/"


remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open()

remDr$navigate(url)


## set the start date to "2016-01-01"
webElem_datepicker <- remDr$findElement(using = 'xpath',
                                        value = "//input[@id='start_date']")
Sys.sleep(3)
webElem_datepicker$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "th.switch")
Sys.sleep(3)
webElems[[3]]$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "span.month")
Sys.sleep(3)
webElems[[1]]$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "td.day")
Sys.sleep(3)
webElems[[6]]$clickElement()
Sys.sleep(3)


## set the end date to "2016-01-01"
webElem_datepicker <- remDr$findElement(using = 'xpath',
                                        value = "//input[@id='end_date']")
Sys.sleep(3)
webElem_datepicker$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "th.switch")
Sys.sleep(3)
webElems[[8]]$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "span.month")
Sys.sleep(3)
webElems[[13]]$clickElement()
Sys.sleep(3)

webElems <- remDr$findElements(using = 'css selector', value = "td.day")
Sys.sleep(3)
webElems[[48]]$clickElement()
Sys.sleep(3)

## click the query button
webElem <- remDr$findElement(using = 'css selector', value = "button.btn.btn-primary")
Sys.sleep(3)
webElem$clickElement()
Sys.sleep(3)

date <- as.Date("2016-01-01")

while (date < as.Date("2016-09-30")) {
  
  print(date)

  ## get the nodes of the data
  webElems <- remDr$findElements(using = 'css selector', value = "tr td a")
  Sys.sleep(10) ## give the browser a moment
  
  print("get data")

  ##webElems[[2]]$getElementText() 
  
  ## get the data
  if (!(length(webElems) == 0)) {
    ## get the date of the data
    data_date <- webElems[[1]]$getElementText()
    print(data_date)
    
    ## get the data
    webElems <- remDr$findElements(using = 'css selector', value = "div.align_right")
    Sys.sleep(10)
    RZMRE <- webElems[[2]]$getElementText()  
    Sys.sleep(3)
    RZYE <- webElems[[1]]$getElementText()  
    Sys.sleep(3)
    RQMCL <- webElems[[5]]$getElementText()  
    Sys.sleep(3)
    RQYL <- webElems[[3]]$getElementText()  
    Sys.sleep(3)
    RQYE <- webElems[[4]]$getElementText()  
    Sys.sleep(3)
    RZRQYE <- webElems[[6]]$getElementText()  
    Sys.sleep(3)
  

    
    ## read the history data from file
    sh_data <- read.csv("SH.csv", colClasses = "character")
    
    ## add the new data to the history data
    if (!(data_date %in% sh_data[,1])) 
      sh_data[nrow(sh_data) + 1,] <- c(data_date, 
                                       RZMRE, RZYE, RQMCL, RQYL, RQYE, RZRQYE)
  
    ## write the data to the file
    write.csv(sh_data, file = "SH.csv", row.names = FALSE)
  
  }
  
  ## increment the start date with 1
  webElem_datepicker <- remDr$findElement(using = 'xpath',
                                          value = "//input[@id='start_date']")
  Sys.sleep(3)
  webElem_datepicker$clickElement()
  Sys.sleep(3)

  ## select next day on the datepicker
  webElems <- remDr$findElements(using = 'css selector', value = "td.day")
  Sys.sleep(3)
  l <- length(webElems)
  i <- 1
  while (i < l) {
    class <- webElems[[i]]$getElementAttribute("class")
    i <- i + 1
      if ((class == "day active") & (webElems[[i]]$getElementText() != "")) {
      break
    }
  }
  webElems[[i]]$clickElement()
  Sys.sleep(3)

  ## increment the end date with 1
  webElem_datepicker <- remDr$findElement(using = 'xpath',
                                          value = "//input[@id='end_date']")
  Sys.sleep(3)
  webElem_datepicker$clickElement()
  Sys.sleep(3)
  
  ## select next day on the datepicker
  webElems <- remDr$findElements(using = 'css selector', value = "td.day")
  Sys.sleep(3)
  l <- length(webElems)
  i <- 1
  while (i < l) {
    class <- webElems[[i]]$getElementAttribute("class")
    i <- i + 1
    if ((class == "day active") & (webElems[[i]]$getElementText() != "")) {
      break
    }
  }
  webElems[[i]]$clickElement()
  Sys.sleep(3)

  ## click the query button
  webElem <- remDr$findElement(using = 'css selector', value = "button.btn.btn-primary")
  Sys.sleep(3)
  webElem$clickElement()
  Sys.sleep(3)
  
  
  date <- date + 1
  
}

remDr$close()
remDr$closeServer()
