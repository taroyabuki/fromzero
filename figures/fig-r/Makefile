SRC=$(wildcard *.R)

PDF=$(SRC:.R=.pdf)

all: $(PDF)

.SUFFIXES: .pdf .R

.R.pdf:
	if Rscript $<; then\
		if [ -f /usr/bin/pdfcrop ]; then\
			pdfcrop $@;\
			rm $@;\
			mv $(basename $@)-crop.pdf $@;\
	  	fi;\
	else\
		rm -f $@;\
		exit 1;\
	fi

clean:
	rm -f *.pdf *.log
