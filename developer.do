* Commands to run before developing
cap noi ado uninstall mrrobust

* And then probably make a new git branch

* When testing code remember to `discard` (remove program from memory) before rerunning test code

* For myprog.ado there should be a cscript myprog.do

* run after having merged the new branch into master on GitHub
* net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
net install github, from("https://haghish.github.io/github/")
gitget mrrobust

cd cscripts
do master

* Requirements to build md files of examples in _drafts
* Setup markstat
* as per https://data.princeton.edu/stata/markdown/gettingStarted
ssc install markstat
ssc install whereis
whereis pandoc "C:\Program Files\RStudio\bin\pandoc\pandoc.exe" // Windows
// whereis pandoc "/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc" // macOS
// or wherever your pandoc exe is

* ado uninstall mrrobust

* Requirement to build helpfiles as html
ssc install log2html
