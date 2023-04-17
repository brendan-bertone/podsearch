# Podsearch

## Created by Roberto Balderas, Brendan Bertone, Sydney Brandt, Jackie Ganem
## Mentor: Meaghan Wetherell

## Overview
For the ISTA 498 Capstone at the University of Arizona, we set out to create an application that would transform the way of discovering new podcasts. The way we looked to accomplish this was to create an interactive application similar to dating websites such as Tinder, Bumble, and Hinge where the user would have podcast suggested to them based off the given variables and then based on the description and other information about the podcast they could choose to listen to the podcast or find their next match. 

Next, we will lay out the process we took to create this application and how it is running. 

## Design Overview
For this project we wanted to create a design that was fun and playful, much like many startups, the design aims to cater to a younger audience but is still useful to all ages. The color choice is the most evident of this aesthetic choice since the primary color of the website is a bright, energetic, and galactic purple. The zodiac color palette is also saturated with energetic colors that make the viewer want to view them all. The logo design of PodSearch is simple and iconic. The logo is made up of two chat bubbles, they both are meant to represent the letters “P” and “S.” The letter “P” consists of a microphone logo in order to symbolize the microphones used in creating podcasts and is unanimous with the idea of a podcast. The “S” is more representative of the letter “S,” just shaped in the way of a chat bubble. The designs for each zodiac sign are based on the corresponding zodiac constellations. The overall aesthetic is space themed which adds to the idea of exploration, much like how users are meant to search for their ideal podcast.

