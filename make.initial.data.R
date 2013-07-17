
require(plyr)

yo <- ""
yn <- ""
vo <- ""
vn <- ""

#ydevel <- list(list())
ydevel <- list(as.numeric(NULL))
vdevel <- list(as.numeric(NULL))
#vdevel <- list(list())

save(yo, yn, vo, vn, ydevel, vdevel, file = "current.rda")

source("make.graph.R")

make.graph(yo = yo, yn = yn, vo = vo, vn = vn, ydevel = ydevel, vdevel = vdevel, lab.violet = "aktuell", lab.yellow = "aktuell")
