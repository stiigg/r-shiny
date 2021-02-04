shinyServer(function(input, output) {
  
  this_table <- reactiveVal(this_table)
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    
    this_table = read.csv("C:/Users/chris/Desktop/r/project2/data/csv/status1.csv", header=T, sep=';', quote='')
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    this_table = read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    
    # When user press add button then it whil whrite in the table
    observeEvent(input$add_btn, {
    t = rbind(data.frame(Output.group="",CSR.Table.Name="",SAS.program="",Output.rtf="",Table.Title="",Status.OK.NOT.KO,Comments  = input$Comments ), this_table)
    this_table <<- t
    
    this_table
  })
  
  

  })
})