![image](https://user-images.githubusercontent.com/86931268/232614887-13ef977f-95e3-486f-aa15-e817e4b81586.png)
![image](https://user-images.githubusercontent.com/86931268/232614910-6c602d7f-c723-45d4-9309-47eb1cbe4834.png)
![image](https://user-images.githubusercontent.com/86931268/232614925-c6c3df31-a47a-44d4-aad3-7369a7ceef2a.png)
![image](https://user-images.githubusercontent.com/86931268/232614930-48e320cc-9f71-4245-8f5e-636b5c4322c1.png)

## Kaggle Data Set
One of the most important variables that we wanted to implement into our application was podcasts that had categories and reviews. For those reasons we decided to use this kaggle dataset which had millions of podcasts with both of those variables. From this data, we would choose our podcasts that we wanted to include in our application. It is also updated monthly to ensure that it has the most up-to-date information. 

Link: https://www.kaggle.com/datasets/thoughtvector/podcastreviews

For the application, you need to download the JSON Files for the reviews, categories, and podcasts. 
![image](https://user-images.githubusercontent.com/86931268/232164130-01b38c58-6d35-4989-9942-9d4f1a768951.png)
![image](https://user-images.githubusercontent.com/86931268/232164039-d7244d35-3504-434e-afc2-3809784f94f3.png)

## Data Cleaning/Filtering
Once you have downloaded the JSON files the next step is to run the file called "kaggle podcast cleaning filtering script.R" in RStudio. The purpose of this file is to take the JSON files transform them into a data frame, filter the # of podcasts to the ones we want, combine the podcast, categories, and reviews into one table, and lastly create a CSV with all the titles of the podcasts that we want to look for. 

We began by filtering the data to only include podcasts that had all the relevant data. From there we began filtering the data based on average rating and the number of people contributing to the ratings. Due to time constraints and limitations in our searching abilities we decided to only include podcasts that had an average rating of 5 with at least 50 rating them. This left us with about 700 podcasts. Unfortunately we found with the data that were was no podcasts that had reviews that met our filtering requirements. If we were to expand this project or add more data in the future this would be a good place to start.

![image](https://user-images.githubusercontent.com/86931268/232615005-5d9f74e5-a8f6-476f-88bd-426d4a945e62.png)

The result of this code is to print out two CSV's the first which has all the kaggle data and the second which only has the titles and podcast_id. 

Kaggle_all.csv 
![image](https://user-images.githubusercontent.com/86931268/232615032-8c128add-b220-4c4a-a0f5-1375307f7066.png)

podcast_id_titles.csv  
![image](https://user-images.githubusercontent.com/86931268/232615056-5afc3d7c-e186-495f-87e9-c85083df7dca.png)

##  Web Scrapper: Getting RSS Links
The purpose of this web scraper is to get all the RSS links for the podcasts from the Kaggle data. An RSS link is something that every podcast has which is usually an html/xml page that contains basic information about the podcast. We will use the links to gather more information about the podcasts such as the number of episodes, descriptions, whether it's explicit, etc… 

This web scrapper will simply get the links for each RSS feed for the individual podcasts. The webscrapper is called "Capstone_Webscrapper_RSS_Links.ipynb" and is run through Google Collab using pyhton.
  
The web scraper has 3 main parts. The first part is where it uploads the podcast_id_titles.csv and transforms it into a dataframe. From there it will create a list of all the titles that can be used to search for the podcast. 

Part 2 of the script is where you can use either the Google Method or Duck Duck Go method to use the titles to search for the podcast addict link for the specific podcast. We used the Google Method for the capstone because it ultimately proved to be more reliable and could do more links at a time. Google allowed us to do about 45 podcasts per a time where Duck Duck GO limited us to 10-20. In the images you can see the process if we were to manually do it. 

Part 2 
![image](https://user-images.githubusercontent.com/86931268/232615122-520d346b-ac2a-4002-ac14-989af220936e.png)
![image](https://user-images.githubusercontent.com/86931268/232615144-ba5fff8e-0f8e-4abf-9dd3-c277c9fb3cd0.png)

The last part of the script uses the podcast addict link from part 2 and scrapes the podcastadditct site for the RSS link that is on the page. Podcast addicts also had limitations with scrapping. After doing about 100 requests it wouldn’t allow us to search again for an hour or 2. This is also an active site and is continuously changing or having downtime so throughout collecting our data we had to modify the script (If it doesn't work let us know and we can look at it). If we were to do it again we would look into other sites that possibly would have also had a database of RSS Links. The last piece of the web scrapper was to output a CSV that contained the links of all the RSS feeds for the podcasts.

Part 3
![image](https://user-images.githubusercontent.com/86931268/232615168-5e798676-b575-4526-9b77-a8b95fce78bf.png)

Outside of the script, there was a manual piece to this part of the project. Since we could only run about 40-50 podcasts at a time we would manually take the results of the RSS link web scapper and add the links to a copy of the podcast_id_titles.csv which was called Podcast_Titles_RSS_Links_MASTER.CSV. This CSV was an exact copy of the podcast_id_titles.csv except that it had an extra column that contained the RSS Links.

![image](https://user-images.githubusercontent.com/86931268/232615194-db6856d5-d043-4ac0-8ef5-187988e96108.png)

## Web Scraper: Collecting RSS Data

The second step in the webscraping is running an R script. This webscraper takes CSVs of collected RSS links from the previous step and uses the XML and xml2 packages. The script iterates through each podcast in a CSV, pulling values from particular nodes and from averaged data. From there, a new row of data would be appended to an empty dataframe, podsearch_df, where users could analyze it and double-check that the webscraping went well.

![image](https://user-images.githubusercontent.com/86931268/232615242-292bcb41-af3d-4222-9e95-fa3a1d221d6f.png)

Some difficulties we ran into at this step were that not all RSS feeds were not structured the same. Many had missing values or stored information under different node names. An error message in the iteration would alert us to rows that would not be completable, and looking over podsearch_df alerted us to any issues that made it past the scraper that required our attention.

From there, each podsearch_df was saved as a CSV, and towards the end of the webscraping task, the CSVs were combined to create the complete dataset of RSS data. This final script here also removed rows that were completely NAs, rows that were duplicate podcasts based on "title", and rows that had a value in "zodiac" that was not a zodiac.

## Merging The Datasets Kaggle and RSS Links/Data

To merge the Kaggle data and the collected RSS data, we created two R scripts. 

The first R Script called “merge kaggle rss links.R”  combines the Podcast_Titles_RSS_Links_MASTER.CSV with the kaggle_all.csv. This essentially takes the results of the first webscrapper and mergers it with the filtered kaggle data.  In the script, we cleaned and filtered the data to get rid of redundant columns and podcasts that didn’t have RSS links. This script gave us all the podcast information from kaggle and the rss links which would be used in the next script. The output of this was written to a CSV called podsearch_final.csv

![image](https://user-images.githubusercontent.com/86931268/232615277-63a2dbb3-c786-46cb-8943-f4fc09eb8bf1.png)

In the next script “merge kaggle rss data.r”. We read in the csv from the RSS Data collection and the podsearch_final.csv which has the RSS links and kaggle data from the first script and conduct a left-joined the Kaggle data to the RSS data with the index being "xml_link". We removed rows that had NAs for "categories", and the final dataset was exported as a CSV. The final column values of this dataset were: xml_link, title.x, description, show_link, number_episodes, explicit, birthday, zodiac, podcast_id, average_rating, ratings_count, categories.

## R-Shiny Dating Dashboard
The R-Shiny dating dashboard, which is being hosted on the React website, is comprised of a "filters" column on the left and the reactive datatable and 'dating app' tabs on the right.

At the top of this app document, some final data mutations are made to the complete PodSearch dataset: the "birthday" timestamp is modified to not be as long, some variables are changed to be capitalized, individual categories are extracted from "categories", and HTML tags that were in "description" were removed. HTML style choices were also applied here.

Beneath that, the UI and server were defined to create the "dating dashboard"; users are encouraged to pick options within each filter to receive a randomized "match" from the filtered dataset. In the table tab, they can modify the filters however they see fit to gather all of their "matches" at once.

Repository Link: https://github.com/rbalderas1/PodSearchOne

## R-Shiny Visualizations Dashboard
The visualizations dashboard is meant to visualize all of the podcast data that has been scraped and cleaned. This dashboard is meant to help inform users on what the data the dashboard consists of, which then gives the user an idea of what searches they can do. The dashboard consists of bar plots, line plots, and word clouds. The two main filters with the dashboard are the zodiac and the genre/category filters.

Repository Link: https://github.com/rbalderas1/podsearch_visualiztions_v2

## React Website
The React website is meant to host the dating dashboard and visualizations dashboard in one place to make it easier for people to access our project. We went through the process of designing the color scheme, logos, and look of the website before we went through the process of building the website. The website was then created using React and pushed to an AWS server.

Link: https://main.d3h1hpalkc9yzt.amplifyapp.com/

![image](https://user-images.githubusercontent.com/86931268/232615355-b44805ec-862c-491a-8812-d249d51981a7.png)
![image](https://user-images.githubusercontent.com/86931268/232615366-2e843873-2c85-46d0-a634-c500ed055998.png)

 

 
