library(shiny)

runs <- function(n, p = 0.5, m = 20) {
    ## Returns count of runs of sequential successes / failures
    ## for n random binomials of probability p
    ## Output of data frame counts by m max
    ## fullrun as TRUE prints the list of n binomials
    x <- rbinom(n, 1, p)
    y <- c(rep(0,m+1))
    for (i in 1:length(x)) {
        if(i == 1) {
            temp <- 1
        }
        else if(i == length(x)){
            if(temp>m) {y[length(y)] <- y[length(y)] + 1}
            else {y[temp+1] <- y[temp+1] + 1}
        }
        else if(x[i] == x[i - 1]) {
            temp <- temp + 1
        }
        else if(temp > m) {
            y[length(y)] <- y[length(y)] + 1
            temp <- 1
        }
        else {
            y[temp] <- y[temp] + 1
            temp <- 1
        }
    }
    out <- data.frame(matrix(y, 1, m+1)); names(out) <- c(1:m, paste0(">",m))
    out
}

runCounts <- function(n, times, p = 0.5, m = 20) {
    ##runs runs for times times
    ##and outputs the (1 - counts of no runs / times) - i.e. probability of occurance of a run of that length
    z <- runs(n, p, m); i <- 1
    while(i < times){z <- rbind(z, runs(n, p, m)); i <- i+1}
    counts <- times - apply(z, 2, function(x) sum(x == 0))
    counts
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    cts <- reactive({
        p <- input$p
        n <- input$n
        cts <- runCounts(n, 1000, p, m = 20)
        if(n < 21) {cts <- cts[1:n]}
        cts
    })

    output$runsPlot <- renderPlot({
      plot(cts()/1000, xlab = "Length of Run", ylab = "Probability of Run", xaxt = "n",
           main = paste0("Estimated Probability of Run Length in ", input$n, " flips for a ",
                         ifelse(input$p == 0.5, "Fair Coin", paste0("biased coin, p = ", input$p))))
      axis(1, at = seq(1:length(cts())), labels = names(cts()))
    })
    
    output$runsTable <- renderTable({
        t(cts())
    },
    digits = 0, bordered = TRUE
    )
    
    output$hoverp <- renderText({
        hover <- input$plot_hover
        dist <- sqrt((hover$y - cts()/1000)^2 + ((hover$x - 1:length(cts()))/10)^2)
        if(is.null(hover) || min(dist) > 0.05) {
            out <- "Hover over a point for the probability"}
        else out <- paste0("Probability for run of length ", names(cts())[which.min(dist)], 
                           ": ", (cts()[which.min(dist)])/1000)
        out
    })
})
