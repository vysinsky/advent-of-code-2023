import re

total = 0

with open("input.txt", "r") as file:
    lines = file.readlines()

    for line in lines:
        numbers = re.findall(r'\d', line)
        if numbers.__len__() > 1:
            linenum = numbers[0] + numbers[-1]
        else:
            linenum = numbers[0] + numbers[0]
            
        total += int(linenum)

print(total)
