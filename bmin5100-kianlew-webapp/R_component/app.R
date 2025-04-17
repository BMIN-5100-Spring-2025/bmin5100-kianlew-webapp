library(shiny)
library(dplyr)
library(jsonlite)
library(echarts4r)

# Load the CSV file
data <- read.csv("../public/combined_nsduh_svhb(1).csv", stringsAsFactors = FALSE)

# Define the UI
ui <- fluidPage(
  titlePanel("Data Analytics with Charts (Shiny)"),
  sidebarLayout(
    sidebarPanel(
      h4("This app serves data as JSON and charts based on query parameters."),
      p("Access the app with query parameters like ?CATAG6=2&Intention=IRSUICTHNK to filter data.")
    ),
    mainPanel(
      echarts4rOutput("chartOutput", height = "400px"), # Chart output
      verbatimTextOutput("jsonOutput") # JSON output for debugging
    )
  )
)

# Define a helper function to process data
process_data <- function(query) {
  catag6 <- query$CATAG6
  irsex <- query$IRSEX
  newrace2 <- query$NEWRACE2
  eduhighcat <- query$EDUHIGHCAT
  year <- query$YEAR
  intention <- query$Intention
  reasons <- query$REASONS

  filtered_data <- data

  if (!is.null(catag6) && catag6 != "") {
    filtered_data <- filtered_data %>% filter(CATAG6 == as.numeric(catag6))
  }
  if (!is.null(irsex) && irsex != "") {
    filtered_data <- filtered_data %>% filter(IRSEX == as.numeric(irsex))
  }
  if (!is.null(newrace2) && newrace2 != "") {
    filtered_data <- filtered_data %>% filter(NEWRACE2 == as.numeric(newrace2))
  }
  if (!is.null(eduhighcat) && eduhighcat != "") {
    filtered_data <- filtered_data %>% filter(EDUHIGHCAT == as.numeric(eduhighcat))
  }
  if (!is.null(year) && year != "") {
    filtered_data <- filtered_data %>% filter(YEAR == as.numeric(year))
  }

  if (!is.null(intention) && intention != "") {
    filtered_data <- filtered_data %>%
      summarise(value = sum(.data[[intention]] == 1, na.rm = TRUE)) %>%
      mutate(category = intention)
  } else if (!is.null(reasons) && reasons != "") {
    filtered_data <- filtered_data %>%
      summarise(value = sum(.data[[reasons]] == 1, na.rm = TRUE)) %>%
      mutate(category = reasons)
  } else {
    filtered_data <- filtered_data %>%
      group_by(YEAR) %>%
      summarise(value = n()) %>%
      mutate(category = as.character(YEAR))
  }

  return(filtered_data)
}

# Define the server
server <- function(input, output, session) {
  # Get query parameters reactively
  query <- reactive({
    parseQueryString(session$clientData$url_search)
  })

  # Process data based on query parameters
  filtered_data <- reactive({
    process_data(query())
  })

  # Render chart
  output$chartOutput <- renderEcharts4r({
    filtered_data() %>%
      e_charts(category) %>%
      e_bar(value) %>%
      e_title("Data Summary") %>%
      e_toolbox_feature("dataView") # Optional: Add data view tool
  })

  # Render JSON as the response
  output$jsonOutput <- renderText({
    toJSON(filtered_data(), pretty = TRUE)
  })
}

# Create and return the Shiny app object
shinyApp(ui = ui, server = server)