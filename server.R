library(tidyverse)

shinyServer(function(input, output){
  
  # this was used to check whether input works
  # output$solar_table <- renderDataTable({input$file})
  
  # This loads selected file
  filedata <- reactive({
    infile <- input$datafile
    
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    
    # a header is expected in the input file
    # 
    read.csv(infile$datapath, header=TRUE)
  })
  
  # This generates a preview the CSV data file
  # will be displayed in the 'Data' tab
  output$filetable <- renderDataTable({
    filedata() 
  })
  
  # This generates the plot for the 'Month' tab
  # showing the same month over different years
  # the month is seleted in the side panel
  output$month_plot <- renderPlot({
      table <- filedata() %>%
      gather(-year, - month, key = "measurement", value="value") %>%
      mutate(year = factor(year, levels=unique(filedata()$year)))
  
    ggplot(data=subset(table, month == input$month), aes(x=year, y=value, fill=year)) +
      facet_wrap( ~ measurement, scales="free", ncol=2) +
      geom_bar(stat="identity") +
      ggtitle(paste(input$month)) +
      theme_bw() +
      theme(axis.title.y = element_blank())
  })
  
  # This generates line plots in the 'Summary plot' tab, months are on the x axis
  output$year_plot <- renderPlot({
      table <- filedata() %>%
      gather(-year, - month, key = "measurement", value="value") %>%
      mutate(year = factor(year, levels=unique(filedata()$year)))
    
    ggplot(data=table, aes(x=month, y=value, group=year, colour=year)) +
      facet_wrap( ~ measurement, scales="free", ncol=2) +
      geom_line() +
      geom_point() +
      scale_x_discrete(limits=c("January", "February", "March", "April", "May",
                                "June", "July", "August", "September", "October",
                                "November", "December"))+
      theme_bw() +
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1))
    
  })
  
    # This generates summary table shown in the 'Summary Table' tab
    output$summary_table <- renderDataTable({
        filedata() %>%
        group_by(year) %>%
        #summarise(total_Euro = round(sum(Euro, na.rm=TRUE)),
        #         total_kWh = sum(kWh, na.rm=TRUE),
        #          total_kWh_kWp = round(sum(kWh_kWp, na.rm=TRUE)))
        summarise_if(is.numeric, sum, na.rm=TRUE)
  })
})
