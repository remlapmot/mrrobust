* Test installation methods
* 2020-06-23

log using install.log, text replace

about

** net install

cap noi ado uninstall mrrobust

net desc mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/)

net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
mrdeps

** github package

cap noi ado uninstall mrrobust

net install github, from("https://haghish.github.io/github/")
gitget mrrobust

cap noi ado uninstall mrrobust

log close
