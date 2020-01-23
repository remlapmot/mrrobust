markstat using markstat-call-R-example, markdown keep(do)
foreach file in markstat-call-R-example.md ldl-chd-mreggerplot.svg ldl-chd-mrforest.svg ldl-chd.png {
	copy ./`file' ../../docs/`file', replace
}
