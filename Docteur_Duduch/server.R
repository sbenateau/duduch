#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data <- reactive({
    URL_data_duduch <- RCurl::getURL("https://lite.framacalc.org/9k8a-une-super-app-pour-la-soutenance-de-duduch.csv")
    data_duduch <- read.csv (text = URL_data_duduch)
  })
  
  output$list_nom <- renderUI({
    data_duduch <- data()
    data_duduch$Nom <- as.character(data_duduch$Nom)
    selectInput("name","Essaye de retrouver qui a écrit ce mot dans cette liste :",
                c(data_duduch$Nom, ""),
                ""
    )
  })
  observeEvent(input$new_message,{
    
    mot_choisis <- reactive({
      data_duduch <- data()
      random <- sample(1:nrow(data_duduch), size = 1)
      data_duduch[random, ]
    })
    
    output$print_mot <- renderPrint({
      mot_choisis <- mot_choisis()
      mot_choisis$Mot <- as.character(mot_choisis$Mot)
      mot_choisis[, "Mot"]
    })
    
    nom_choisis <- eventReactive(input$check_name, {
      input$name
    })
    
    observeEvent(input$check_name,{
      output$print_name <- renderPrint({
        mot_choisis <- mot_choisis()
        mot_choisis$Nom <- as.character(mot_choisis$Nom)
        if (mot_choisis[, "Nom"] == nom_choisis()){
          "Bravo, on comprend vraiment pourquoi tu es docteur"
        } else {
          "T'es vraiment une chèvre !"
        }
      })
    })
    
  })
})
