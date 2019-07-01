markstat using markstat-call-R-example, keep(md)
foreach file in markstat-call-R-example.md ldl-chd-mreggerplot.svg ldl-chd-mrforest.svg ldl-chd.png {
	copy ./`file' ../../docs/`file', replace
}
