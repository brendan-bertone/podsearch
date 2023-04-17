#install.packages("rjson")
#install.packages("jsonlite")
#install.packages('dplyr')
#install.packages("Dict")
#install.packages('pandas')
#install.packages('tidyverse')

library("rjson")
library("jsonlite")
library ("dplyr")
library('tidyverse')
library("Dict")

# Be sure to change file paths as needed

# Imports the Reviews JSON File to Data Frame
reviews_orginal <- stream_in(file("C:/Users/brend/OneDrive/Desktop/reviews.json"))

# Imports the Podcast JSON File to Data Frame
podcast_orginal <- stream_in(file("C:/Users/brend/OneDrive/Desktop/podcasts.json"))

# Imports the Categories JSON File to Data Frame
categories_orginal <- stream_in(file("C:/Users/brend/OneDrive/Desktop/categories.json"))

# Filters down the podcast df to data to only those that have data in every column, then filers it based on average rating and number of reviews
podcast_filtered <- podcast_orginal[,c('podcast_id','title','average_rating','ratings_count')]
podcast_filtered <- podcast_filtered[!is.na(podcast_filtered$title),]
podcast_filtered <- podcast_filtered[!is.na(podcast_filtered$average_rating),]

# Filters podcast to those that have average rating of 5
podcast_filtered <- filter(podcast_filtered, average_rating >= 5)

# Podcasts that had over 1000 ratings count so convert them all to numeric with a value of 1000
podcast_filtered$ratings_count <- as.numeric(as.character(podcast_filtered$ratings_count))
podcast_filtered[is.na(podcast_filtered)] = 1000

# Filter podcasts to those that have over 50 ratings count
podcast_filtered <- filter(podcast_filtered, ratings_count >= 50)

# This code gets the number of reviews and categories that were in the podcast_filtered dataframe
reviews_filtered <- filter(reviews_orginal, 
                        podcast_id %in% podcast_filtered$podcast_id)

categories_filtered <- filter(categories_orginal, 
                           podcast_id %in% podcast_filtered$podcast_id)
  
# Creates the Dictionary for Reviews and takes the first 5 reviews. Key is the podcast id value is a list of the reviews 
# Only run if there is data in reviews_filtered. If not then skip till line 78
reviews_dict <- Dict$new(
  'temp' = c(2,3)
)

count = 1

for (i in 1:nrow(reviews_filtered)){
  key =  reviews_filtered[i,1]
  value = reviews_filtered[i,3]
  print(paste('i= ', i))
  if (reviews_dict$has(key)){
    if ((length(reviews_dict[key])) < 5){
      reviews_dict[key] <- append(reviews_dict[key],value)
    } else {
      reviews_dict[key] <- reviews_dict[key]
    }
  } else {
    print(paste('podcast', count))
    count <- count + 1
    reviews_dict[key] <- c(value)
  }
}
reviews_dict$remove('temp')

# Creates a nested list then a dataframe with the reviews that were in the podcast_filtered
nested_list_reviews <- list(podcast_id = reviews_dict$keys, 
                    reviews = reviews_dict$values)

reviews_df <- as.data.frame(do.call(cbind, nested_list_reviews))

# Creates Dictionary for Categories. Key is podcast_id, Value is a list with the categories
categories_dict <- Dict$new(
  'temp' = c(2,3)
)

count = 1

for (i in 1:nrow(categories_filtered)){
  key =  categories_filtered[i,1]
  value = categories_filtered[i,3]
  print(paste('i = ', i))
  if (categories_dict$has(key)){
    categories_dict[key] <- append(categories_dict[key],value)
  } else {
    print(paste('podcast', count))
    count <- count + 1
    categories_dict[key] <- c(value)
  }
}
categories_dict$remove('temp')

# Creates a nested list and dataframe with the categories that were in the podcast_filtered
nested_list_categories <- list(podcast_id = categories_dict$keys, 
                    categories = categories_dict$values)

categories_df <- as.data.frame(do.call(cbind, nested_list_categories))

# Merging Tables of podcast_filtered, categories_df, and reviews_df
total <- merge(x = podcast_filtered, y = reviews_df, by="podcast_id", all.x = TRUE)
total <- merge(x = podcast_filtered, y = categories_df, by="podcast_id")

# Creates a new function that turns the lists into characters. Goes Row by Row. Got this from stack overflow
# Using this so we can save the lists into a CSV file
set_lists_to_chars <- function(x) {   
  if(class(x) == 'list') {
    y <- sapply(seq(x), function (y) paste(unlist(x[y]), sep='', collapse=', '))
  } else {     
    y <- x  }   
  return(y)
}

# Creates the new data frames with the lists as characters
kaggle_final <- data.frame(lapply(total, set_lists_to_chars), stringsAsFactors = F)

# Writes the Kaggle Final CSV
# This will be used to merge the kaggle data and Rss Links
write.csv(kaggle_final, file='C:/Users/brend/OneDrive/Desktop/kaggle_all.csv')

# This creates a table with only the podcast_id and title. This will be used for the webscrapper
podcast_id_titles = select(kaggle_final, podcast_id, title)
write.csv(podcast_id_titles, "C:/Users/brend/OneDrive/Desktop/podcast_id_titles.csv", row.names=FALSE)

