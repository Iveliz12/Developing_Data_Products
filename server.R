library(shiny)
library(leaflet)
library(dplyr)

catInformation <- data.frame(
    bmi_Index = c("Under 18.5", "Between 18.5 to 24.9", "Between 25 to 29.9", "Over 30"),
    Category =c("Underweight", "Normal Weight", "Overweight", "Obese")
)
url <- a("Reference for BMI Calculator", href = "https://www.nhlbi.nih.gov/health/educational/lose_wt/BMI/bmi-m.htm")

sevenWonder <- data.frame(Place = c("Great Wall of China",
                                    "Christ the Redeemer",
                                    "Machu Picchu (Peru)",
                                    "Chichen Itza (Yucatan Peninsula, Mexico)",
                                    "The Roman Colosseum (Rome)",
                                    "Taj Mahal (Agra, India)",
                                    "Petra (Jordan)"),
                          lat = c(40.431908, 48.716820, -13.153600,
                                  20.962910,41.938961, 27.1751,30.3285
                          ),
                          long =c(116.570374, -3.534630,-72.523903,
                                 -89.578262, 21.518950, 78.0421,35.4444
                          ))

server <- shinyServer(function(input, output){
    
    bmiC <- reactive({
        if(input$wt == 0 & input$ht ==0){
            print("Please enter weight and height correctly !")
        }
        else{
        input$wt/ (input$ht/100)^2
        }
    })
    
    output$bmi <- renderText({
        print(bmiC())
    })
    
    catg <- reactive({
        if(!is.numeric(bmiC())){
            "BMI not yet calculated"
        }
        else if(bmiC() <= 18.5){
            "Underweight, Your BMI is considered underweight.\nKeep in mind that an underweight BMI calculation may pose certain health risks.\nPlease consult with your healthcare provider for more information\nabout BMI calculations."
        }
        else if(bmiC() > 18.5 & bmiC() <=24.9){
            "Normal Weight, Your BMI is considered normal.\nThis healthy weight helps reduce your risk of serious health conditions and\nmeans you’re close to your fitness goals."
        }
        else if(bmiC() > 24.9 & bmiC() <=29.9){
            "Overweight, Your BMI is considered overweight.\nBeing overweight may increase your risk of cardiovascular disease.\nConsult with your healthcare provider and consider making\nlifestyle changes through healthy eating and fitness to improve your health."
        }
        else if(bmiC() > 29.9){
            "Obesity, Your BMI is considered obese.\nPeople with obesity are at increased risk for many diseases and\nhealth conditions, including cardiovascular disease, high blood pressure\n(Hypertension), Type 2 diabetes, breathing problems and more.\nConsult with your healthcare provider and consider making lifestyle\nchanges through healthy eating and fitness to improve\nyour overall health and quality of life."
        }
    })

    output$cat <- renderText({
        print(catg())
    })
    
    output$table <- renderTable(catInformation)
    
    output$ref <- renderUI({
        tagList(url)})
    
    type <- reactive({
        input$dist
        })
    n <- reactive({
        input$n
        })
    
    data <- reactive({
    if(type() == "Normal"){
        rnorm(n())
    }
    else if(type() == "Exponential"){
        rexp(n())
    }
    else if(type() == "Uniform"){
        runif(n())
    }
    })
    
    output$plot1 <- renderPlot({
        hist(data(), main = paste("Histogram of", type(), "Distribution with", n(), "data", sep = " "))
    })
    output$plot2 <- renderPlot({
        plot(data(), main = paste("Plot of", type(), "Distribution with", n(), "data", sep = " "), ylab = "data")
    })
    
    select <- reactive({
        sevenWonder[sevenWonder$Place %in% input$place, ]
    })
    
    output$map <- renderLeaflet({
        select() %>% leaflet() %>% addTiles() %>% addMarkers(popup = as.character(select()$Place))
    })
    
})