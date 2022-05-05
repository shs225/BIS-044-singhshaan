#Install packages and read the csv
if(!require("ggplot2")) install.packages("ggplot2")
library("ggplot2")
if(!require("ggplotgui")) install.packages("ggplotgui")
library("ggplotgui")
if(!require("dplyr")) install.packages("dplyr")
library("dplyr")
if(!require("tidyverse")) install.packages("tidyverse")
library("tidyverse")
tonnage <- read.csv("~/Desktop/TBQ05.20211116133909.csv")

#Convert VALUE to numeric.
tonnage$VALUE <- as.numeric(tonnage$VALUE)

#Replace all "NA" values with zero.
tonnage$VALUE[is.na(tonnage$VALUE)] = 0

#Print to the console a breakdown by Region.of.Trade.
n <- nrow(tonnage)
all <- 0
coastal <- 0
gbnr <- 0
nonEu <- 0
otherEu <- 0
otherPorts <- 0

for (i in 1:n) {
  if(tonnage$Region.of.Trade[i] == "All regions of trade") {
    all <- all + tonnage$VALUE[i]
  } else if (tonnage$Region.of.Trade[i] == "Coastal trade") {
    coastal <- coastal + tonnage$VALUE[i]
  } else if (tonnage$Region.of.Trade[i] == "Foreign trade: Great Britain and Northern Ireland") {
    gbnr <- gbnr + tonnage$VALUE[i]
  } else if (tonnage$Region.of.Trade[i] == "Foreign trade: Non-EU") {
    nonEu <- nonEu + tonnage$VALUE[i]
  } else if (tonnage$Region.of.Trade[i] == "Foreign trade: Other EU") {
    otherEu <- otherEu + tonnage$VALUE[i]
  } else if (tonnage$Region.of.Trade[i] == "Foreign trade: Other ports") {
    otherPorts <- otherPorts + tonnage$VALUE[i]
  }
}
cat("tonnage$Region.of.Trade: All regions of trade\n", all, "\n---------------------------------------------\ntonnage$Region.of.Trade: Coastal trade\n", coastal, "\n---------------------------------------------\ntonnage$Region.of.Trade: Foreign trade: Great Britain and Northern Ireland\n", gbnr, "\n---------------------------------------------\ntonnage$Region.of.Trade: Foreign trade: Non-EU\n", nonEu, "\n---------------------------------------------\ntonnage$Region.of.Trade: Foreign trade: Other EU\n", otherEu, "\n---------------------------------------------\ntonnage$Region.of.Trade: Foreign trade: Other Ports\n", otherPorts)

#Reduce data to exclude entries for "All Main Irish Ports" and only include trade from GBNR
tonnage_reduced <- subset(tonnage, tonnage$Port != "All Main Irish Ports")
tonnage_reduced <- subset(tonnage_reduced, tonnage$C01713V02044 == 1)

#Produce the graphic
tonnage_reduced %>%
  drop_na %>%
  ggplot(aes(Quarter, VALUE, colour = Port)) + 
  geom_point() + 
  ggtitle("Quarterly Tonnage Arriving From Great Britain and Northern Ireland") + 
  ylab("Tonnage")

