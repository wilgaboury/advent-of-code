reports = []
f = open("day2_input.txt", "r")
for line in f:
    reports.append([int(x) for x in line.split(" ")])

def isSafe(report):
    if len(report) <= 1:
        return True

    if report[0] == report[1]:
        return False

    increasing = report[0] < report[1]

    for i in range(1, len(report)):
        diff = report[i] - report[i - 1]
        if abs(diff) < 1 or abs(diff) > 3 or (diff < 0 if increasing else diff > 0):
            return False

    return True

count = 0
for report in reports:
    if isSafe(report):
        count += 1

print(count)

def isSafeDampenDumb(report):
    if isSafe(report):
        return True
    else:
        for i in range(0, len(report)):
            copy = report.copy()
            del copy[i]
            if isSafe(copy):
                return True
        return False

count = 0
for report in reports:
    if isSafeDampenDumb(report):
        count += 1

print(count)
