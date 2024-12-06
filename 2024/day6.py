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
loopTestPos = set()
while inBounds(gaurd):
    visited.add(gaurd)
    if direction == 0 and gaurd[0] > 0 and table[gaurd[0]-1][gaurd[1]] == "#":
        loopTestPos.add(gaurd)
    gaurd = nextGaurdPos()

print(len(visited))

print(loopTestPos)

def getLoopCount(row, col, height, width):
    count = 0
    if table[row-1][col] == "#":
        count += 1
    if table[row][col + width] == "#":
        count += 1
    if table[row+height][col+width-1] == "#":
        count += 1
    if table[row+height-1][col-1] == "#":
        count += 1
    return count

count = 0
for row, col in loopTestPos:
    # limitHeight = False
    # limitWidth = None
    for height in range(2, (len(table[0])-1)-row):
        # for width in ([limitWidth] if limitWidth is not None else range(2, (len(table)-1)-col)):
        for width in range(2, (len(table)-1)-col):
            loopCount = getLoopCount(row, col, height, width)

            if loopCount == 4:
                limitHeight = True
                break

            if loopCount == 3:
                count += 1

                # if table[row][col + width] != "#":
                #     limitHeight = True
                # if table[row+height][col+width-1] != "#":
                #     limitWidth = width
                
        # if limitHeight:
        #     break

print(count)
