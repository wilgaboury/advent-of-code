import ast

check = set([ast.literal_eval(x) for x in open("day6_check.txt").readlines()])
actual = set([ast.literal_eval(x) for x in open("day6_check_actual.txt").readlines()])

print(check.difference(actual))