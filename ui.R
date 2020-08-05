library(shiny)
library(leaflet)
library(dplyr)

navbarPage(
    "Coursera Assignment",
    tabPanel(
        "BMI",
        titlePanel("Body Mass Index"),
        sidebarLayout(
            sidebarPanel(
                numericInput("wt", "Enter your weight here (Kg)", value = 0),
                numericInput("ht", "Enter your height here (Cm)", value = 0),
                submitButton("Calculate")
                
            ),
            mainPanel(
                h3("Body Mass Index Calculator"),
                h4("your body mass index is :"),
                verbatimTextOutput("bmi"),
                h5("Category: "),
                verbatimTextOutput("cat"),
                tableOutput("table"),
                uiOutput("ref")
            )
        )
    ),
    tabPanel(
        "R Plots",
        titlePanel("DISTRIBUTION PLOTS"),
        sidebarLayout(
            sidebarPanel(
                radioButtons(
                    "dist",
                    "Select Your Distribution: ",
                    c("Normal", "Exponential", "Uniform")
                ),
                sliderInput(
                    "n",
                    "Data Size",
                    min = 10,
                    max = 10 ^ 4,
                    value = 100,
                    step = 100
                ),
                submitButton("Draw !")
            ),
            
            mainPanel(
                h3("Distribution Plot"),
                plotOutput("plot1"),
                plotOutput("plot2")
            )
        )
    ),
    tabPanel("7 Wonders of the World",
             titlePanel("7 Wonders of the World"),
             sidebarLayout(
                 sidebarPanel(
                     checkboxGroupInput("place", "What Place do you want to mark ?",
                        choices = c("Great Wall of China",
                                    "Christ the Redeemer",
                                    "Machu Picchu (Peru)",
                                    "Chichen Itza (Yucatan Peninsula, Mexico)",
                                    "The Roman Colosseum (Rome)",
                                    "Taj Mahal (Agra, India)",
                                    "Petra (Jordan)")),
                     submitButton("Draw!")
                 ), 
                 mainPanel(
                     h3("Interactive Map"),
                     leafletOutput("map")
                 )
             ))
)