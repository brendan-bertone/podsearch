library(dplyr)
library(readr)

# Uploads CSV that has podcast_id, title, and RSS Links
# Change the file path to Podcast_Titles_RSS_Links_MASTER.csv
podsearch <- read.csv("C:/Users/brend/OneDrive/Desktop/Podcast_Titles_RSS_Links_MASTER.csv")

# Uploads CSV that has all the kaggle data
kaggle_final <- read.csv("C:/Users/brend/OneDrive/Desktop/kaggle_all.csv")

# Merege the two dataframses
podsearch_final <- merge(x = kaggle_final, y = podsearch, by="podcast_id")

# Drops the duplicate title/name column
podsearch_final <- podsearch_final %>% select(-Names)
podsearch_final <- podsearch_final %>% select(-X)

# Drops the lines that had NA for RSS Links
podsearch_final <- podsearch_final[!is.na(podsearch_final$RSS.Links),]

# Dorps the lines that had no value for RSS Links
podsearch_final <- podsearch_final[!(is.na(podsearch_final$RSS.Links) | podsearch_final$RSS.Links==""), ]

# Prints the final version of the data frame to a file
write.csv(podsearch_final, file='C:/Users/brend/OneDrive/Desktop/podsearch_final.csv')