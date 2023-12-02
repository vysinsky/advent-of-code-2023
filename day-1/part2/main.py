import re

numbers_dict = {
    "one": "o1e",
    "two": "t2o",
    "three": "th3ee",
    "four": "fo4r",
    "five": "fi5e",
    "six": "s6x",
    "seven": "se7en",
    "eight": "ei8ht",
    "nine": "n9ne",
}

match_word_numbers_regex = re.compile("|".join(numbers_dict.keys()))
match_numbers_regex = re.compile(r"\d")


def process_line(line):
    # Doing it twice to be able to replace those words sharing letters. Not as robust as I would like but result was correct
    res = match_word_numbers_regex.sub(lambda match: numbers_dict[match.string[match.start():match.end()]], line)
    return match_word_numbers_regex.sub(lambda match: numbers_dict[match.string[match.start():match.end()]], res)


def main():
    total = 0

    with open("input.txt", "r") as file:
        lines = file.readlines()

        for line in lines:
            line = process_line(line)
            numbers = match_numbers_regex.findall(line)

            if numbers.__len__() > 1:
                linenum = numbers[0] + numbers[-1]
            else:
                linenum = numbers[0] + numbers[0]

            total += int(linenum)

    print(total)


main()
