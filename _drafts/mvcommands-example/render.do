markstat using mvcommands-example, markdown keep(do)
whereis pandoc
shell "`r(pandoc)'" mvcommands-example.md -o mvcommands-example-2.md -t markdown-raw_html-citations-native_divs-native_spans --bibliography="refs.bib" --atx-headers
copy ./mvcommands-example-2.md ../../docs/mvcommands-example-2.md, replace
