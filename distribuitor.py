#!/usr/bin/env python3

import sys

def gender_parser(gender_file):
    """
    Parses a gender csv file and returns a set with female IDs 
    """
    gender_handle = open(gender_file, 'r')
    f_list = []
    gender_handle.readline()  # Skip header
    for lines in gender_handle:
        lines = lines.strip().split("\t")
        if lines[1] == "female":
             f_list.append('"' + lines[0] + '"')
    gender_handle.close()
    f_set = set(f_list)

    return f_set


def dist_maker(f_set, deme_relatedness_file):
    """
    Parses a deme_relatedness file and prints only both gender pairs
    """
    deme_handle = open(deme_relatedness_file, 'r')
    print(deme_handle.readline())  # Print handle
    for lines in deme_handle:
        data = lines.split()
        if (data[2] in f_set and data[3] in f_set) or (data[2] not in f_set and data[3] not in f_set):
            pass
        else:
            print(lines.strip())
    
    deme_handle.close()


if __name__ == "__main__":
    female_set = gender_parser(sys.argv[1])
    dist_maker(female_set, sys.argv[2])
