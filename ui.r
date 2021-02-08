shinyUI(pageWithSidebar(
  headerPanel("Table Viewer"),
  sidebarPanel(


    
  ),
  mainPanel(
    tableOutput('contents')
  )
))