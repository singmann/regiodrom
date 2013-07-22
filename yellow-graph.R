

### initialization

require(plyr)  # used for roundin gto .5
require(lubridate)
source("make.graph.R")

### read data

d.files <- list.files("daten-theater/data", full.names = TRUE)

data.list <- lapply(d.files, read.table, header = FALSE, sep = "\t")
ad <- do.call("rbind", data.list)

colnames(ad) <- c("group", "value", "time")
ad <- ad[ad$value != "None",]
ad <- within(ad, {
    value <- as.numeric(as.character(value))
    time <- as.POSIXct(time)
    })

#str(ad)

### create time intervals
full.start.violet <- seq(from=as.POSIXct("2013-07-19 15:00"), to=as.POSIXct("2013-07-20 13:00"), by="hour")
full.stop.violet <- seq(from=as.POSIXct("2013-07-19 17:00"), to=as.POSIXct("2013-07-20 15:00"), by="hour")

full.start.yellow <- seq(from=as.POSIXct("2013-07-19 16:00"), to=as.POSIXct("2013-07-20 14:00"), by="hour")
full.stop.yellow <- seq(from=as.POSIXct("2013-07-19 18:00"), to=as.POSIXct("2013-07-20 16:00"), by="hour")


full.intervals.yellow <- list()
half.intervals.yellow <- list()
full.intervals.violet<- list()
half.intervals.violet <- list()
for (i in seq(1, 23, by = 2)) {
    full.intervals.violet <- c(full.intervals.violet, list(new_interval(start = full.start.violet[[i]], end = full.stop.violet[[i]])))
    tmp.interval.start.violet <- seq(from = full.start.violet[[i]], to = full.stop.violet[[i]], by = "min")
    tmp.interval.stop.violet <- seq(from = full.start.violet[[i]], to = full.stop.violet[[i]], by = "min")
    tmp.interval.stop.violet <- tmp.interval.stop.violet[21:121]
    tmp.intervals.violet <- list()
    for (j in seq(1, 101, by = 20)) {
        tmp.intervals.violet <- c(tmp.intervals.violet, list(new_interval(start = tmp.interval.start.violet[[1]], end = tmp.interval.stop.violet[[j]])))
    }
    half.intervals.violet <- c(half.intervals.violet, list(tmp.intervals.violet))
    
    full.intervals.yellow <- c(full.intervals.yellow, list(new_interval(start = full.start.yellow[[i]], end = full.stop.yellow[[i]])))
    tmp.interval.start.yellow <- seq(from = full.start.yellow[[i]], to = full.stop.yellow[[i]], by = "min")
    tmp.interval.stop.yellow <- seq(from = full.start.yellow[[i]], to = full.stop.yellow[[i]], by = "min")
    tmp.interval.stop.yellow <- tmp.interval.stop.yellow[21:121]
    tmp.intervals.yellow <- list()
    for (j in seq(1, 101, by = 20)) {
        tmp.intervals.yellow <- c(tmp.intervals.yellow, list(new_interval(start = tmp.interval.start.yellow[[1]], end = tmp.interval.stop.yellow[[j]])))
    }
    half.intervals.yellow <- c(half.intervals.yellow, list(tmp.intervals.yellow))
}

# length(full.start)

# half.start <- seq(from=as.POSIXct("2013-07-19 15:00"), to=as.POSIXct("2013-07-20 14:00"), by="hour")
# half.stop <- seq(from=as.POSIXct("2013-07-19 15:30"), to=as.POSIXct("2013-07-20 14:30"), by="hour")
# half.intervals <- mapply(new_interval, start = half.start, end = half.stop, SIMPLIFY = FALSE)

### identify current interval

current.session.violet <- which(vapply(1:length(full.intervals.violet), function(x) now() %within% full.intervals.violet[[x]], NA))
current.session.yellow <- which(vapply(1:length(full.intervals.yellow), function(x) now() %within% full.intervals.yellow[[x]], NA))

current.interval.violet <- min(which(vapply(1:length(half.intervals.violet[[current.session.violet]]), function(x) now() %within% half.intervals.violet[[current.session.violet]][[x]], NA)))

current.interval.yellow <- min(which(vapply(1:length(half.intervals.yellow[[current.session.yellow]]), function(x) now() %within% half.intervals.yellow[[current.session.yellow]][[x]], NA)))

half.time.violet <- isTRUE(current.interval.violet != 6)
half.time.yellow <- isTRUE(current.interval.yellow != 6)


## load current data

load("current.rda")

### make current data:

rd.yellow <- ad[ad$group == "g",]  #relevant data yellow
rd.violet <- ad[ad$group == "v",]  #relevant data violet


if (half.time.violet) {
    cd.violet <- rd.violet[rd.violet$time %within% half.intervals.violet[[current.session.violet]][[current.interval.violet]],]  # current data 
    if (current.interval.violet == 1) {
        vo <- vn
        vdevel <- c(vdevel, list(round_any(mean(cd.violet[,"value"]), 0.5)))
    } else vdevel[[current.session.violet]] <- c(vdevel[[current.session.violet]], round_any(mean(cd.violet[,"value"]), 0.5))
    lab.violet <- "Trend"
} else {
    cd.violet <- rd.violet[rd.violet$time %within% full.intervals.violet[[current.session.violet]],]  # data from current session only
    vdevel[[current.session.violet]] <- c(vdevel[[current.session.violet]], round_any(mean(cd.violet[,"value"]), 0.5))
    lab.violet <- "aktuell"
}

vn <- formatC(round_any(mean(cd.violet[,"value"]), 0.5), digits = 1, width = 4, format = "f")

if (half.time.yellow) {
    cd.yellow <- rd.yellow[rd.yellow$time %within% half.intervals.yellow[[current.session.yellow]][[current.interval.yellow]],]  # current data 
    if (current.interval.yellow == 1) {
        yo <- yn
        ydevel <- c(ydevel, list(round_any(mean(cd.yellow[,"value"]), 0.5)))
    } else ydevel[[current.session.yellow]] <- c(ydevel[[current.session.yellow]], round_any(mean(cd.yellow[,"value"]), 0.5))
    lab.yellow <- "Trend"
} else {
    cd.yellow <- rd.yellow[rd.yellow$time %within% full.intervals.yellow[[current.session.yellow]],]  # data from current session only
    ydevel[[current.session.yellow]] <- c(ydevel[[current.session.yellow]], round_any(mean(cd.yellow[,"value"]), 0.5))
    lab.yellow <- "aktuell"
}

yn <- formatC(round_any(mean(cd.yellow[,"value"]), 0.5), digits = 1, width = 4, format = "f")

#### save data:
save(yo, yn, vo, vn, ydevel, vdevel, file = "current.rda")

save(yo, yn, vo, vn, ydevel, vdevel, cd.violet, cd.yellow, file = paste0("save-sessions/violett", current.session.violet, "-",  current.interval.violet,".yellow", current.session.yellow, "-", current.interval.yellow, ".rda"))

make.graph(yo = yo, yn = yn, vo = vo, vn = vn, ydevel = ydevel, vdevel = vdevel, lab.violet = lab.violet, lab.yellow = lab.yellow)

