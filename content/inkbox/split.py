#!/usr/bin/python3

import os
import sys

os.chdir("/inkbox/book/split")
book = open("../book.txt", "r")
text = book.read()
book.close()

booklist = text.split(" ")
words_number = sys.argv[1]
words_number_int = int(words_number)
split_booklist = [booklist[x:x+words_number_int] for x in range(0, len(booklist),words_number_int)]
len_split_booklist = len(split_booklist)

i = 0

while i < len_split_booklist:
	print(i)
	istr = str(i)
	file_iterator = open(istr, "w")
	writecontent = " ".join(split_booklist[i])
	writecontent = writecontent.replace("\n\n\n\n\n\n\n\n", "\n")
	writecontent = writecontent.replace("\n\n\n\n\n\n\n", "\n")
	writecontent = writecontent.replace("\n\n\n\n\n\n", "\n")
	writecontent = writecontent.replace("\n\n\n\n\n", "\n")
	writecontent = writecontent.replace("\n\n\n\n", "\n")
	writecontent = writecontent.replace("\n\n\n", "\n")
	file_iterator.write(writecontent)
	file_iterator.close()
	i += 1
