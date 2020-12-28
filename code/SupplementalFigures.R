
# load libraries
library(ggplot2)
library(ggridges)
library(tidyverse)
library(dplyr)
library(scales)
library(corrplot)
library(colorspace) # for corrplot coloring

# infile name
infile.data <- "COVID19GS6.csv"

# outfile names
outfile.fig.sharing <- "Sharing_by_country_and_speaker.pdf"
outfile.fig.age <- "Sharing_by_age_group_and_speaker.pdf"
outfile.fig.country <- "Sharing_by_age_group_and_country.pdf"
outfile.fig.corrplot <- "Corrplot.pdf"

# order of countries
countryorder <- c("BR","KR","IT","US","ES","CH")
countrynames <- c("BR"="Brazil","KR"="South Korea","IT"="Italy","US"="United States","ES"="Spain","CH"="Switzerland")

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
# Ridge plot for Country x Spokesperson
########################################

# create data set for plotting
plotdata <- data[,c("Country", "Message.Sharing", "Spokesperson")]

# fix label KO -> KR
plotdata$Country[plotdata$Country == "KO"] <- "KR"

# fix label Spokerspeson -> Speaker
plotdata$Spokesperson[plotdata$Spokesperson == "No Spokesperson"] <- "No Speaker"

# sort factor levels for the new Y column
plotdata$Country <- factor(plotdata$Country, levels = rev(countryorder))

# sort factor levels for speakers
plotdata$Spokesperson <- factor(plotdata$Spokesperson, levels = speakerorder)

# define x axis breaks
xbreaks <- c(1:7)

# data for the labels in each facet
vec.y <- rep(6.8,5)
vec.x <- rep(0.5,5)
vec.Spokesperson <- c("No Speaker","Fauci","Government","Hanks","Kardashian")
vec.label <- c("No Speaker","Fauci","Government","Hanks","Kardashian")
plotdata.text <- data.frame(y.pos = vec.y, x.pos = vec.x, Spokesperson = vec.Spokesperson, textlabel=vec.label)

# create plot
p <- ggplot(plotdata, aes(y=Country, x=Message.Sharing, colour = Spokesperson, fill=Spokesperson))
p <- p + geom_density_ridges(scale = 0.94, panel_scaling = FALSE, draw_baseline = FALSE, stat = "binline", bins = 7, center=1, binwidth=1)
p <- p + scale_fill_manual(values = alpha(sixcolorscheme, 0.3))
p <- p + scale_colour_manual(values=sixcolorscheme)
p <- p + scale_x_continuous(breaks=xbreaks, expand = expand_scale(mult = 0, add = c(-0.7,-0.7)))
p <- p + scale_y_discrete(expand = expand_scale(mult = 0, add = c(0.2,0)), labels=countrynames)
p <- p + geom_text(data=plotdata.text, aes(x=x.pos, y=y.pos, label=textlabel), color="black", size=3, vjust = "inward", hjust = "inward")
p <- p + theme_bw()
p <- p + theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())
p <- p + theme(strip.background = element_blank(), strip.text.x = element_blank())
p <- p + theme(axis.text.x = element_text(color="black"), axis.text.y = element_text(color="black"))
p <- p + theme(legend.position="bottom")
p <- p + facet_wrap(~Spokesperson, ncol=5, scales="free_x")
p <- p + ylab("Country") + xlab("Message sharing score")
ggsave(outfile.fig.sharing, width=180, height=100, units="mm")


########################################
# Ridge plot for Age Group x Spokesperson
########################################

# create data set for plotting
plotdata <- data[,c("Age.Group", "Message.Sharing", "Spokesperson")]

# fix label Spokerspeson -> Speaker
plotdata$Spokesperson[plotdata$Spokesperson == "No Spokesperson"] <- "No Speaker"

# sort factor levels for the new Y column
plotdata$Age.Group <- factor(plotdata$Age.Group, levels = ageorder)

# sort factor levels for speakers
plotdata$Spokesperson <- factor(plotdata$Spokesperson, levels = rev(speakerorder))

# define x axis breaks
xbreaks <- c(1:7)

# data for the labels in each facet
vec.y <- rep(5.9,3)
vec.x <- rep(0.5,3)
vec.age <- c("Young", "Mid-Age", "Old")
vec.label <- c("Young", "Mid-Age", "Old")
plotdata.text <- data.frame(y.pos = vec.y, x.pos = vec.x, Age.Group = vec.age, textlabel=vec.label)

