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
  
  # load data directlty from framacalc
  data <- reactive({
    URL_data_duduch <- RCurl::getURL("https://lite.framacalc.org/9k8a-une-super-app-pour-la-soutenance-de-duduch.csv")
    data_duduch <- read.csv (text = URL_data_duduch)
    data_duduch$essais <- 0
    data_duduch$trouve <- FALSE
    data_duduch
  })
  
  # add reactive values to follow what is 
  values <- reactiveValues(
    mots = NULL,
    current_line = NULL
  )
  
  # reacts when the button new_message is pressed
  observeEvent(input$new_message,{
    
    if (is.null(values$mots)) {
      values$mots <- data()
    }
    
    
    isolate({
      if (!is.null(values$current_line)){
        if (values$mots[values$current_line, "essais"] != 0){
          values$mots[values$current_line, "essais"] = values$mots[values$current_line, "essais"] - 1
        }
      }
      
    })
    
    # add the list of all the names (select input)
    output$list_nom <- renderUI({
      data_duduch <-  isolate(values$mots)
      data_duduch <- subset(data_duduch, !data_duduch$trouve)
      data_duduch$Nom <- as.character(data_duduch$Nom)
      selectInput("name","Essaye de retrouver qui a écrit ce mot dans cette liste :",
                  c(data_duduch$Nom, ""),
                  ""
      )
    })
    
    output$check_name_button <- renderUI({
      actionButton("check_name", "Valider le nom associé")
    })
    
    # select one line of the data (name + message)
    mot_choisis <- reactive({
      data_duduch <-  isolate(values$mots)
      data_duduch <- subset(data_duduch, !data_duduch$trouve)
      random <- sample(row.names(data_duduch), size = 1)
      values$current_line  <- as.numeric(random)
      data_duduch[random, ]
    })
    
    # print the name R style
    output$print_mot <- renderText({
      mot_choisis <- mot_choisis()
      mot_choisis$Mot <- as.character(mot_choisis$Mot)
      mot_choisis[, "Mot"]
    })
    
    
    
    # check if the name is the right one (reward if yes, error message if no)
    observeEvent(input$check_name,{
      
      isolate({
        output$print_name <- renderPrint({
          mot_choisis <- mot_choisis()
          
          mot_choisis$Nom <- as.character(mot_choisis$Nom)
          if (mot_choisis[, "Nom"] == isolate(input$name)){
            values$mots[values$current_line, "trouve"] = TRUE
            "Bravo, on comprend vraiment pourquoi tu es docteur"
          } else {
            "T'es vraiment une chèvre !"
          }
          
        })
        
        values$mots[values$current_line, "essais"] = values$mots[values$current_line, "essais"] + 1
        

      
      
      output$print_results <- renderPrint({
        data.frame(Autrices_ou_auteurs_trouves = sum(values$mots$trouve),
                   Proportion = sum(values$mots$trouve)/nrow(values$mots)
                  # , Essais = sum(values$mots$essais)
        )
        #values$mots[ , c("Nom", "essais")]
       })

      })
      
    })
    
    
    
  })
})
