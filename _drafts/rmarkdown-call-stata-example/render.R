rmarkdown::render('rmarkdown-call-stata-example.Rmd', encoding = 'UTF-8')
file.copy('rmarkdown-call-stata-example.md', '../../docs/', overwrite = TRUE)
