# Merging the RSS Data with the Kaggle Data

library(dplyr)
library(readr)

# Change the file paths to the RSS data collection CSV and podsearch-final.csv
podsearch_rss_data <- read.csv("result_csv/combined_good/podsearch_df_04_06_2023_v1.csv")
podsearch_kaggle <- read.csv("scrape_csv/podsearch_final.csv")

# Renames xml link column so dataframes can be merged on that index.
colnames(podsearch_kaggle)[colnames(podsearch_kaggle) == "RSS.Links"] ="xml_link"

# Left joins the two dataframes.
pod_complete_testing_v2 <- left_join(podsearch_rss_data, podsearch_kaggle, by="xml_link")
pod_complete_testing_v2 <- pod_complete_testing_v2[!is.na(pod_complete_testing_v2$categories),]

# Takes note of all the column names within the merged dataframe.
colnames(pod_complete_testing_v2)

# Chooses the columns to keep in final version. 
pod_complete_testing_v2 <- pod_complete_testing_v2[c("xml_link", "title.x", "description", "show_link", "number_episodes","explicit", "birthday", "zodiac", "podcast_id", "average_rating", "ratings_count", "categories")]
colnames(pod_complete_testing_v2)

#########################

# Writes large df into its own large csv to save
date <- format(Sys.Date(), '%m_%d_%Y')
csv_name <- paste("result_csv/combined_good/podsearch_df_complete_",date,"_v1.csv",sep="")
write.csv(pod_complete_testing_v2, csv_name)
