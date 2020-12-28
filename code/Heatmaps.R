# load libraries
library(ggplot2)
library(ggridges)
library(tidyverse)
library(dplyr)
library(scales)
library(viridis)
library(corrplot)

# infile name
infile.data <- "COVID19GS6.csv"

# outfile names
outfile.by.speaker <- "Support_for_SD_measures_heatmaps_by_speaker.pdf"
outfile.by.country <- "Support_for_SD_measures_heatmaps_by_country.pdf"

# order of countries
countryorder <- c("BR","KR","IT","US","ES","CH")
countrynames <- c("BR"="Brazil","KR"="South Korea","IT"="Italy","US"="United States","ES"="Spain","CH"="Switzerland", "Avg"="Avg")

# order of speakers
speakerorder <- c("No Speaker","Fauci","Government","Hanks","Kardashian")

# order of age groups
ageorder <- c("Young", "Mid-Age", "Old")

# Color schemes

# sixcolor viridis
sixcolor1 <- "#ffcc00ff" # orange-yellow
sixcolor2 <- "#b8de29ff" # green
sixcolor3 <- "#3cbb75ff" # teal
sixcolor4 <- "#238a8dff" # blue green
sixcolor5 <- "#39568cff" # blue-purple
sixcolor6 <- "#481567ff" # purple
sixcolorscheme <- c(sixcolor1, sixcolor2, sixcolor3, sixcolor4, sixcolor5, sixcolor6)
threecolorscheme <- c(sixcolor2, sixcolor4, sixcolor6)
threecolorscheme2 <- c(sixcolor1, sixcolor3, sixcolor5)

# read data
data <- read.table(infile.data, header = TRUE, sep = ",", quote = "", comment.char = "", stringsAsFactors = FALSE)


########################################
# Social Distancing Endorsement Country x Measure Matrix
########################################

# select data subset
data.sub <- data[, c(2,4,38:46)]

# iterate over spokespersons
spokespersons <- unique(data.sub$Spokesperson)

plotdata <- data.frame(Country=character(0),Measure=character(0),Value=numeric(0),Spokesperson=character(0))
for (speaker in spokespersons) {

    subdata <- data.sub[data.sub$Spokesperson == speaker,]
    subdata <- subdata[,which(names(subdata) != "Spokesperson")]

    # aggregate data / compute mean
    a <- group_by(subdata, Country) %>% summarize(Self_isolation = mean(Q6.Self.Isolation1))
    b <- group_by(subdata, Country) %>% summarize(Quarantine_zones = mean(Q6.Quarantine.Zones1))
    c <- group_by(subdata, Country) %>% summarize(Closing_borders = mean(Q6.Closing.Borders1))
    d <- group_by(subdata, Country) %>% summarize(Not_meeting_friends = mean(Q6.Meeting.Friends1))
    e <- group_by(subdata, Country) %>% summarize(Physical_distance = mean(Q6.Physical.Distance1))
    f <- group_by(subdata, Country) %>% summarize(Closing_businesses = mean(Q6.Closing.Businesses1))
    g <- group_by(subdata, Country) %>% summarize(Closing_pub._transport = mean(Q6.Public.Transportation1))
    h <- group_by(subdata, Country) %>% summarize(Canceling_events = mean(Q6.Canceling.Events1))
    i <- group_by(subdata, Country) %>% summarize(Not_going_to_work = mean(Q6.No.Workplace1))
    subdata <- data.frame(a,b,c,d,e,f,g,h,i)

    # drop extra country columns
    removecolumns <- paste("Country",1:8,sep=".")
    subdata <- subdata[,which(!names(subdata) %in% removecolumns)]

    # add column for row averages
    subdata$Avg <- rowMeans(subdata[,2:10]);

    # add row for column averages
    newrow <- colMeans(subdata[,2:11])
    newrow$Country <- "Avg"
    newrow <- as.data.frame(newrow)
    subdata <- rbind(subdata,newrow)

    # reshape for plotting
    plotdata.tmp <- subdata %>% gather(Measure, Value, 2:11)

    # add speaker and merge to overall plotdata
    plotdata.tmp$Spokesperson <- speaker
    plotdata <- rbind(plotdata,plotdata.tmp)
}

# repeat for full data set
subdata <- data.sub

