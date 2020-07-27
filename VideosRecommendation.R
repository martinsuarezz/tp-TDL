#Importamos libreria a usar
library(recommenderlab)
library("data.table")

#----------Funcion main------------------------------------------------
main <- function(){
  setwd("/users/Nacho/Desktop/facultad/movie_data")
  lecturaArchivos("movies.csv","ratings.csv")
  #pidoInput()
  programa()
}
#----------------------------------------------------------------------

#----------Funcion lectura archivos------------------------------------
lecturaArchivos <- function(movieFile,ratingFile){
  # Leo los archivos
  movie_data <- read.csv("movies.csv",stringsAsFactors=FALSE)
  rating_data <- read.csv("ratings.csv")
}

#----------Funcion pide input y rating de 10 peliculas al usuario.-----
pidoInput <- function(){
  #Obtengo el rating de 10 peliculas del usuario.
  newUserID <- tail(rating_data$userId,1) + 1
  
  contador <- 0
  
  while (contador < 10) {
    randomMovieId <- sample(1:10329,1)
    print(movie_data$title[randomMovieId])
    my.movieWatched <- readline(prompt="Viste la pelicula ? [1: Si, 2: No]: ")
    my.movieWatched <- suppressWarnings(as.integer(my.movieWatched))
    if(my.movieWatched == 1){
      contador = contador + 1
      my.ratingMovie <- readline(prompt="Puntea la pelicula 1-5: ")
      my.ratingMovie <- as.integer(my.ratingMovie)
      rating_data <- rbind(rating_data, list(newUserID, randomMovieId, my.ratingMovie, 0))
    }
  }
  
}

#----------Funciones que procesa informacion y recomienda las peliculas
programa <- function(){
  
  #Proceso informacion de los archivos.
  procesadoInformacion()
  
  #Creamos nuestro Sistema de filtrado colaborativo.
  sampled_data<- sample(x = c(TRUE, FALSE),size = nrow(movie_ratings),replace = TRUE,prob = c(0.8, 0.2))
  training_data <- movie_ratings[!sampled_data, ]
  testing_data <- movie_ratings[sampled_data, ]
  
  #Obtiene las 30 peliculas mas parecidas.
  recommendation_model <- Recommender(data = training_data,method = "IBCF",parameter = list(k = 30))
  
  #Cantidad de peliculas a recomendar
  top_recommendations <- 10
  
  user <- dim(testing_data)[1] - 1
  
  #Recomendaciones para el usuario elegido.
  predicted_recommendations <- predict(object = recommendation_model,newdata = testing_data,n = top_recommendations)
  userSelected <- predicted_recommendations@items[[user]]
  moviesUserSelected <- predicted_recommendations@itemLabels[userSelected]
  moviesUserSelectedAux <- moviesUserSelected
  
  for (index in 1:10){
    moviesUserSelectedAux[index] <- as.character(subset(movie_data,movie_data$movieId == moviesUserSelected[index])$title)
  }
  
  print(moviesUserSelectedAux)
  
}

procesadoInformacion <- function(){
  
  #Transformamos los rating a matriz
  ratingMatrix <- dcast(rating_data,userId~movieId, value.var = "rating", na.rm=FALSE)
  
  #Elimino el userId
  ratingMatrix <- as.matrix(ratingMatrix[,-1])
  
  # Transformo la matriz para poder usarla con recommenderlab
  ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
  
  movie_ratings <- ratingMatrix[rowCounts(ratingMatrix) > 10,colCounts(ratingMatrix) > 10]
  image(movie_ratings[1:10,1:10])
}

#----------------------------------------------------------------------
main()
