# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Default" = "default", "Upper arm length of less than 15 inches (Lower 18.72%)" = "armLength", "Over 12 years old (Upper 19.21%)" = "age", "With over 7mm of skinfolds (Upper 15.27%)" = "skinfold", "Ranked from 0.9 to 1.0 in the tribe (Upper 13.79%)" = "ranking", "From sampling sites H and J (18.72% of population)" = "location")
populationChoices <<- list("Male Baboons" = "males", "Female Baboons" = "females", "All Baboons" = "all")


shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    selectInput("popSelect", "Select a population to use for your samples:", choices = populationChoices),
    helpText("To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("sampsize", "Sample Size:", 25),
    helpText("To see examples of pre-established biases using a third hidden variable, select one of the following."),
    helpText("Note: Changing this variable will reset the graph's settings."),
    selectInput("selection", "Select a group of baboons to exclude:", choices = biasChoices),
    helpText(" "),
    helpText("To take a sample from the biased population using your selected sample size, click one of the buttons below."),
    helpText("A histogram will be constructed using the mean of the mass per sample with the number of bins you specify."),
    helpText("The population's mean is displayed on the histogram as a red line."),
    helpText("Note: Samples drawn from a single point are not supported in this part of the applet."),
    helpText("If you can't see your sample, try either decreasing the amount of bins or drawing more samples."),
    actionButton("draw_1_Sample", "Draw 1 Sample \n"),
    actionButton("draw_10_Sample", "Draw 10 Samples \n"),
    textOutput("numSamples"),
    actionButton("clear_Samples", "Clear Samples")),
  
  mainPanel(
      textOutput("meansd1"),
      plotOutput("plot1", height = 350, click = "plot1_click", brush = brushOpts(id = "plot1_brush")),
      actionButton("exclude_toggle", "Toggle points"),
      actionButton("exclude_reset", "Reset"),
      plotOutput("plot2"),
      plotOutput("plot3")
    )
  )
)
