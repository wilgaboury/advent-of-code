import re

f = open("day5_input.txt", "r")
lines = f.readlines()

rules = {}
updates = []

split = lines.index("\n")
for line in lines[0:split]:
    match = re.search("^(\d+)\|(\d+)$", line)
    p1 = int(match.group(1))
    p2 = int(match.group(2))
    if p1 not in rules:
        rules[p1] = set()
    rules[p1].add(p2)

for line in lines[split+1:]:
    updates.append([int(x) for x in line.strip().split(",")])

def isOrdered(update):
    for i in range(1, len(update)):
        if update[i-1] in rules[update[i]]:
            return False
    return True

result = 0
for update in updates:
    if isOrdered(update):
        result += update[len(update)//2]

print(result)