library(shiny)

# Define UI for application that displays messages for Duduch !
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Félicitation docteur Duduch !"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      actionButton("new_message", "Envoyer un mot !"),
      HTML("<br><br>"),
      uiOutput("list_nom"),
      actionButton("check_name", "Valider le nom associé")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("print_mot"),
      verbatimTextOutput("print_name")
    )
  )
))
