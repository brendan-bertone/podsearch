# Tidy Scrape Script (combine CSVs)

# take out dupes take out empties
# combine results of mine
library(dplyr)
library(readr)

# Reads in folder of CSVs. Must modify filepath to reflect where user is keeping the CSV results from the web scrape script.
pod_combined_df <- list.files(path="C:/Users/14804/Desktop/ISTA498Website/result_csv/good_to_use",
                              pattern="*.csv",
                              full.names=TRUE) %>%
  lapply(read_csv) %>%
  bind_rows
  
# Take out messed up index column and removes rows that are entirely NAs that made it past the script.
pod_combined_df <- pod_combined_df[,-1]
pod_combined_df <-pod_combined_df[rowSums(is.na(pod_combined_df)) != ncol(pod_combined_df),]

# Some weird entries still making it through. Deleting rows which don't have a zodiac in zodiac.
zodiac_list= c("Capricorn", "Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius")
pod_combined_df <- pod_combined_df[pod_combined_df$zodiac %in% zodiac_list,]

# Takes out duplicates based on title
pod_combined_df <- pod_combined_df%>% distinct(title, .keep_all = TRUE)

#########################

# Writes large df into its own large CSV to save.
date <- format(Sys.Date(), '%m_%d_%Y')
csv_name <- paste("result_csv/combined_good/podsearch_df_",date,"_v1.csv",sep="")
write.csv(pod_combined_df, csv_name)
