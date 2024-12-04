import re

f = open("day4_input.txt", "r")
lines = [line.strip() for line in f]

def countXmas(line):
    count = 0
    for i in range(0, len(line) - 3):
        sub = line[i:i+4]
        if sub == "XMAS" or sub == "SAMX":
            count += 1
    return count

def countAllXmas(lines):
    return sum([countXmas(line) for line in lines])

def verticalLines(lines):
    result = ["" for i in range(0, len(lines[0]))]
    for row in range(0, len(lines)):
        for col in range(0, len(lines[row])):
            result[col] += lines[row][col]
    return result

def diag1Lines(lines):
    result = ["" for i in range(0, len(lines) + len(lines[0]))]
    for startRow in range(0, len(lines)):
        row = startRow
        col = 0
        while row < len(lines) and col < len(lines[row]):
            result[startRow] += lines[row][col]
            row += 1
            col += 1   

    for startCol in range(1, len(lines[0])):
        row = 0
        col = startCol
        while row < len(lines) and col < len(lines[row]):
            result[len(lines) + startCol - 1] += lines[row][col]
            row += 1
            col += 1  
    return result

def diag2Lines(lines):
    result = ["" for i in range(0, len(lines) + len(lines[0]))]
    for startRow in range(0, len(lines)):
        row = startRow
        col = 0
        while row >= 0 and col < len(lines[row]):
            result[startRow] += lines[row][col]
            row -= 1
            col += 1   

    for startCol in range(1, len(lines[0])):
        row = len(lines) - 1
        col = startCol
        while row >= 0 and col < len(lines[row]):
            result[len(lines) + startCol - 1] += lines[row][col]
            row -= 1
            col += 1  
    return result
            

count = 0
count += countAllXmas(lines)
count += countAllXmas(verticalLines(lines))
count += countAllXmas(diag1Lines(lines))
count += countAllXmas(diag2Lines(lines))

print(count)
