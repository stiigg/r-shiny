shinyServer(function(input, output) {
  

  
  output$contents <- renderTable({
    
    
   
    
    this_table= data.frame(a = c(1,2,3), b = c(4,5,6))
    
    

    })
    

  })
