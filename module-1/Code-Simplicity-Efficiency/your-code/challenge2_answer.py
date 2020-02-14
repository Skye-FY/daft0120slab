# def randomStringGenerator(max_len):
#     import string
#     alpha = list(string.ascii_lowercase)
#     nums = [str(i) for i in list(range(10))]
#     pool = alpha + nums
#     strlens = 0
#     _string = str()
#     while strlens <max_len:
#         import random
#         _string += random.choice(pool)
#         strlens += 1
#     return _string

# def batchStringGenerator(str_cnt, min_len, max_len):
#     str_batch = []
#     while len(str_batch) < len(range(str_cnt)):
#         strlen = None
#         if min_len < max_len:
#             import random
#             strlen = random.choice(range(min_len, max_len))
#         elif max_len == min_len:
#             strlen = min_len
#         else:
#             print('Invalid input.\nTry again.')
#             break
#         str_batch.append(randomStringGenerator(strlen))            
#     return str_batch

# if __name__ == '__main__':
#     _min_len = int(input('Enter minimum string length: '))
#     _max_len = int(input('Enter maximum string length: '))
#     _str_cnt = int(input('How many random strings to generate? '))
#     batchStringGenerator(_str_cnt, _min_len, _max_len)

import string
import random


def randomStringGenerator(max_len):
    alpha = list(string.ascii_lowercase)
    nums = [str(i) for i in list(range(10))]
    pool = alpha + nums
    _string = str()
    while len(_string) <max_len:
        _string += random.choice(pool)
    return _string

def batchStringGenerator(str_cnt, min_len, max_len):
    str_batch = []
    while len(str_batch) < len(range(str_cnt)):
        if min_len < max_len:
            strlen = random.choice(range(min_len, max_len))
        elif max_len == min_len:
            strlen = min_len
        else:
            print('Invalid input.\nTry again.')
            break
        str_batch.append(randomStringGenerator(strlen))            
    return str_batch

if __name__ == '__main__':
    _min_len = int(input('Enter minimum string length: '))
    _max_len = int(input('Enter maximum string length: '))
    _str_cnt = int(input('How many random strings to generate? '))
    batchStringGenerator(_str_cnt, _min_len, _max_len)
