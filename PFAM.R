#This script can:
# open PFAM files
# merge results into table

#install.packages('dplyr', repos = 'https://cloud.r-project.org')
#load package:
library("dplyr")

#set directory (substitute inside " ")
#setwd("C:/Users/sandr/Dropbox/Costa Lab (MicroEcoEvo)/Lab and Data Analysis Protocols/Bioinformatic tools & Scripts/Workflow COG and Pfam")
getwd()

list.filenamesp <- list.files(pattern=".txt$")

#removes possible file.txt already produced to this directory
list.filenamesp[!grepl("PFAM_file.txt", list.filenamesp)]

# creates an empty list that will serve as a container to receive the incoming files
list.datap<-list()

# creates a loop to read in your data
for (i in 1:length(list.filenamesp))
{
  aux_listp<-read.table(list.filenamesp[i], 
                        sep="\t", header=TRUE, quote="", fill=FALSE)
  aux_listp<-aux_listp[,-c(3,4)]
  colnames(aux_listp)[2]<-list.filenamesp[i]
  list.datap[[i]]<-aux_listp
}

str(list.datap)
# adds the names of your data to the list
names(list.datap) <- list.filenamesp

final_mergep <-list.datap[[1]]

for (i in 2:length(list.datap)){
  final_mergep <- full_join(final_mergep, list.datap[[i]], by="Accession")
  print(i)
}

#change NA to zero
final_mergep[is.na(final_mergep)] <- 0

##########################################
NAME <- grep("Name", names(final_mergep))
DES <- grep("Description", names(final_mergep))

NAMEp <- final_mergep[, NAME]
Descriptionp <- final_mergep[, DES]

pfam_only <- final_mergep[,-NAME]
DES2 <- grep("Description", names(pfam_only))
pfam_only <- pfam_only[, -DES2]

#NAME
finalp <- character()
row_ip <- 1

for (row_ip in 1:nrow(NAMEp)) {
  for(col_ip in 1:ncol(NAMEp)){
    if (!is.na(NAMEp[row_ip,col_ip])){
      finalp[row_ip] <- as.character(NAMEp[row_ip,col_ip])
      break
    }
  }
}
str(finalp)
#########################
#Descrition
finalDp <- character()
row_iDp <- 1

for (row_iDp in 1:nrow(Descriptionp)) {
  for(col_iDp in 1:ncol(Descriptionp)){
    if (!is.na(Descriptionp[row_iDp,col_iDp])){
      finalDp[row_iDp] <- as.character(Descriptionp[row_iDp,col_iDp])
      break
    }
  }
}
str(finalDp)

######################
#bind everything
pfam_final <- cbind(finalp, finalDp, pfam_only)

#correct column names
colnames(pfam_final)[colnames(pfam_final)=="finalp"] <- "Name"
colnames(pfam_final)[colnames(pfam_final)=="finalDp"] <- "Description"
colnames(pfam_final) <- sub(".txt", "", colnames(pfam_final))

#put Accession in first column
pfam_final <- pfam_final %>%
  select(Accession, everything())

##############################################################################

#tab separated file
write.table(pfam_final, "pfam_table.txt", sep="\t", row.names = FALSE, quote=FALSE)