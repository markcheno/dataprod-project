library(shiny)
library(shinythemes)
require(markdown)

shinyUI(
  fluidPage(theme=shinytheme("readable"),

    titlePanel("Trading System Simulator"),
    
    sidebarLayout(
      sidebarPanel(
        
        sliderInput("nsims",
                    "Number of simulations to run:",
                    min = 500,
                    max = 5000,
                    value = 1000,
                    step = 500),
        
        sliderInput("nplots",
                    "Number of plots to show:",
                    min = 5,
                    max = 100,
                    value = 25,
                    step = 5),
        
        sliderInput("pctwin",
                    "Percent wins:",
                    min = 1,
                    max = 100,
                    value = 40,
                    step = 1),
        
        sliderInput("avgwin",
                    "Average win ($):",
                    min = 10,
                    max = 1000,
                    value = 100,
                    step = 10),
        
        sliderInput("avgloss",
                    "Average loss ($):",
                    min = 10,
                    max = 1000,
                    value = 50,
                    step = 10),
        
        sliderInput("ntrades",
                    "Number of trades:",
                    min = 50,
                    max = 1000,
                    value = 500,
                    step = 10),
        
        numericInput("startcash","Starting equity ($):",10000),
        
        actionButton("runSim","Rerun Simulation")
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Results",
                   fluidPage(
                     fluidRow(
                       column(width=12,
                              plotOutput("equityPlot")
                       )
                     ),
                     fluidRow(
                       column(width=12,
                              textOutput("systemSummary")
                       )
                     ),
                     fluidRow(
                       column(width=6,
                              plotOutput("endvaluePlot")
                       ),
                       column(width=6,
                              plotOutput("maxddPlot")
                       )
                     ),
                     fluidRow(
                       column(width=6,
                              htmlOutput("endvalueSummary")
                       ),
                       column(width=6,
                              htmlOutput("maxddSummary")
                       )
                     ),
                     fluidRow(
                       column(width=6,
                              textOutput("endvalueConfidence")
                       ),
                       column(width=6,
                              textOutput("maxddConfidence")
                       )
                     )
                   )
          ),
          tabPanel("Documentation",
                   includeMarkdown("README.md")
          )
        )
      )
    )
  )
)
