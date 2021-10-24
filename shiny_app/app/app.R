#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library('shiny')
library('tidyverse')

# Process Command Line Arguments
# 
# args <- commandArgs(trailingOnly = TRUE);
# port <- as.numeric(args[1])

# Data Preparation

derived_heart = read.csv("/home/rstudio/project/derived_data/derived_heart.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Cardiovascular Risk Factors Data"),

    # Sidebar with a slider input for number of bins 
    selectInput(inputId="covariate", label="Choose Covariate", choices = c(
                 "Age" = "Age",
                 "Sex" = "Sex",
                 "Chest_Pain" = "Chest_Pain",
                 "Resting_Blood_Pressure" = "Resting_Blood_Pressure",
                 "Colestrol" = "Colestrol",
                 "Fasting_Blood_Sugar" = "Fasting_Blood_Sugar",
                 "Rest_ECG" = "Rest_ECG",
                 "MAX_Heart_Rate" = "MAX_Heart_Rate",
                 "Exercised_Induced_Angina" = "Exercised_Induced_Angina",
                 "ST_Depression" = "ST_Depression",
                 "Slope" = "Slope",
                 "Major_Vessels" = "Major_Vessels",
                 "Thalessemia" = "Thalessemia"),
                 selected = "Age", multiple = F),
    
        # Show a plot of the generated distribution
            mainPanel(
             verbatimTextOutput("summary"),
             plotOutput("distPlot")
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
    
    if (input$covariate == "Resting_Blood_Pressure" | input$covariate == "Colestrol" | 
        input$covariate == "Age" | input$covariate == "MAX_Heart_Rate" | 
        input$covariate == "ST_Depression") {
        plt <- ggplot(derived_heart, aes(y=.data[[input$covariate]])) +
            geom_boxplot() +
            facet_wrap(~Target)
    }
    else { 
        derived_heart2 <- derived_heart %>% mutate(Target=factor(Target))
        plt <- ggplot(derived_heart2, aes(y=.data[[input$covariate]], fill=Target)) +
            geom_bar() 
       
        }
        plt
    })
    
}


# Run the application 
shinyApp(ui = ui, server = server, options=list(port=8080, host="0.0.0.0"))