# create plot
p <- ggplot(plotdata, aes(y=Spokesperson, x=Message.Sharing, colour = Age.Group, fill=Age.Group))
p <- p + geom_density_ridges(scale = 0.94, panel_scaling = FALSE, draw_baseline = FALSE, stat = "binline", bins = 7, center=1, binwidth=1)
p <- p + scale_fill_manual(values = alpha(threecolorscheme, 0.3))
p <- p + scale_colour_manual(values=threecolorscheme)
p <- p + scale_x_continuous(breaks=xbreaks, expand = expand_scale(mult = 0, add = c(-0.7,-0.7)))
p <- p + scale_y_discrete(expand = expand_scale(mult = 0, add = c(0.2,0)) )
p <- p + geom_text(data=plotdata.text, aes(x=x.pos, y=y.pos, label=textlabel), color="black", size=3, vjust = "inward", hjust = "inward")
p <- p + theme_bw()
p <- p + labs(color="Age group", fill="Age group")
p <- p + theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())
p <- p + theme(strip.background = element_blank(), strip.text.x = element_blank())
p <- p + theme(axis.text.x = element_text(color="black"), axis.text.y = element_text(color="black"))
p <- p + facet_wrap(~Age.Group, ncol=3, scales="free_x")
p <- p + ylab("Spokesperson") + xlab("Message sharing score")
ggsave(outfile.fig.age, width=160, height=80, units="mm")


########################################
# Ridge plot for Age Group x Country
########################################

# create data set for plotting
plotdata <- data[,c("Age.Group", "Message.Sharing", "Country")]

# sort factor levels for the new Y column
plotdata$Age.Group <- factor(plotdata$Age.Group, levels = ageorder)

# fix label KO -> KR
plotdata$Country[plotdata$Country == "KO"] <- "KR"

# sort factor levels for speakers
plotdata$Country <- factor(plotdata$Country, levels = rev(countryorder))

# define x axis breaks
xbreaks <- c(1:7)

# data for the labels in each facet
vec.y <- rep(6.9,3)
vec.x <- rep(0.5,3)
vec.age <- c("Young", "Mid-Age", "Old")
vec.label <- c("Young", "Mid-Age", "Old")
plotdata.text <- data.frame(y.pos = vec.y, x.pos = vec.x, Age.Group = vec.age, textlabel=vec.label)

# create plot
p <- ggplot(plotdata, aes(y=Country, x=Message.Sharing, colour = Age.Group, fill=Age.Group))
p <- p + geom_density_ridges(scale = 0.94, panel_scaling = FALSE, draw_baseline = FALSE, stat = "binline", bins = 7, center=1, binwidth=1)
p <- p + scale_fill_manual(values = alpha(threecolorscheme2, 0.3))
p <- p + scale_colour_manual(values=threecolorscheme2)
p <- p + scale_x_continuous(breaks=xbreaks, expand = expand_scale(mult = 0, add = c(-0.7,-0.7)))
p <- p + scale_y_discrete(expand = expand_scale(mult = 0, add = c(0.2,0)), labels=countrynames)
p <- p + geom_text(data=plotdata.text, aes(x=x.pos, y=y.pos, label=textlabel), color="black", size=3, vjust = "inward", hjust = "inward")
p <- p + theme_bw()
p <- p + labs(color="Age group", fill="Age group")
p <- p + theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())
p <- p + theme(strip.background = element_blank(), strip.text.x = element_blank())
p <- p + theme(axis.text.x = element_text(color="black"), axis.text.y = element_text(color="black"))
p <- p + facet_wrap(~Age.Group, ncol=3, scales="free_x")
p <- p + ylab("Country") + xlab("Message sharing score")
ggsave(outfile.fig.country, width=160, height=90, units="mm")


########################################
# Correlation plot
########################################

# select data subset
subdata <- data[, c(11:28)]

#correlation matrix with Bonferroni correction, mixed plot
subdata.cor <- cor(subdata, method="spearman")
round(subdata.cor,3)

p.mat1 <- cor.mtest(subdata, method="spearman", conf.level = 0.95)
pAdj <- p.adjust(c(p.mat1[[1]]), method = "bonferroni")
round(pAdj, 3)

pmatAdj <- matrix(pAdj, ncol = dim(p.mat1[[1]])[1])
round(pmatAdj, 3)

purple.green.gradient <- diverging_hcl(n=100, palette = "Purple-Green")

# set names of columns and rows
newnames <- c("Message sharing", "Support SD", "Current practice SD", "Future practice SD", "Num. measures SD", "Age", "Education", "Household size", "Settlement size", "Concern for situation", "Concern for others", "Others SD", "Freedom of movement", "Infection percent", "Subjective health", "Satisfaction government", "Publ. health vs. economy", "Religiosity")
colnames(subdata.cor) <- newnames
rownames(subdata.cor) <- newnames

# plot and save to file
pdf(outfile.fig.corrplot)
corrplot.mixed(subdata.cor, lower.col = "black", upper.col = purple.green.gradient, number.cex = .6, upper = "square", tl.col = "black", bg = "white", tl.srt=45, tl.cex = .75, p.mat = pmatAdj, insig = "blank", pch.cex = 2, tl.pos = "lt")
dev.off()
