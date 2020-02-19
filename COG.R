# This script can:
  # open cog files
  # merge results into table

#if the package dplyr isn't installed, uncomment next line (remove #):
#install.packages('dplyr', repos = 'https://cloud.r-project.org')
#load package:
library("dplyr")

#set directory (substitute inside " ")
#setwd("C:/Users/sandr/Dropbox/Costa Lab (MicroEcoEvo)/Lab and Data Analysis Protocols/Bioinformatic tools & Scripts/Workflow COG and Pfam")
getwd()

#list .txt files in the directory 
list.filenamesc <- list.files(pattern=".txt$")
str(list.filenamesc)

#removes possible file.txt already produced to this directory
#list.filenamesc[!grepl("cog_file.txt", list.filenamesc)]

# creates an empty list that will serve as a container to receive the incoming files
list.datac <-list()

# creates a loop to read in your data
for (i in 1:length(list.filenamesc))
  {aux_listc<-read.table(list.filenamesc[i], 
                        sep="\t", header=TRUE, quote="", fill=FALSE)
  aux_listc<-aux_listc[,-c(4,5)]
  colnames(aux_listc)[3]<-list.filenamesc[i]
  list.datac[[i]]<-aux_listc
}

#adds the names of your data to the list
names(list.datac) <- list.filenamesc
str(list.datac)
final_mergec<-list.datac[[1]]

#CHANGE 26 to number of files in analysis
for (i in 2:length(list.datac)){
  final_mergec <- full_join(final_mergec, list.datac[[i]], by="Accession")
  print(i)}

#changes NA to zero
final_mergec[is.na(final_mergec)] <- 0
str(final_mergec)

##########################################
NAME <- grep("Name", names(final_mergec))
DES <- grep("Description", names(final_mergec))

NAMEc <- final_mergec[, NAME]
Descriptionc <- final_mergec[, DES]

COG_only <- final_mergec[,-NAME]
DES2 <- grep("Description", names(COG_only))
COG_only <- COG_only[, -DES2]

#NAME
finalC <- character()
row_iC <- 1

for (row_iC in 1:nrow(NAMEc)) {
  for(col_iC in 1:ncol(NAMEc)){
    if (!is.na(NAMEc[row_iC,col_iC])){
      finalC[row_iC] <- as.character(NAMEc[row_iC,col_iC])
      break
    }
  }
}
str(finalC)
#########################
#Descrition
finalDC <- character()
row_iDC <- 1

for (row_iDC in 1:nrow(Descriptionc)) {
  for(col_iDC in 1:ncol(Descriptionc)){
    if (!is.na(Descriptionc[row_iDC,col_iDC])){
      finalDC[row_iDC] <- as.character(Descriptionc[row_iDC,col_iDC])
      break
    }
  }
}
str(finalDC)

######################
#bind everything
COG_final <- cbind(finalC, finalDC, COG_only)

#correct column names
colnames(COG_final)[colnames(COG_final)=="finalC"] <- "Name"
colnames(COG_final)[colnames(COG_final)=="finalDC"] <- "Description"
colnames(COG_final) <- sub(".txt", "", colnames(COG_final))

#put Accession in first column
COG_final <- COG_final %>%
  select(Accession, everything())

##############################################################################

#tab separated file
write.table(COG_final, "cog_table.txt", sep="\t", row.names = FALSE, quote=FALSE)
