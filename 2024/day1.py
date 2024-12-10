import re

l1 = []
l2 = []
f = open("day1_input.txt", "r")
for line in f:
    search = re.search("^(\d+)   (\d+)$", line)
    l1.append(int(search.group(1)))
    l2.append(int(search.group(2)))

l1.sort()
l2.sort()

result = 0
for [i1, i2] in zip(l1, l2):
    result += abs(i1 - i2)

print("diff: " + str(result))

freq = {}
for n in l2:
    if n in freq:
        freq[n] += 1
    else:
        freq[n] = 1

sim = 0

for n in l1:
    if n in freq:
        sim += n * freq[n]

print("sim: " + str(sim))