* Commands to run before developing
cap noi ado uninstall mrrobust

* And then probably make a new git branch

* When testing code remember to `discard` (reload program into memory) before rerunning test code

* For myprog.ado there should be a cscript myprog.do

* run after having merged the new branch into master on GitHub
net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace

cd cscripts
do master
