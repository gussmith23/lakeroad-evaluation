all: init resources.pdf resources-plot.pdf

resources.pdf: resources.tex generated/resources-body.tex
	pdflatex resources.tex && \
    mv resources.pdf generated && \
    rm resources.log resources.out resources.aux

generated/resources-body.tex: tables.R identifier-map.csv
	Rscript tables.R results/gathered_data generated identifier-map.csv

resources-plot.pdf: plots.R identifier-map.csv resource-map.csv
	Rscript plots.R results/gathered_data generated identifier-map.csv resource-map.csv

init:
	mkdir -p generated

clean:
	rm -rf generated
