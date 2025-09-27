dev:
    stata-mp "do developer"
render:
    quarto render site
    rm -r docs/*
    mv site/_site/* docs/
[working-directory: 'cscripts']
test:
    stata-mp -b "do master"
