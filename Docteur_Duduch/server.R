#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # load data directlty from framacalc
  # order and add columns to store information
  data <- reactive({
    URL_data_duduch <- RCurl::getURL("https://lite.framacalc.org/9k8a-une-super-app-pour-la-soutenance-de-duduch.csv")
    data_duduch <- read.csv (text = URL_data_duduch)
    data_duduch <- data_duduch[order(data_duduch[, "Nom"]), ]
    row.names(data_duduch) <- 1:nrow(data_duduch)
    data_duduch$essais <- 0
    data_duduch$trouve <- FALSE
    data_duduch
  })
  
  # add reactive values to follow what is going on
  # mot is the whole dataset
  # current line is the focus message
  values <- reactiveValues(
    mots = NULL,
    current_line = NULL,
    essais = 0,
    mot_choisi = NULL,
    total_trouve = NULL
  )
  
  # reacts when the button new_message is pressed
  observeEvent(input$new_message,{
    # change the main button to new message after the application started
    updateActionButton(session, "new_message",
                       label = "Afficher un nouveau message !")
    
    # add data to reactive value
    if (is.null(values$mots)) {
      values$mots <- data()
    }
    
    # add the list of all the names (select input)
    # with update of the list each time an author has been found
    output$list_nom <- renderUI({
      data_duduch <-  isolate(values$mots)
      data_duduch <- subset(data_duduch, !data_duduch$trouve)
      data_duduch$Nom <- as.character(data_duduch$Nom)
      selectInput("name","Essaye de retrouver qui a écrit ce mot dans cette liste :",
                  c(data_duduch$Nom, ""),
                  ""
      )
    })
    
    # add the button to check name
    output$check_name_button <- renderUI({
      actionButton("check_name", "Valider le nom associé", icon("dove"),
                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
    })
    
    # add the button to check name
    output$plot <- renderUI({
      plotOutput("plot_results")
    })
    
    # select one line of the data (name + message)
    
    data_duduch <-  isolate(values$mots)
    data_duduch <- subset(data_duduch, !data_duduch$trouve)
    random <- sample(row.names(data_duduch), size = 1)
    values$current_line  <- as.numeric(random)
    values$mot_choisi <- data_duduch[random, ]
    
    # print the message
    output$print_mot <- renderText({
      mot_choisis <- values$mot_choisi
      mot_choisis$Mot <- as.character(mot_choisis$Mot)
      mot_choisis[, "Mot"]
    })
    
    
    
  })
  # check if the name is the right one (reward if yes, error message if no)
  observeEvent(input$check_name,{
    
    isolate({
      output$print_name <- renderPrint({
        mot_choisis <- isolate(values$mot_choisi)
        
        mot_choisis$Nom <- as.character(mot_choisis$Nom)
        if (mot_choisis[, "Nom"] == isolate(input$name)){
          values$mots[values$current_line, "trouve"] = TRUE
          "Bravo, on comprend vraiment pourquoi tu es docteur"
        } else {
          "T'es vraiment une chèvre !"
        }
        
      })
      
      
      
      
      values$essais = values$essais + 1
      values$total_trouve = c(values$total_trouve, sum(isolate(values$mots$trouve)))
      print(values$total_trouve)
      
      
      
      output$print_results <- renderPrint({
        data.frame(Autrices_ou_auteurs_trouves = sum(values$mots$trouve),
                   Proportion = sum(values$mots$trouve)/nrow(values$mots)
                   #, Essais = values$essais
        )
        #values$mots[ , c("Nom", "essais")]
      })
      
      output$plot_results <- renderPlot({
        total_trouve = c(values$total_trouve, sum(values$mots$trouve))
        
        total_trouve_df = data.frame(trouve = c(values$total_trouve, sum(values$mots$trouve)),
                                     essais = 0:(length(total_trouve) - 1)
        )
        
        maxY = nrow(values$mots)
        
        ggplot(total_trouve_df, aes(x = essais, y = trouve)) +
          geom_hline(yintercept=maxY)+
          geom_text(x = 0, y = maxY - 1, label = "Objectif", color = "red", hjust = 0) +
          geom_line() +
          geom_point() +
          xlab("Nombre d'essais") +
          ylab("Nombre d'autrices ou\n d'auteurs trouvé.e.s") +
          xlim(0, max(total_trouve_df$essais)) +
          ylim(0, maxY) +
          theme_minimal() +
          theme(text = element_text(size=20))
        
        
      })
      
      
      
    })
    
    
    
  })
})
