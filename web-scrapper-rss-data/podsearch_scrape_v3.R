# PodSearch RSS XML scrape script V3. 
# Inspired by article by John Bica

# Loads in packages!
library(dplyr)
library(lubridate)
library(rvest)
library(stringr)

library(tidyverse)
library(XML)
library(xml2)
library(DescTools)


# Makes the empty podsearch_df! 
columns <- c('xml_link', 'title','image_href','description','show_link','number_episodes','avg_duration_min','explicit', 'birthday', 'zodiac')
podsearch_df <- data.frame(matrix(nrow = 0, ncol = length(columns))) 
colnames(podsearch_df) <- columns

# Function that takes the RSS url and grabs all the datapoints for one podcast.
podcast_df_maker <- function(df_name,url){
  
  css_tags <- c('title', 'pubDate', 'itunes\\:explicit', 'itunes\\:duration')
  col_names <- c('title', 'date', 'explicit', 'duration')
  podcast_feed <- read_xml(url)
  items <- xml_nodes(podcast_feed, 'item')
  extract_element <- function(item, css_tags) {
    element <- xml_node(item, css_tags) %>% xml_text
  }
  podcast_df <- sapply(css_tags, function(x) {
    extract_element(items, x)}) %>% as_tibble()
  names(podcast_df) <- col_names
  
  # Values from podcast_df (created above):
  number_epis <- nrow(podcast_df)
  
  # Average duration of episodes.
  # Note: This value was removed at the left-join of datasets due to poor return rate.
  avg_duration_min<- round((((sum(as.integer(podcast_df$duration)))/(number_epis)) / 60)) 
  
  # Zodiac signs, based off first airdate. Uses DescTools package.
  birthday<- podcast_df$date[nrow(podcast_df)] 
  zodiac_raw <- Zodiac(strptime(birthday, "%a, %d %b %Y"))
  zodiacs_list <- c("Capricorn", "Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius")
  zodiac <- zodiacs_list[zodiac_raw]
  
  
  # Values from XML file:
  xml_file<- xmlParse(read_xml(url))  
  
  title<- xmlToDataFrame(getNodeSet(xml_file, '//channel/title'))
  # Note: This value was removed at the left-join of datasets due to poor return rate.
  image<- xmlToDataFrame(getNodeSet(xml_file, '//channel/image/url'))
  if(nrow(image)==0){
    image<- "NO IMAGE"}
  
  description<- xmlToDataFrame(getNodeSet(xml_file, '//channel/description'))
  rsslink<- xmlToDataFrame(getNodeSet(xml_file, '//channel/link')) 
  explicit <- xmlToDataFrame(getNodeSet(xml_file, '//channel/itunes:explicit'))
  explicit= ifelse(explicit %in% c("yes", "clean", "true"),
                   "explicit","not explicit")
  
  
  # Appends a column to podsearch_df about one individual podcast! 
  podsearch_df[i,] <- c(url, title, image, description, rsslink, number_epis, avg_duration_min, explicit, birthday, zodiac)
  return(podsearch_df)
}

# Loads in the CSV currently being used. Modify file location to reflect where you have CSV stored.
csv<- "scrape_csv/RSS_Links_4_6_Ver_1.csv"
csv_use <- read_csv(csv)
print(csv_use$rss_url)

# Runs each podcast RSS link through podcast_df_maker and appends the pod's info to podsearch_df_maker.
# Error warnings run for podcasts that will not be complete, and should be removed later.
for (i in 1:nrow(csv_use)){
  tryCatch( (podsearch_df <- podcast_df_maker(podsearch_df, csv_use$rss_url[i])),
            error= function(e){
              message(paste("ERROR OCCURRED FOR PODCAST URL", i, ":\n"), e)
            })
}

### Uncomment to see dataframe in console
# podsearch_df