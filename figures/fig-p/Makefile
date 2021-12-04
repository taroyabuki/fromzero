SRC=$(wildcard *.py)

PDF=$(SRC:.py=.pdf)

all: $(PDF)

.SUFFIXES: .pdf .py

.py.pdf:
	if python3 $<; then\
		if [ -f /usr/bin/pdfcrop ]; then\
	   		pdfcrop $@;\
			rm $@;\
			mv $(basename $@)-crop.pdf $@;\
		fi;\
	else exit 1;\
	fi

clean:
	rm -f *.pdf *.log
