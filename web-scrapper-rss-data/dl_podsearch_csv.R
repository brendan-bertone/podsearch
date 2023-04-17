# Download CSV of podsearch_df


# Note: Run the most recent PodSearch scrape script to get the version of podsearch_df you would like to save in the environment.

# Make a datetime for today
date <- format(Sys.Date(), '%m_%d_%Y')

# Makes filename with today's date. Modify filepath to sort new CSV into wherever you would like to store it.
csv_name <- paste("result_csv/good_to_use/podsearch_df_",date,"_v1.csv",sep="")

# Writes it and sticks it in the folder!
write.csv(podsearch_df, csv_name)
