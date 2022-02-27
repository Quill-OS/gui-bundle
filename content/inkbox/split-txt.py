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
	# writecontent = writecontent.replace("\n", " ")
	writecontent = writecontent.replace("a\n", "a ")
	writecontent = writecontent.replace("b\n", "b ")
	writecontent = writecontent.replace("c\n", "c ")
	writecontent = writecontent.replace("d\n", "d ")
	writecontent = writecontent.replace("e\n", "e ")
	writecontent = writecontent.replace("f\n", "f ")
	writecontent = writecontent.replace("g\n", "g ")
	writecontent = writecontent.replace("h\n", "h ")
	writecontent = writecontent.replace("i\n", "i ")
	writecontent = writecontent.replace("j\n", "j ")
	writecontent = writecontent.replace("k\n", "k ")
	writecontent = writecontent.replace("l\n", "l ")
	writecontent = writecontent.replace("m\n", "m ")
	writecontent = writecontent.replace("n\n", "n ")
	writecontent = writecontent.replace("o\n", "o ")
	writecontent = writecontent.replace("p\n", "p ")
	writecontent = writecontent.replace("q\n", "q ")
	writecontent = writecontent.replace("r\n", "r ")
	writecontent = writecontent.replace("s\n", "s ")
	writecontent = writecontent.replace("t\n", "t ")
	writecontent = writecontent.replace("u\n", "u ")
	writecontent = writecontent.replace("v\n", "v ")
	writecontent = writecontent.replace("w\n", "w ")
	writecontent = writecontent.replace("x\n", "x ")
	writecontent = writecontent.replace("y\n", "y ")
	writecontent = writecontent.replace("z\n", "z ")
	writecontent = writecontent.replace(",\n", " ")
	writecontent = writecontent.replace("I\n", "I ")
	file_iterator.write(writecontent)
	file_iterator.close()
	i += 1
