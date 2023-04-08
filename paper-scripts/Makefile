resources.pdf: resources.tex generated/resources-body.tex
	pdflatex resources.tex

generated/resources-body.tex: tables.R identifier-map.csv
	Rscript tables.R results/gathered_data generated identifier-map.csv
