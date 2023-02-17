capture log close
log using "markstat-call-R-example", smcl replace
//_1
* ssc install whereis
* ssc install markstat
//_2
if c(os) == "Windows" local rpath "C:\\Program Files\\R\\R-4.2.2\\bin\\x64\\R.exe"
else if c(os) == "Unix" local rpath "/usr/bin/R"
else local rpath "/usr/local/bin/R"
whereis R "`rpath'"
//_3
use dat, clear
ds, v(28)
di _N
//_4
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
//_5
mrforest beta_outcome se_outcome beta_exposure se_exposure, ivid(SNP) ///
xlabel(-3,-2,-1,0,1,2,3)
graph export ldl-chd-mrforest.svg, width(600) replace
//_6
mreggerplot beta_outcome se_outcome beta_exposure se_exposure
graph export ldl-chd-mreggerplot.svg, width(600) replace
//_7
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]
//_8
mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted
//_9
mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
//_^
log close
