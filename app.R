library(shiny)
library(bslib)
library(ellmer)

get_image_summary <- function(path) {
  chat <- chat_github()
  
  refined_prompt <- paste(
    "What is the text in the slide in this image?", 
    "Do not guess or make up any part.",
    "If something is unreadable (especially small text or URLS), leave it as '[unreadable]'. Do not try to fill in gaps."
  )
  
  chat$chat_structured(
    content_image_file(path),
    type = type_object(
      text = type_string(refined_prompt),
      summary = type_string("brief summary of the text on the slide"),
      url = type_string("any urls shown on the slide")
    )
  )
}

ui <- page_sidebar(
  title = "Conference Slide Photo Reader 📷",
  sidebar = sidebar(
    fileInput("image", "Upload an image", accept = c("image/png", "image/jpeg"))
  ),
  layout_column_wrap(
    width = 1/2,
    card(uiOutput("image_ui")),
    card(tableOutput("summary"))
  )
)

server <- function(input, output, session) {
  
  output$image_ui <- renderUI({
    req(input$image)
    bslib::card_image(file = input$image$datapath)
  })
  
  output$summary <- renderTable({
    req(input$image)
    get_image_summary(input$image$datapath)
  })
  
}

shinyApp(ui, server)