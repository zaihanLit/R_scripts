## load the package "rvest"
library(rvest)

## set the working directory
setwd("/root/R_scripts")

## the url of SHENZHEN STOCK EXCHANGE
url <- "http://www.szse.cn/main/disclosure/rzrqxx/rzrqjy/"

## get the web content
web <- read_html(url, encoding = "gb2312")

## get the nodes of the data
data_nodes <- html_nodes(web, "tr td") %>% html_nodes("[class=cls-data-td]")

## get the data
RZMRE <- html_text(data_nodes[1])  ## ���������
RZYE <- html_text(data_nodes[2])  ## �������
RQMCL <- html_text(data_nodes[3])  ## ��ȯ������
RQYL <- html_text(data_nodes[4])  ## ��ȯ����
RQYE <- html_text(data_nodes[5])  ## ��ȯ���
RZRQYE <- html_text(data_nodes[6])  ## ������ȯ���

## get the date of the data
data_date <- html_text(html_nodes(web, "tr span") %>% html_nodes("[class=cls-subtitle]"))

## read the history data from file
sz_data <- read.csv("SZ.csv", colClasses = "character")

## add the new data to the history data
if (!(data_date %in% sz_data[,1])) 
      sz_data[nrow(sz_data) + 1,] <- c(data_date, 
                                       RZMRE, RZYE, RQMCL, RQYL, RQYE, RZRQYE)

## write the data to the file
write.csv(sz_data, file = "SZ.csv", row.names = FALSE)

