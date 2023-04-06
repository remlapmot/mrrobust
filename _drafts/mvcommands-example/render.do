if c(os) == "Windows" local path = subinstr("`c(pwd)'", "\_drafts\mvcommands-example", "", 1)
else local path = subinstr("`c(pwd)'", "/_drafts/mvcommands-example", "", 1)
di "`path'"
cap noi adopath ++ "`path'"

markstat using mvcommands-example, markdown keep(do)
whereis pandoc
shell "`r(pandoc)'" mvcommands-example.md -o mvcommands-example-2.md -t gfm --markdown-headings=atx --bibliography="refs.bib" --citeproc
copy ./mvcommands-example-2.md ../../docs/mvcommands-example.md, replace

cap noi adopath - "`path'"
