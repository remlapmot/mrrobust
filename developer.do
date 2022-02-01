* Commands to run before developing
cap noi ado uninstall mrrobust

* And then probably make a new git branch

* When testing code remember to `discard` (remove program from memory) before rerunning test code

* For myprog.ado there should be a cscript myprog.do

* run after having merged the new branch into master on GitHub
* net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
net install github, from("https://haghish.github.io/github/")
//gitget mrrobust
do dependency

* tsci used in the mregger cscript
net install tsci, from(https://raw.github.com/remlapmot/tsci/master)

// To run the certification scripts uncomment and run
// cd cscripts
// do master

// ado uninstall mrrobust

* Requirements to build md files of examples in _drafts
* Setup markstat
* as per https://data.princeton.edu/stata/markdown/gettingStarted
ssc install markstat
ssc install whereis
if c(os) == "Windows" local pandocpath "C:\Program Files\RStudio\bin\quarto\bin\pandoc.exe"
if c(os) == "MacOSX" local pandocpath "/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc"
whereis pandoc "`pandocpath'"
// or wherever your pandoc exe is
// The markstat-call-R-example also sets the path to the R executable

* Requirement to build helpfiles as html
ssc install log2html

// To run the examples for the website cd into an appropriate sub-directory of _drafts and run
// do render
