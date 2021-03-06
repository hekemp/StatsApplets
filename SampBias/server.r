# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)
library(data.table)

baboon <- read.csv("baboons.csv")
baboonA <- read.csv("baboons.csv")
baboonM <- read.csv("baboonsM.csv")
baboonF <- read.csv("baboonsF.csv")
numberOfRows <- nrow(baboon)
histLims <- c(8,29)
binLength <- 41

shinyServer(function(input, output) {# For storing which rows have been excluded

  baboon <- reactive({
    switch(input$popSelect, "all" = baboonA, "males" = baboonM, "females" = baboonF)
  })
  
  vals <- reactiveValues(
    keeprows = rep(TRUE, numberOfRows))

  val <- reactiveValues(
  meanDataSet = c()
  )
  
  valr <- reactiveValues(
  lastSample = c()
  )

  output$plot1 <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <- baboon()[ vals$keeprows, , drop = FALSE]
    exclude <- baboon()[!vals$keeprows, , drop = FALSE]
    ggplot(keep, aes(length, mass)) + labs(x = "Length (ft)", y = "Mass (lbs)") + geom_point() + geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25) +
      coord_cartesian(xlim = c(66, 157), ylim = c(7,30))
  })
  
  observeEvent(input$popSelect, {
    val$meanDataSet <- c()
    valr$lastSample <- c()
   if(input$popSelect == "all")
   {numberOfRows <- nrow(baboonA)
   vals$keeprows <- rep(TRUE, numberOfRows)
   binLength <- 41
    histLims <- c(8,29)}
   if(input$popSelect == "males")
   {numberOfRows <- nrow(baboonM)
   vals$keeprows <- rep(TRUE, numberOfRows)
   binLength <- 41
    histLims <- c(19,29)
    }
   if(input$popSelect == "females")
   {numberOfRows <- nrow(baboonF)
   vals$keeprows <- rep(TRUE, numberOfRows)
   binLength <- 41
    histLims <- c(8,17)}
   })

  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints(baboon(), input$plot1_click, allRows = TRUE)
    vals$keeprows <- xor(vals$keeprows, res$selected_)
     if (nrow(nearPoints(baboon(), input$plot1_click, allRows = FALSE)) != 0)
      {val$meanDataSet <- c()
       valr$lastSample <- c()}
  })

  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints(baboon(), input$plot1_brush, allRows = TRUE)
    vals$keeprows <- xor(vals$keeprows, res$selected_)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    })
    
  observeEvent(input$sampsize, {
    val$meanDataSet <- c()
    valr$lastSample <- c()
    })

  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, numberOfRows)
    val$meanDataSet <- c()
    valr$lastSample <- c()
  })
  
  observeEvent(input$selection, {
    if(input$selection == "default")
    {vals$keeprows <- rep(TRUE, numberOfRows)
     val$meanDataSet <- c()
     valr$lastSample <- c()
     }

    if(input$selection == "armLength")
    {limit <- 15 
     if(input$popSelect == "all")
   {limit <- 15 # Lower 20.68966%
   }

   if(input$popSelect == "males")
   {limit <- 23.5 # Lower 22% 
   }
   
   if(input$popSelect == "females")
   {limit <- 14.75 #Lower 23.52941%
   }
    
    vals$keeprows <- rep(TRUE, numberOfRows)
    res <- rep(TRUE, numberOfRows)
    res[which(baboon()$upperarm > limit)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    }
    
    if(input$selection == "age")
    {limit <- 12 
     if(input$popSelect == "all")
   {limit <- 12 # Upper 23.64532%
   }

   if(input$popSelect == "males")
   {limit <- 11 # Upper 22% 
   }
   
   if(input$popSelect == "females")
   {limit <- 13 #Upper 19.60784%
   }
    
    vals$keeprows <- rep(TRUE, numberOfRows)
    res <- rep(TRUE, numberOfRows)
    res[which(baboon()$age < limit)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    }
    
    if(input$selection == "skinfold")
    {limit <- 7
     if(input$popSelect == "all")
   {limit <- 7 # Upper 17.24138%
   }

   if(input$popSelect == "males")
   {limit <- 6.5 # Upper 22% 
   }
   
   if(input$popSelect == "females")
   {limit <- 7 #Upper 20.26144%
   }
    vals$keeprows <- rep(TRUE, numberOfRows)
    res <- rep(TRUE, numberOfRows)
    res[which(baboon()$skinfold < limit)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    }

    if(input$selection == "ranking")
    {limit <- .85
     if(input$popSelect == "all")
   {limit <- .85 # Upper 19.70443%
   }

   if(input$popSelect == "males")
   {limit <- .85 # Upper 22% 
   }
   
   if(input$popSelect == "females")
   {limit <- .8 #Upper 22.87582%
   }
    vals$keeprows <- rep(TRUE, numberOfRows)
    res <- rep(TRUE, numberOfRows)
    res[which(baboon()$rank < limit)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    }

    if(input$selection == "location")
    {#Leaving this the same regardless of population because it worked out better than removing more locations
    # All: 18.71921%
    # Males: 18.30065%
    # Females: 20%

    vals$keeprows <- rep(TRUE, numberOfRows)
    res <- rep(TRUE, numberOfRows)
    res[which(baboon()$group == "a")] <- FALSE
    res[which(baboon()$group == "b")] <- FALSE
    res[which(baboon()$group == "c")] <- FALSE
    res[which(baboon()$group == "d")] <- FALSE
    res[which(baboon()$group == "e")] <- FALSE
    res[which(baboon()$group == "f")] <- FALSE
    res[which(baboon()$group == "g")] <- FALSE
    res[which(baboon()$group == "i")] <- FALSE
    res[which(baboon()$group == "k")] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)
    val$meanDataSet <- c()
    valr$lastSample <- c()
    }
    })

    observeEvent(input$draw_1_Sample, {
    newSample <- getSample()
    val$meanDataSet[length(val$meanDataSet) + 1] <- round(mean(newSample$mass), 3)
    valr$lastSample <- newSample
    })

    observeEvent(input$draw_10_Sample, {
    for (timesExecuted in 1:10)
    {newSample <- getSample()
    val$meanDataSet[length(val$meanDataSet) + 1] <- round(mean(newSample$mass), 3)
    valr$lastSample <- newSample
    }
    })

    observeEvent(input$clear_Samples, {
    val$meanDataSet <- c()
    valr$lastSample <- c()
    })
  
  getTitle1 <- function() {
     paste("Population Mean = ", round(mean(baboon()$mass),3), " | Population SD = ", round(sd(baboon()$mass),3))
  }

  output$meansd1 <- renderText({
    getTitle1()
  })
  
  getSample <- function(){
   keep2 <- baboon()[vals$keeprows, , drop = FALSE]
    dataTableCars <- data.table(keep2)
    samSet <- dataTableCars[sample(.N, input$sampsize, replace = TRUE)]
    return(samSet)}
  
  getTitleVar <- function(dat) {
    paste("Last Sample Mean = ", round(mean(dat),3), " | Last Sample SD = ", round(sd(dat),3))}

  output$plot2 <- renderPlot({
  ggplot(valr$lastSample, aes(x = valr$lastSample$length, y = valr$lastSample$mass)) + labs(x = "Length (ft)", y = "Mass (lbs)") + geom_point() + coord_cartesian(xlim = c(66, 157), ylim = c(7,30)) + ggtitle(getTitleVar(valr$lastSample$mass))
      
  })

  getHistTitle <- function()
  {paste("Histogram of Sample Means from the Baboon Population \n Each Sample Mean is Based on a Random Sample of Size", input$sampsize)}

  output$numSamples <- renderText({
    paste("The number of samples is: ", length(val$meanDataSet))
    })
    
  output$plot3 <- renderPlot({
  if(input$popSelect == "all")
  {histLims <- c(8,29) }
   if(input$popSelect == "males")
   {histLims <- c(15,29)
    }
   if(input$popSelect == "females")
   {    histLims <- c(8,17)}
  
  if(length(val$meanDataSet) == 0)
    {plot(1, type="n", main = getHistTitle(), xlab="Mass (lbs)", ylab="Frequency", xlim=histLims, ylim= c(0, 21))
    abline(v=mean(baboonA$mass),col="purple")
     abline(v=mean(baboon()$mass),col="red")
    }

  else if(length(val$meanDataSet) == 1)
  {bins <- seq(min(baboon()$mass), max(baboon()$mass), length.out = binLength)
     hist(val$meanDataSet, breaks =bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim= histLims, ylim= c(0, 21)) 
     hist(mean(valr$lastSample$mass), breaks =bins, col = 'orange', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim=histLims, ylim= c(0, 21), add = T)
     abline(v=mean(baboonA$mass),col="purple")
     abline(v=mean(baboon()$mass),col="red")
     }

  else {
         bins <- seq(min(baboon()$mass), max(baboon()$mass), length.out = binLength)
         counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency")$counts

         if(max(counta) <= 20)
           {counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency")$counts
            hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim=histLims, ylim = c(0, 21))
            hist(mean(valr$lastSample$mass), breaks =bins, col = 'orange', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim=histLims, ylim = c(0, 21), add = T)
            abline(v=mean(baboonA$mass),col="purple")
            abline(v=mean(baboon()$mass),col="red")}

          else
            {counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency")$counts
            hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim= histLims, ylim = c(0, max(counta)+1))
            hist(mean(valr$lastSample$mass), breaks =bins, col = 'orange', border = 'white', main = getHistTitle(), xlab = "Mass (lbs)", ylab = "Frequency", xlim=histLims, ylim = c(0, max(counta)+1), add = T)
            abline(v=mean(baboonA$mass),col="purple")
            abline(v=mean(baboon()$mass),col="red")
          }
     }

  })
    
  })
