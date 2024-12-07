table = [list(x) for x in open("day6_input.txt", "r").readlines()]
f = open("day6_check.txt", "w")

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
    while True:
        testNext = moveState(state)
        if not inBounds(testNext):
            return None
        elif table[testNext[1]][testNext[2]] != '#':
            return testNext
        else:
            state = ((state[0]+1)%4, state[1], state[2])

def inBounds(state):
    global table
    return state[1] >= 0 and state[1] < len(table) and state[2] >= 0 and state[2] < len(table[0])

def isLoop(state):
    visited = set()
    while True:
        visited.add(state)
        testNext = nextState(state)        
        if testNext is None:
            return False
        elif testNext in visited:
            return True
        state = testNext
        
state = (0, gaurd[0], gaurd[1])
visited = set()
obs = set()
while state is not None:
    visited.add((state[1], state[2]))
    testNext = nextState(state)
    if testNext is not None and (testNext[1], testNext[2]) not in obs:
        table[testNext[1]][testNext[2]] = '#'
        if isLoop(state):
            f.write(str((testNext[1], testNext[2])) + "\n")
            obs.add((testNext[1], testNext[2]))
        table[testNext[1]][testNext[2]] = '.'
    state = testNext
        
print(len(visited))
print(len(obs))
