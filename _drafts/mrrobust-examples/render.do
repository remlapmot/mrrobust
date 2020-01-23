markstat using mrrobust-examples, markdown
foreach file in mrrobust-examples.md mrforest.svg mreggersimex-plot.svg mreggerplot.svg mrmodalplot.svg mrfunnel.svg {
	copy ./`file' ../../docs/`file', replace
}
