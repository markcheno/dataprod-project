library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    
    equity <- function(startcash,ntrades,pctwin,avgwin,avgloss) startcash+c(0,cumsum(ifelse(runif(ntrades)<pctwin/100,avgwin,-avgloss)))

    getSim <- reactive({
        input$runSim
        isolate({
            sim <- list()
            sim$df <- data.frame(replicate(input$nsims,equity(input$startcash,input$ntrades,input$pctwin,input$avgwin,input$avgloss))) 
            sim$endvalue <- sapply(sim$df,function(x) tail(x,1) )
            sim$maxdd <- sapply(sim$df,function(x) { min(tail(x-cummax(x),-1)) })
            sim$expectancy <- (input$pctwin/100*input$avgwin)-((1-input$pctwin/100)*input$avgloss)
            sim$startcash <- input$startcash
            #sim$returns <- sapply(sim$df,function(x) { (tail(x,1)-head(x,1))/head(x,1) })
            #sim$profit <- sapply(sim$df,function(x) { tail(x,1)-head(x,1) })
            #sim$maxdd <- sapply(sim$df,function(x) { max((cummax(x)-x )/cummax(x)*100) })
            sim
        })
    })
    
    output$equityPlot <- renderPlot({
        sim <- getSim()
        plot(sim$df[,1],type="l",lwd=2,main="Simulated equity curves",ylab='Equity',xlab='Trade Num',ylim=c(min(sim$df),max(sim$df)))
        for( n in sample(1:ncol(sim$df),input$nplots) ) lines(sim$df[,n],col=sample(rainbow(10)),lwd=2)    
        abline(h=sim$startcash,lwd=1)        
    })
    
    output$endvaluePlot <- renderPlot({
        sim <- getSim()
        hist(sim$endvalue,main="Ending Account Value in dollars",xlab="")
        abline(v=mean(sim$endvalue),col="blue",lwd=4)
    })
    
    output$maxddPlot <- renderPlot({
        sim <- getSim()
        hist(sim$maxdd,main="Max Drawdown in dollars",xlab="")
        abline(v=mean(sim$maxdd),col="blue",lwd=4)
    })
    
    output$systemSummary <- renderText({
      sim <- getSim()
      paste("The system expectancy is",sim$expectancy,"which means you can expect to make about",paste("$",sim$expectancy,sep=""),"per trade on average.")
    })

    output$endvalueSummary <- renderUI({
        sim <- getSim()
        sim$min <- min(sim$endvalue)
        sim$max <- max(sim$endvalue)
        sim$avg <- round(mean(sim$endvalue))
        sim$std <- round(sd(sim$endvalue))
        list(tags$b(
            tags$table(width="40%",
                tags$tbody(
                    tags$tr(
                        tags$td("Min: ",align="left"),
                        tags$td(sim$min,align="left")
                    ),
                    tags$tr(
                        tags$td("Max: ",align="left"),
                        tags$td(sim$max,align="left")
                    ),
                    tags$tr(
                        tags$td("Avg: ",align="left"),
                        tags$td(sim$avg,align="left")
                    ),
                    tags$tr(
                        tags$td("Std: ",align="left"),
                        tags$td(sim$std,align="left")
                    )
                )
            ),
            tags$br(),
            tags$br()
        ))
    })

    output$endvalueConfidence <- renderText({
      sim <- getSim()
      sim$avg <- round(mean(sim$endvalue))
      sim$std <- round(sd(sim$endvalue))
      sim$error <- 2*sim$std 
      sim$left <- sim$avg-sim$error
      sim$right <- sim$avg+sim$error 
      paste("There is a 95% probability that the account ending value falls between",paste("$",sim$left,sep=""),"and",paste("$",sim$right,sep=""))
    })

    output$maxddSummary <- renderUI({
        sim <- getSim()
        sim$min <- max(sim$maxdd)
        sim$max <- min(sim$maxdd)
        sim$avg <- round(mean(sim$maxdd))
        sim$std <- round(sd(sim$maxdd))
        list(tags$b(
            tags$table(width="40%",
                       tags$tbody(
                           tags$tr(
                               tags$td("Min: ",align="left"),
                               tags$td(sim$min,align="left")
                           ),
                           tags$tr(
                               tags$td("Max: ",align="left"),
                               tags$td(sim$max,align="left")
                           ),
                           tags$tr(
                               tags$td("Avg: ",align="left"),
                               tags$td(sim$avg,align="left")
                           ),
                           tags$tr(
                               tags$td("Std: ",align="left"),
                               tags$td(sim$std,align="left")
                           )
                       )
            )
        ))
    })

    output$maxddConfidence <- renderText({
      sim <- getSim()
      sim$avg <- round(mean(sim$maxdd))
      sim$std <- round(sd(sim$maxdd))
      sim$error <- 2*sim$std 
      sim$left <- sim$avg-sim$error
      sim$right <- sim$avg+sim$error 
      paste("There is a 95% probability that the maximum drawdown falls between",paste("$",sim$right,sep=""),"and",paste("$",sim$left,sep=""))
    })
    
})
