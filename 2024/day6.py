# table = [list(x) for x in open("day6_test_input.txt", "r").readlines()]
table = [list(x) for x in open("day6_input.txt", "r").readlines()]

gaurd = None
for row in range(len(table)):
    for col in range(len(table[0])):
        if table[row][col] == "^":
            gaurd = (row, col)
            break
    if gaurd is not None:
        break

def moveState(state):
    match state[0]:
        case 0:
            return (state[0], state[1]-1, state[2])
        case 1:
            return (state[0], state[1], state[2]+1)
        case 2:
            return (state[0], state[1]+1, state[2])
        case 3:
            return (state[0], state[1], state[2]-1)

def nextState(state):
    global table
    turns = 0
    while True:
        testNext = moveState(state)
        if not inBounds(testNext):
            return (None, turns)
        elif table[testNext[1]][testNext[2]] != '#':
            return (testNext, turns)
        else:
            turns += 1
            state = ((state[0]+1)%4, state[1], state[2])

def inBounds(state):
    global table
    return state[1] >= 0 and state[1] < len(table) and state[2] >= 0 and state[2] < len(table[0])

def isLoop(state):
    start = state
    turns = 0
    while True:
        testNext, newTurns = nextState(state)
        turns += newTurns
        
        if testNext is None:
            return False
        elif testNext == start:
            return True
        
        state = testNext
        

state = (0, gaurd[0], gaurd[1])
visited = set()
part2 = 0
itr = 0
while state is not None:
    print(itr)
    itr+=1
    visited.add((state[1], state[2]))
    testNext = nextState(state)[0]
    if testNext is not None:
        table[testNext[1]][testNext[2]] = '#'
        if isLoop(state):
            part2 += 1
        table[testNext[1]][testNext[2]] = '.'
    state = testNext
        
print("SOLTIONS")
print("part1", len(visited))
print("part2", part2)
