shinyUI(fluidPage(
  titlePanel("Plot solar panel performance"),
  sidebarLayout(
    
    # Sidebar
    sidebarPanel(
      
      # File input, select csv file to upload
      # a 'year' and a 'month' column are expected, otherwise readouts are flexible
      fileInput('datafile', 'Choose CSV file:',
                accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    
      # Select the month to be plotted in the 'Month' tab
      selectInput('month', 'Choose a month:', choices = c("January", "February", "March", "April", "May",
                                                         "June", "July", "August", "September", "October",
                                                         "November", "December"))
    ),
    
    # Main page
    mainPanel(
      tabsetPanel(
        
      # Generate tabs
        tabPanel("Data", dataTableOutput("filetable")),
        tabPanel("Month", plotOutput("month_plot", height="600")),
        tabPanel("Summary plot", plotOutput("year_plot", height="600")),
        tabPanel("Summary table",dataTableOutput("summary_table"))
        
      ))
    )
   )
  )

