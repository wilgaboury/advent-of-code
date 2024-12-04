f = open("day4_input.txt", "r")
lines = [line.strip() for line in f]

count = 0
for row in range(0, len(lines) - 2):
    for col in range(0, len(lines[row]) - 2):
        diag1 = lines[row][col] + lines[row + 1][col + 1] + lines[row + 2][col + 2]
        diag2 = lines[row][col + 2] + lines[row + 1][col + 1] + lines[row + 2][col]
        if (diag1 == "MAS" or diag1 == "SAM") and (diag2 == "MAS" or diag2 == "SAM"):
            count += 1

print(count)