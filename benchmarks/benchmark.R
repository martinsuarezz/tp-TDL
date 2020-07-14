condition <- function(n){
    if (n %% 2 == 0)
        return (-n)
    return (n)
}

main <-function(){
    size = 100000
    numbers = seq(0, size - 1)

    print(sum(unlist(lapply(numbers, condition))))
}

main()
