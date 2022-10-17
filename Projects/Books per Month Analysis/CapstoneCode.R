library(tidyverse)
library(fastDummies)

data <- read.csv('GoodReads_Data.csv')
data <- dummy_cols(data, select_columns = 'Genre')

ratings <- glm(Goal.Met.~My.Rating+Average.Rating+Number.of.Pages, data = data, family = "binomial")
summary(ratings)


genre <- glm(data$Goal.Met.~data$Genre_Classics+data$Genre_Fantasy+data$Genre_Fiction
             +data$`Genre_Graphic novel`+data$`Genre_Historical Fiction`
             +data$`Genre_Historical Romance`+data$Genre_Mystery+data$Genre_Nonfiction
             +data$Genre_Romance+data$`Genre_Young Adult`, family = 'binomial')
summary(genre)

cor(data$My.Rating, y = data$Goal.Met.)
cor(data$Average.Rating, y = data$Goal.Met.)
cor(data$Number.of.Pages, y = data$Goal.Met.)
cor(data$Year.Published, y = data$Goal.Met.)
cor(data$Original.Publication.Year, y = data$Goal.Met.)
cor(data$Genre_Classics, y = data$Goal.Met.)
cor(data$Genre_Fantasy, y = data$Goal.Met.)
cor(data$Genre_Fiction, y = data$Goal.Met.)
cor(data$`Genre_Graphic novel`, y = data$Goal.Met.)
cor(data$`Genre_Historical Fiction`, y = data$Goal.Met.)
cor(data$`Genre_Historical Romance`, y = data$Goal.Met.)
cor(data$Genre_Mystery, y = data$Goal.Met.)
cor(data$Genre_Nonfiction, y = data$Goal.Met.)
cor(data$Genre_Romance, y = data$Goal.Met.)
cor(data$`Genre_Young Adult`, y = data$Goal.Met.)