# OOP R
## S3
### Introduccion a S3 

S3 es el primer y mas simple paradigma orientado a objetos que tiene R. Un objeto en S3 es una tipo base que tiene un atributo clase.

Una parte fundamental de S3 son las funciones genericas, que utiliza diferentes implementaciones dependiendo de la clase que se le pasa como argumento. Lo unico que hace una funcion generica es definir una interfaz , y al invocarse, busca la implementacion adecuada para cada objeto. La implementacion especifica para una clase se llama metodo y es declarada como `nombre_de_funcion.nombre_de_clase(args)`.

### Clases

Como se menciono anteriormente, un objeto debe tener un atributo `class` para ser una instancia de una clase. Este atributo puede ser definido al crearse la estructura o luego, agregondole el atributo `class`.

### Funciones genericas y metodos

Una funcion generica principalmente lo que hace es llamar a un metodo utilizando `UseMethod()` que utiliza el nombre de la funcion generica y los argumentos pasados a la funcion. Para encontrar el metodo apropiado para cada clase, la funcion `UseMethod()` crea un vector con nombres de cada uno de los metodos e itera por cada posible metodo. Tambien se puede declarar una pseudo clase llamada `default` para crear un metodo default para objetos que no tengan un metodo declarado.


### Herencia

Un objeto puede tener varias clases, permitiendo compartir comportamientos a traves de la herencia. Si al llamarse una funcion generica no se encuentra el metodo de la primer clase, la funcion generica busca el metodo para la siguiente clase declarada en el objeto y asi sucesivamente. Ademas, un metodo puede usar la funcion `NextMethod()` para que la funcion generica salte al metodo de la clase siguiente declarada en el atributo `class` del objeto.


## R6

### Introduccion a R6

El paradigma de objetos de R6 es bastante parecido a cualquier otro paradigma de objetos utilizados en otros lenguajes OOP. A diferencia de S3, los metodos pertencen al objeto y no a genericos, y se llaman utilizando la notacion `objeto$metodo()`

Otro aspecto importante de R6 es que los objetos son mutables, al crearse se almacena una referencia a ellos.

### Clases y metodos

Para crear clases y definir sus metodos solo se utiliza la funcion `R6Class()`. El primer argumento de la funcion es el nombre de la clase,  el segundo argumento es una lista con todos los metodos publicos de esa clase y el tercer argumento es una lista con todos los metodos privados de la clase. Luego de usar la funcion `R6Class()` para crear una clase, se inicializa utilizando el metodo `new()`.

Para cambiar como se construye una clase, se puede declarar el metodo `initialize`, que cambia el comportamiento del metodo `new()`, el constructor de la clase.

### Herencia

Para que una clase herede de otra, se le debe pasar el argumento `inheritence` al declarar la clase con la funcion `R6Class()`. Al igual que otros lenguajes orientado a objetos, un metodo en clase hijo sobreescribe el metodo de la clase de la que hereda, pero utilizando `super$nombre_metodo` se puede llamar al metodo de la clase padre.

### Metodos publicos y privados

Metodos y propiedades publicas pueden ser llamadas dentro de la clase utilizando `self$metodo(args)` o en el caso de una propiedad `self$propiedad`. En cambio, los metodos y propiedades privadas solo pueden ser usadas dentro de la declaracion de la clase, utilizando `private.

### Propiedades activas

Las propiedades activas son metodos que se llaman utilizando la sintaxis de una propiedad. Cada propiedad activa acepta un argumento, si no se le pasa el argumento significa que se esta llamando la propiedad, en cambio, si se le pasa argumento, significa que se le esta asignando un valor a esta propiedad.


## S4

El paradigma S4 es muy parecido al paradigma S3 mencionado anteriormente con la diferencia de que usa distintas funciones especializadas para declarar clases, metodos y funciones genericas.

### Clases y Herencia

Para crear una clase, se utiliza la funcion `setClass()` usando el nombre de la clase como primer argumento y sus slots como segundo argumento. Un slot es un componente con nombre dentro del objeto (similar al concepto de propiedad de una clase). una vez creada la clase, se puede instanciar utilizando la funcion `new` pasandole el nombre de la clase y los valores para cada uno de los slots.

Otro argumento importante que se le puede pasar a `setClass()` es `contains`, utilizado para herencia. Este argumento especifica de que clase hereda slots y metodos.

### Funciones Genericas y Metodos

Al igual que en S3, una funcion generica lo unico que hace es encontrar el metodo correspondiende a utilizar dependiendo del objeto pasado como argumento. Para crear una funcion generica se utliza `setGeneric()` en el que se le pasa como argumentos el nombre de la funcion y como segundo argumento una funcion.

Los metodos se definen utilizando la funcion `setMethod()` en el que se pasa como primer argumento una funcion generica, como segundo argumento la clase a la que pertenece este metodo y finalmente como tercer argumento una funcion.

### Herencia y Metodos

S4 perimete herencia multiple, ademas de permitir usar distintos argumentos en un metodo para llamar a un meotod en especifica, agregando un mayor complejidad a como las funciones genericas seleccionan el metodo a usar.

En el caso de una herencia simple y solo con un metodo declarado para ese generico, la funcion generica primero busca si existe un metodo para la clase pasada y, si no lo encuentra, busca en su clase padre y asi sucesivamente hasta encontrar el metodo o quedarse sin clases y lanzar un error.

En el caso de una herencia multiple con solo un metodo de la clase declarado para ese generico, la logica sigue siendo la misma, pero en caso de que haya 2 metodos iguales declarados para dos clases padres distintas, se utliza el metodo mas cercano al objeto pasado. En caso de que ambas esten a la misma distancia del objeto (ejemplo, las dos clases son padres de la clase, por ende estan a la misma distancia) R levanta un warning y se ejecuta el metodo de la clase que venga primero alfabeticamente.

En el caso de una herencia multiple con varios metodos de esa clase declarados para ese generico, se utiliza la misma logica mencionada anteriormente para herencia multiple, nada mas que ademas de buscar si existe el metodo, busca las distintas combinaciones de argumentos que coinciden con los argumentos pasados, causando que sea mas facil crear ambiguedades.

