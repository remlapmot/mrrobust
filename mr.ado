program define mr
version 9
syntax anything(everything) [aweight] [if] [in] [, *]

local subcmd "`1'"
local rest = subinword("`0'", "`subcmd'", "", 1)

if "`subcmd'" == "deps" {
    mrdeps
}
else if "`subcmd'" == "egger" {
    mregger `rest'
}
else if "`subcmd'" == "eggerplot" {
    mreggerplot `rest'
}
else if "`subcmd'" == "eggersimex" {
    mreggersimex `rest'
}
else if "`subcmd'" == "forest" {
    mrforest `rest'
}
else if "`subcmd'" == "funnel" {
    mrfunnel `rest'
}
else if "`subcmd'" == "ivests" {
    mrivests `rest'
}
else if "`subcmd'" == "median" {
    mrmedian `rest'
}
else if "`subcmd'" == "medianobs" {
    mrmedianobs `rest'
}
else if "`subcmd'" == "modal" {
    mrmodal `rest'
}
else if "`subcmd'" == "modalplot" {
    mrmodalplot `rest'
}
else if "`subcmd'" == "ratio" {
    mrratio `rest'
}
else {
    di as err "`subcmd' is not a valid subcommand."
    exit 198
}

end
exit
