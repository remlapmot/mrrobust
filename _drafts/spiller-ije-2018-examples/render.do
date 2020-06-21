markstat using spiller-ije-2018-examples, markdown keep(do)
foreach file in spiller-ije-2018-examples.md mreggerplot-bmi.svg mrmodalplot-bmi.svg mreggerplot-height.svg mrmodalplot-height.svg {
	copy ./`file' ../../docs/`file', replace
}
