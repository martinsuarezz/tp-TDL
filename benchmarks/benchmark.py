import numpy as np

def func(n):
    if n % 2 == 0:
        return -n
    return n

def main():
    vector_size = 100000
    numbers = np.arange(vector_size)

    vfunc = np.vectorize(func)
    numbers = vfunc(numbers)

    print(numbers.sum())
    
main()
