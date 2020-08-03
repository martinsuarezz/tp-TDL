library(shiny)
library("recommenderlab")
library("data.table")
library("stringi")
library(shinythemes)

movie_data <- read.csv("new_movies.csv", stringsAsFactors=FALSE)
#movie_data$title <- stri_trans_general(movie_data$title, "ASCII; [\u007F-\u00FF] Remove")

rating_data <- read.csv("new_ratings.csv")

temp = merge(movie_data, rating_data, by.x="movieId", by.y="movieId", all.y=TRUE)
temp = temp[!duplicated(temp$movieId), ]
temp$rating <- NULL
temp$userId <- NULL
temp <- temp[complete.cases(temp), ]
temp$trueId = c(1:dim(temp)[1])
movie_data <- temp[c("trueId", "title")]

rating_data <- merge(rating_data, temp, by.x="movieId", by.y="movieId", all.x=TRUE)
rating_data$movieId <- NULL
rating_data$title <- NULL
rating_data <- rating_data[,c(1,3,2)]
rating_data <- rating_data[complete.cases(rating_data), ]

movie_list <- movie_data$trueId
names(movie_list) <- movie_data$title

ratingMatrix <- as(rating_data, "realRatingMatrix")
newUserID <- tail(rating_data$userId, 1) + 1

recommender <- readRDS("ubcf.rds")

ui <- fluidPage(theme = shinytheme("united"),
    titlePanel("Recomendador de peliculas"),
    fluidRow(
        column(4,
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select1", label = h3("Pelicula 1"), 
                               choices = movie_list,
                               selected = 1)),
                   sliderInput("rating1",
                               label = "",
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               div(style="height: 190px;",
                   div(style="height: 100px;",
                   selectInput("select2", label = h3("Pelicula 2"), 
                               choices = movie_list,
                               selected = 2)),
                   sliderInput("rating2",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                   selectInput("select3", label = h3("Pelicula 3"), 
                               choices = movie_list,
                               selected = 3)),
                   sliderInput("rating3",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                   selectInput("select4", label = h3("Pelicula 4"), 
                               choices = movie_list,
                               selected = 4)),
                   sliderInput("rating4",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                   selectInput("select5", label = h3("Pelicula 5"), 
                               choices = movie_list,
                               selected = 5)),
                   sliderInput("rating5",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5))),
        column(4,
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select6", label = h3("Pelicula 6"), 
                                   choices = movie_list,
                                   selected = 6)),
                   sliderInput("rating6",
                               label = "",
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select7", label = h3("Pelicula 7"), 
                                   choices = movie_list,
                                   selected = 7)),
                   sliderInput("rating7",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select8", label = h3("Pelicula 8"), 
                                   choices = movie_list,
                                   selected = 8)),
                   sliderInput("rating8",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select9", label = h3("Pelicula 9"), 
                                   choices = movie_list,
                                   selected = 9)),
                   sliderInput("rating9",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5)),
               
               div(style="height: 190px;",
                   div(style="height: 100px;",
                       selectInput("select10", label = h3("Pelicula 10"), 
                                   choices = movie_list,
                                   selected = 10)),
                   sliderInput("rating10",
                               label = h4("Tu rating:"),
                               min = 1,
                               max = 5,
                               value = 3,
                               step = 0.5))),
        column(4,
               h3("Recomendamos ver..."),
               h4(tableOutput("table")))
    )
)


server <- function(input, output) {

    output$table <- renderTable({
        new_ratings <- ratingMatrix[1]
        new_ratings[1] <- 0

        for(i in 1:10)
            new_ratings[1, as.numeric(input[[paste0("select", i)]])] <- input[[paste0("rating", i)]]
        

        pre <- as(predict(recommender, new_ratings, n = 10), "list")
        predictionsId <- as.numeric(unlist(pre, use.names=FALSE))
        
        predictionsNames <- movie_data[movie_data$trueId %in% predictionsId,]$title
        predictionsNames
    },
    colnames = FALSE)
}

shinyApp(ui = ui, server = server)
