#Importamos libreria a usar
library(recommenderlab)

#----------Funcion main------------------------------------------------
main <- function(){
  setwd("/users/Nacho/Desktop/facultad/movie_data")
  lecturaArchivos("movies.csv","ratings.csv")
  #pidoInput()
  programa()
}

main()
#----------------------------------------------------------------------

#----------Funcion lectura archivos------------------------------------
lecturaArchivos <- function(movieFile,ratingFile){
  # Leo los archivos
  movie_data <- read.csv(movieFile,stringsAsFactors=FALSE)
  rating_data <- read.csv(ratingFile)
}

#----------Funcion pide input y rating de 10 peliculas al usuario.-----
pidoInput <- function(userID){
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
  training_data <- movie_ratings[sampled_data, ]
  testing_data <- movie_ratings[!sampled_data, ]
  
  
  #Obtiene las 30 peliculas mas parecidas.
  recommendation_model <- Recommender(data = training_data,method = "IBCF",parameter = list(k = 30))
  
  #Cantidad de peliculas a recomendar
  top_recommendations <- 10
  
  #Recomendaciones para el usuario elegido.
  predicted_recommendations <- predict(object = recommendation_model,newdata = testing_data,n = top_recommendations)
  userSelected <- predicted_recommendations@items[[tail(rating_data$userId,1)]]
  moviesUserSelected <- predicted_recommendations@itemLabels[userSelected]
  moviesUserSelectedAux <- moviesUserSelected
  
  for (index in 1:10){
    moviesUserSelectedAux[index] <- as.character(subset(movie_data,movie_data$movieId == moviesUserSelected[index])$title)
  }
  
  print(moviesUserSelectedAux)
}

procesadoInformacion <- function(){
  #Proceso la informacion de los archivos.
  #Genero una matriz en donde muestra los genereos y las peliculas que tienen el determinado genero.
  movie_genre <- as.data.frame(movie_data$genres, stringsAsFactors=FALSE)
  movie_genre2 <- as.data.frame(tstrsplit(movie_genre[,1], "[|]"), type.convert=TRUE)
  colnames(movie_genre2) <- c(1:10)
  
  list_genre <- c("Action", "Adventure", "Animation", "Children", 
                  "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                  "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                  "Sci-Fi", "Thriller", "War", "Western")
  
  genre_matrix <- matrix(0,10330,18)
  genre_matrix[1,] <- list_genre
  colnames(genre_matrix) <- list_genre
  
  for (index in 1:nrow(movie_genre2)) {
    for (col in 1:ncol(movie_genre2)) {
      gen_col = which(genre_matrix[1,] == movie_genre2[index,col]) 
      genre_matrix[index+1,gen_col] <- 1
    }
  }
  
  genre_matrix2 <- as.data.frame(genre_matrix[-1,], stringsAsFactors=FALSE) 
  for (col in 1:ncol(genre_matrix2)) {
    genre_matrix2[,col] <- as.integer(genre_matrix2[,col])
  } 
  
  #Transformamos los rating a matriz
  ratingMatrix <- dcast(rating_data,userId~movieId, value.var = "rating", na.rm=FALSE)
  
  #Elimino el userId
  ratingMatrix <- as.matrix(ratingMatrix[,-1])
  
  # Transformo la matriz para poder usarla con recommenderlab
  ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
  
  movie_ratings <- ratingMatrix[rowCounts(ratingMatrix) > 50,colCounts(ratingMatrix) > 50]
  
}

#----------------------------------------------------------------------
