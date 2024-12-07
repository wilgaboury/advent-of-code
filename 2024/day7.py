import itertools

lines = [line.split(": ") for line in open("day7_input.txt").readlines()]
numLines = [(int(line[0]), [int(x) for x in line[1].split(" ")]) for line in lines]
ops = [lambda x, y: x + y, lambda x, y: x * y, lambda x, y: int(str(x) + str(y))]

def allSumMults(nums):
    def apply(codes):
        result = nums[0]
        for i in range(len(codes)):
            result = ops[codes[i]](result, nums[i+1])
        return result
    return [apply(comb) for comb in itertools.product([0, 1, 2], repeat=len(nums)-1)]


result = 0
for num, nums in numLines:
    if num in allSumMults(nums):
        result += num

print(result)