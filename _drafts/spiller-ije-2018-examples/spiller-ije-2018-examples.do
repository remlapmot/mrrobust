capture log close
log using "spiller-ije-2018-examples", smcl replace
//_1
import delimited using BMI.csv, clear
//_2
mregger betaoutcome betaexposure [aw=1/(seoutcome^2)], ivw
//_3
mregger betaoutcome betaexposure [aw=1/(seoutcome^2)]
//_4
mreggerplot betaoutcome seoutcome betaexposure seexposure
qui gr export mreggerplot-bmi.svg, width(600) replace
//_5
mrmedian betaoutcome seoutcome betaexposure seexposure, ///
    weighted seed(300818)
//_6
mrmodalplot betaoutcome seoutcome betaexposure seexposure, ///
    lc(gs10 gs5 gs0) seed(300818)
qui gr export mrmodalplot-bmi.svg, width(600) replace
//_7
import delimited using Height.csv, clear
//_8
mregger betaoutcome betaexposure [aw=1/(seoutcome^2)], ivw
//_9
mregger betaoutcome betaexposure [aw=1/(seoutcome^2)]
//_10
mreggerplot betaoutcome seoutcome betaexposure seexposure
qui gr export mreggerplot-height.svg, width(600) replace
//_11
mrmedian betaoutcome seoutcome betaexposure seexposure, ///
    weighted seed(300818)
//_12
mrmodalplot betaoutcome seoutcome betaexposure seexposure, ///
    lc(gs10 gs5 gs0) seed(300818)
qui gr export mrmodalplot-height.svg, width(600) replace
//_^
log close
