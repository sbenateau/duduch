library(shiny)

# Define UI for application that displays messages for Duduch !
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Félicitation docteur Duduch !"),
  
  # Sidebar with two buttons and a select input
  sidebarLayout(
    sidebarPanel(
      actionButton("new_message", "Envoyer un mot !"),
      HTML("<br><br>"),
      uiOutput("list_nom"),
      actionButton("check_name", "Valider le nom associé")
    ),
    
    # Show one message and the answer to the test
    mainPanel(
      verbatimTextOutput("print_mot"),
      verbatimTextOutput("print_name")
    )
  )
))
