shinyUI(pageWithSidebar(
  headerPanel("Status Viewer"),
  sidebarPanel(
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote'),
    textInput('Comments', 'add value', value = "", width = NULL, placeholder = NULL),
    actionButton("add_btn", "Add"),
    
    
  ),
  mainPanel(
    tableOutput('contents')
  )
))