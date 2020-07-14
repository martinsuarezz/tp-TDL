#include <vector>
#include <iostream>

int main(){
    size_t vectorSize = 100000;
    std::vector<int> numbers(vectorSize);
    
    for (int i = 0; i < vectorSize; i++){
        numbers[i] = i;
    }

    for (int i = 0; i < vectorSize; i++){
        if (numbers[i] % 2 == 0)
            numbers[i] *= -1;
    }

    int accumulator = 0;
    for (int i = 0; i < vectorSize; i++){
        accumulator += numbers[i];
    }

    std::cout << accumulator << std::endl;
    return 1;
}