# aggregate data / compute mean
a <- group_by(subdata, Country) %>% summarize(Self_isolation = mean(Q6.Self.Isolation1))
b <- group_by(subdata, Country) %>% summarize(Quarantine_zones = mean(Q6.Quarantine.Zones1))
c <- group_by(subdata, Country) %>% summarize(Closing_borders = mean(Q6.Closing.Borders1))
d <- group_by(subdata, Country) %>% summarize(Not_meeting_friends = mean(Q6.Meeting.Friends1))
e <- group_by(subdata, Country) %>% summarize(Physical_distance = mean(Q6.Physical.Distance1))
f <- group_by(subdata, Country) %>% summarize(Closing_businesses = mean(Q6.Closing.Businesses1))
g <- group_by(subdata, Country) %>% summarize(Closing_pub._transport = mean(Q6.Public.Transportation1))
h <- group_by(subdata, Country) %>% summarize(Canceling_events = mean(Q6.Canceling.Events1))
i <- group_by(subdata, Country) %>% summarize(Not_going_to_work = mean(Q6.No.Workplace1))
subdata <- data.frame(a,b,c,d,e,f,g,h,i)

# drop extra country columns
removecolumns <- paste("Country",1:8,sep=".")
subdata <- subdata[,which(!names(subdata) %in% removecolumns)]

# add column for row averages
subdata$Avg <- rowMeans(subdata[,2:10]);

# add row for column averages
newrow <- colMeans(subdata[,2:11])
newrow$Country <- "Avg"
newrow <- as.data.frame(newrow)
subdata <- rbind(subdata,newrow)

# reshape for plotting
plotdata.tmp <- subdata %>% gather(Measure, Value, 2:11)

# add speaker and merge to overall plotdata
plotdata.tmp$Spokesperson <- "All"
plotdata <- rbind(plotdata,plotdata.tmp)

# fix label Spokerspeson -> Speaker
plotdata$Spokesperson[plotdata$Spokesperson == "No Spokesperson"] <- "No Speaker"

# fix label KO -> KR
plotdata$Country[plotdata$Country == "KO"] <- "KR"

# replace _ with whitespaces for labels
plotdata$Measure <- gsub("_", " ", plotdata$Measure, fixed = TRUE)

# create factor order for Countries
countryorder_heatmap <- c("ES","US","CH","IT","BR","KR","Avg")
plotdata$Country <- factor(plotdata$Country, levels = countryorder_heatmap)

# create factor order for measures
measureorder_heatmap <- c("Canceling events","Self isolation","Closing businesses","Physical distance","Closing borders","Not meeting friends","Closing pub. transport","Not going to work","Quarantine zones","Avg")
plotdata$Measure <- factor(plotdata$Measure, levels = rev(measureorder_heatmap))

# create factor order for speakers
speakerorder <- c("No Speaker","Fauci","Government","Hanks","Kardashian","All")
plotdata$Spokesperson <- factor(plotdata$Spokesperson, levels = speakerorder)

# create shortened values for labels
plotdata$Value.short <- round(plotdata$Value,2)

# add columns for determining label colors
plotdata$labelcolor <- "black"
plotdata$labelcolor[plotdata$Value <= 0.45] <- "white"

# plot the heatmap (speakers as facets)
p <- ggplot(data = plotdata, aes(y=Measure, x=Country, fill=Value))
p <- p + geom_tile()
p <- p + geom_text(aes(y=Measure, x=Country, label = Value.short, colour = labelcolor), size = 3)
p <- p + scale_fill_viridis(limits = c(0.15,1.0))
p <- p + scale_colour_manual(values=c("black"="black","white"="azure3"))
p <- p + guides(colour = FALSE)
p <- p + scale_x_discrete(labels=countrynames)
p <- p + theme_bw()
p <- p + guides(fill = guide_colourbar(barwidth = 0.7, barheight = 9))
p <- p + labs(fill="Mean support")
p <- p + theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())
p <- p + theme(strip.background = element_blank())
p <- p + theme(axis.text.x = element_text(color="black"), axis.text.y = element_text(color="black"))
p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
p <- p + facet_wrap(~Spokesperson, ncol=3, scales="free_x")
p <- p + ylab("Social distancing measures") + xlab("Country")
ggsave(outfile.by.speaker, width=230, height=190, units="mm")

# remove "Avg" country
plotdata2 <- plotdata[plotdata$Country != "Avg",]

# plot the heatmap (countries as facets)
p <- ggplot(data = plotdata2, aes(y=Measure, x=Spokesperson, fill=Value))
p <- p + geom_tile()
p <- p + geom_text(aes(y=Measure, x=Spokesperson, label = Value.short, colour = labelcolor), size = 3)
p <- p + scale_fill_viridis(limits = c(0.15,1.0))
p <- p + scale_colour_manual(values=c("black"="black","white"="azure3"))
p <- p + guides(colour = FALSE)
p <- p + theme_bw()
p <- p + guides(fill = guide_colourbar(barwidth = 0.7, barheight = 9))
p <- p + labs(fill="Mean support")
p <- p + theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())
p <- p + theme(axis.text.x = element_text(color="black"), axis.text.y = element_text(color="black"))
p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
p <- p + facet_wrap(~Country, ncol=3)
p <- p + ylab("Social distancing measures") + xlab("Spokesperson")
ggsave(outfile.by.country, width=240, height=160, units="mm")
