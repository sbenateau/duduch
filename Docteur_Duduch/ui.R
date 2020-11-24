library(shiny)

# Define UI for application that displays messages for Duduch !
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Félicitations docteur Duduch !"),
  
  # Sidebar with two buttons and a select input
  sidebarLayout(
    sidebarPanel(
      actionButton("new_message", "Commencer"),
      HTML("<br><br>"),
      uiOutput("list_nom"),
      uiOutput("check_name_button"),
      img(src = "francois.png", height = 300, width = 300)
    ),
    
    # Show one message and the answer to the test
    mainPanel(
      textOutput("print_mot"),
      HTML("<br><br>"),
      verbatimTextOutput("print_name"),
      verbatimTextOutput("print_results"),
      img(src = "rocheton.png", height = 300, width = 600)
    )
  )
))
