dev:
    stata-mp "do developer"
render:
    quarto render site
[working-directory: 'cscripts']
test:
    stata-mp -b "do master"
