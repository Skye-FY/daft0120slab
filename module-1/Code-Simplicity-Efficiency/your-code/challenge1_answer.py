"""
This is a dumb calculator that can add and subtract whole numbers from zero to five.
When you run the code, you are prompted to enter two numbers (in the form of English
word instead of number) and the operator sign (also in the form of English word).
The code will perform the calculation and give the result if your input is what it
expects.

The code is very long and messy. Refactor it according to what you have learned about
code simplicity and efficiency.
"""

#constrain at input to allow only integer input

def welcome():
    print('\nWelcome to this calculator!\nIt can add and subtract whole numbers from zero to five.\n')
    
def num1():
    num = {
        'zero':0,
        'one':1,
        'two':2,
        'three':3,
        'four':4,
        'five':5,
          }
    flag = False
    while flag == False:
        x = input('Please choose your first number (zero to five):')
        if type(x) == int:
            if x not in num.values():
                print('Invalid input. Please re-enter.')
            else:
                flag = True
                n1_d = x
                for k, v in num.items():
                    if x == v:
                        n1_s = k
        elif type(x) == str:
            if x.lower() not in num.keys():
                print('Invalid input. Please re-enter.')   
        else:
            n1_s = x.capitalize()
            n1_d = num[x]
    flag = True
    return n1_s, n1_d
        

def operator():
    opr = {
        'plus': '+',
        'minus': '-',
         }
    flag = False
    x = str(input('What do you want to do? Plus or minus:\n'))
    while flag == False:
        if x.lower() not in opr.keys():
                print('Invalid input. Please re-enter.')   
        else:
            flag = True
            op = opr[x]
            op_s = x.lower()
    return op_s, op
     
    
def num2():
    num = {
        'zero':0,
        'one':1,
        'two':2,
        'three':3,
        'four':4,
        'five':5,
          }
    flag = False
    x = input('Please choose your second number (zero to five):\n')
    while flag == False:
        if type(x) == int:
            if x not in num.values():
                print('Invalid input. Please re-enter.')
            else:
                flag = True
                n2_d = x
                for k, v in num.items():
                    if x == v:
                        n2_s = k
        elif type(x) == str:
            if x.lower() not in num.keys():
                print('Invalid input. Please re-enter.')
                
            else:
                flag = True
                n2_s = x.lower()
                n2_d = num[x]
    return n2_s, n2_d

def cal(n1_s, n1_d, op_s, op, n2_s, n2_d):
    resultpool = {
        'negative five': -5,
        'negative four': -4,
        'negative three': -3,
        'negative two': -2,
        'negative one': -1,
        'zero': 0,
        'one':1,
        'two':2,
        'three':3,
        'four':4,
        'five':5,
        'six': 6,
        'seven':7,
        'eight': 8,
        'nine': 9,
        'ten':10,
    }
     
    if op == '+':
        output = sum(n1_d, n2_d)
        for k, v in resultpool.items():
            if output == v:
                output = k.lower()
        result = '%s %s %s equals %s.' % (n1_s, op_s, n2_s, output)
    else:
        output = (n1_d - n2_d)
        for k, v in resultpool.items():
            if output == v:
                output = k.lower()
        result = '%s %s %s equals %s' % (n1_s, op_s, n2_s, output)
    return print(result)
    
def endGame():
    print("Thanks for using this calculator, goodbye :)")
    
if __name__ == '__main__':
    welcome()
    n1_s, n1_d = num1()
    op_s, op = operator
    n2_s, n2_d = num2()
    result = cal(n1_s, n1_d, op_s, op, n2_s, n2_d)
    endGame()
