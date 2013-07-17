

make.graph <- function(yo, yn, vo, vn, ydevel, vdevel, lab.violet, lab.yellow) {
    
    calc.mean <- function(devel) {
        m <- tail(devel[[1]], 1)
        if (length(devel) > 1) {
            ms <- vapply(devel[2:length(devel)], tail, n = 1, 0)
            if (length(devel[[length(devel)]]) != 6) ms <- ms[-length(ms)]
            m <- c(m, ms)
        }
        mean(m)
    }
    
    ### make graph

    label.old <- "alt"

    ys.indices <- c(0.75, 1)
    ys.devel <- c(0, 0.6)

    pdf("display.pdf", 12, 8)

    split.screen(c(1, 2))
    par(bg = "#FFFF00")
    erase.screen(1)
    par(bg = "#FF00FF")
    erase.screen(2)
    par(bg = "transparent")
    

    #### yellow (left)
    par(fig=c(0,0.25, ys.indices), new=TRUE)
    par(mar = c(0,0,0,0))
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = yo, cex = 4)
    box()
    mtext(label.old, 1, cex = 1.5, line = 0.55)


    par(fig=c(0.25,0.5, ys.indices), new=TRUE)
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = yn, cex = 4)
    box()
    mtext(lab.yellow, 1, cex = 1.5, line = 0.55)
    
    par(fig=c(0.175,0.345, 0.55, 0.7), new=TRUE)
    par(mar = c(0,0,0,0))
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = formatC(round_any(calc.mean(ydevel), 0.5), digits = 1, width = 4, format = "f"), cex = 4)
    box()
    mtext("Glück", 1, cex = 1.5, line = 0.55)

    xlim.r.y <- 1 + (length(ydevel)-1)*6
    par(fig=c(0,0.5, ys.devel), new=TRUE)
    par(mar = c(5, 4, 4, 2) + 0.1)
    plot(1, tryCatch(tail(ydevel[[1]], 1), error = function(e) NA), xlim = c(1, xlim.r.y), ylim = c(1, 10), type = "o", xlab = "Verlauf gelb", ylab = "Mittelwert Glücksindex", yaxp = c(1, 10, 9), xaxt = "n")
    if (xlim.r.y > 1) {
        axis(side = 1, at = c(1, which(seq(2, xlim.r.y)%%7 == 4) + 1), labels = as.character(seq_len(length(ydevel))))
    } else axis(side = 1, at = 1, labels = as.character(1))
    for (i in seq_len(length(ydevel)-1)) {
        points(1+seq_along(ydevel[[i+1]])+(6*(i-1)), ydevel[[i+1]], type = "o")
    }
    


    #### violet (right)
    par(fig=c(0.5,0.75, ys.indices), new=TRUE)
    par(mar = c(0,0,0,0))
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = vo, cex = 4)
    box()
    mtext(label.old, 1, cex = 1.5, line = 0.55)


    par(fig=c(0.75,1, ys.indices), new=TRUE)
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = vn, cex = 4)
    box()
    mtext(lab.violet, 1, cex = 1.5, line = 0.55)
    
    par(fig=c(0.675,0.845, 0.55, 0.7), new=TRUE)
    par(mar = c(0,0,0,0))
    plot(1,1, ylim = c(0,10), yaxs = "i", xlim = c(0,10), xaxs = "i", type = "n", axes = FALSE)
    text(5, 5, labels = formatC(round_any(calc.mean(vdevel), 0.5), digits = 1, width = 4, format = "f"), cex = 4)
    box()
    mtext("Glück", 1, cex = 1.5, line = 0.55)


    xlim.r.v <- 1 + (length(vdevel)-1)*6
    par(fig=c(0.5,1, ys.devel), new=TRUE)
    par(mar = c(5, 4, 4, 2) + 0.1)
    plot(1, tryCatch(tail(vdevel[[1]], 1), error = function(e) NA), xlim = c(1, xlim.r.v), ylim = c(1, 10), type = "o", xlab = "Verlauf violett", ylab = "Mittelwert Glücksindex", yaxp = c(1, 10, 9), xaxt = "n")
    if (xlim.r.v > 1) {
        axis(side = 1, at = c(1, which(seq(2, xlim.r.v)%%7 == 4) + 1), labels = as.character(seq_len(length(vdevel))))
    } else axis(side = 1, at = 1, labels = as.character(1))
    for (i in seq_len(length(vdevel)-1)) {
        points(1+seq_along(vdevel[[i+1]])+(6*(i-1)), vdevel[[i+1]], type = "o")
    }

    close.screen(all = TRUE)    # exit split-screen mode

    dev.off()
}
