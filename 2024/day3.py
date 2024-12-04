import re

f = open('day3_input.txt', 'r')
content = f.read().replace('\n', '')

# comment out below line for part 1
content = re.sub("don't\(\).*?(do\(\)|$)", "", content)

result = 0
matches = re.finditer("mul\((\d{1,3}),(\d{1,3})\)", content)
for match in matches:
    result += int(match.group(1)) * int(match.group(2))

print(result) 