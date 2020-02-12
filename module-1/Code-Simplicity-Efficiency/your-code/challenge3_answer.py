"""
You are presented with an integer number larger than 5. Your goal is to identify the longest side
possible in a right triangle whose sides are not longer than the number you are given.

For example, if you are given the number 15, there are 3 possibilities to compose right triangles:

1. [3, 4, 5]
2. [6, 8, 10]
3. [5, 12, 13]

The following function shows one way to solve the problem but the code is not ideal or efficient.
Refactor the code based on what you have learned about code simplicity and efficiency.
"""
"""
You are presented with an integer number larger than 5. Your goal is to identify the longest side
possible in a right triangle whose sides are not longer than the number you are given.

For example, if you are given the number 15, there are 3 possibilities to compose right triangles:

1. [3, 4, 5]
2. [6, 8, 10]
3. [5, 12, 13]

The following function shows one way to solve the problem but the code is not ideal or efficient.
Refactor the code based on what you have learned about code simplicity and efficiency.
"""

# def my_function(X):
#     solutions = []
#     for x in range(5, X):
#         for y in range(4, X):
#             for z in range(3, X):
#                 if (x*x==y*y+z*z):
#                     solutions.append([x, y, z])
#     m = 0
#     for solution in solutions:
#         if m < max(solution):
#             m = max(solution)
#     return m

# X = input("What is the maximal length of the triangle side? Enter a number: ")

# print("The longest side possible is " + str(my_function(int(X))))

def compute_side(num):
    max_combo = max([(a,b,c) for c in range(5, num+1) for b in range(4, num+1) for a in range(3, num+1) if (a**2 + b**2 == c**2)])
    
    return max_combo[2]

if __name__ in '__main__':
    x = int(input('What is the maximal length of the side of a right triangle? Enter a number: '))
    compute_side(x)
    print('The longest side possible given number %d is %d.' % (x, compute_side(x)))