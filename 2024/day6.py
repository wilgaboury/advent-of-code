table = open("day6_input.txt", "r").readlines()

direction = 0
gaurd = None

for row in range(len(table)):
    for col in range(len(table[0])):
        if table[row][col] == "^":
            gaurd = (row, col)
            break
    if gaurd is not None:
        break

def nextDirPos():
    global direction
    match direction:
        case 0:
            return (gaurd[0]-1, gaurd[1])
        case 1:
            return (gaurd[0], gaurd[1]+1)
        case 2:
            return (gaurd[0]+1, gaurd[1])
        case 3:
            return (gaurd[0], gaurd[1]-1)

def nextGaurdPos():
    global direction
    nextPos = None
    while nextPos is None:
        nextPos = nextDirPos()
        if table[nextPos[0]][nextPos[1]] == "#":
            direction = (direction + 1) % 4
            nextPos = None
    return nextPos

def inBounds(pos):
    return pos[0] >= 0 and pos[0] < len(table) and pos[1] >= 0 and pos[1] < len(table[0])

visited = set()
while inBounds(gaurd):
    visited.add(gaurd)
    gaurd = nextGaurdPos()

print(len(visited))


def checkForLoop(row, col, height, width):
    count = 0
    if table[row][col+1] == "#":
        count += 1
    if table[row+1][col + width] == "#":
        count += 1
    if table[row+height][col+width-1] == "#":
        count += 1
    if table[row+height-1][col] == "#":
        count += 1
    return count == 3

count = 0
for row in range(len(table)-2):
    for col in range(len(table[0])-2):
        for height in range(2, (len(table[0])-1)-row):
            for width in range(2, (len(table)-1)-col):
                print(row, col, height, width)
                if checkForLoop(row, col, height, width):
                    count += 1

print(count)
