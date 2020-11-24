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
      div(img(src = "francois.png", width = "70%"), style="text-align: center;")
    ),
    
    # Show one message and the answer to the test
    mainPanel(
      textOutput("print_mot"),
      HTML("<br><br>"),
      verbatimTextOutput("print_name"),
      verbatimTextOutput("print_results"),
      div(img(src = "rocheton.png", width = "70%"), style="text-align: center;")
    )
  )
))
