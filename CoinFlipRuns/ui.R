library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme = shinytheme("slate"),
  titlePanel("How often do you get four in a row in ten coin flips?"),
  sidebarLayout(position = "right",
    sidebarPanel(
        numericInput("n", "No. of Flips?",
                     value = 20, min = 5, max = 200, step = 5, width = "30%"),
        sliderInput("p", "How unfair is the coin? p:",
                   min = 0.5, max = 0.99, value = 0.5)
    ),
    
    mainPanel(
        h3("Probability of Runs in a Series of Coin Flips"),
        p("Many of us are", em("surprised"), "to see a run of four or five heads (or tails) 
          in a series of coin flips. We intuitively believe that random data is pretty evenly spread. 
          Random is lumpy. This project allows you to explore the likelihood of straight run (heads or tails) 
          in a series of coin flips"),
        br(),
        p("The probability can be modelled as a Poisson distribution, here it is estimated by simulating your 
          selected length of coin flips 1,000 times and counting the number of runs each time. 
          You can also see the effect of un-balancing the coin by varying the probability, 
          with p = 0.5 a perfectly fair coin."),
        br(),
        p("Try changing the number of coin flips and the fairness of the coin - what happens to the probilities?"),
        br(),
        p("Answer to the question at the top - happens more often than one in four!"),
        plotOutput("runsPlot", hover = "plot_hover"),
        verbatimTextOutput("hoverp"),
        p("Below are the counts for each run length from the 1,000 simulations."),
        tableOutput("runsTable")
    )
  )
))
