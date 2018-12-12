library(shiny)
library(corrplot)
library(dplyr)
library(ggplot2)
library(rsconnect)
#rsconnect::setAccountInfo(name='yanchenwang', token='D5D46BEF6CF5B60C18847B3D3A050424', secret='K84WHeoXCNNh5NUbvEfNQe7oEK8qL29PMgO83QT+')

df <- read.csv('long_sale_by_make.csv')
df$year = df$year

ui <- fluidPage(
  column(12,offset = 3, titlePanel("Number of Vehicles Sold by Brand")),
  column(12,offset = 3,
         sidebarPanel(
           sliderInput('year_choice','Choose Range of Year',
                        min = 2012, max = 2017, value = c(2012,2017)
                        ),
           width = 5
         )
  ),
  column(4,
         sidebarPanel(
           checkboxGroupInput("brand", "Choose Brands to Compare:",
                              choiceNames =
                                list('BMW','Cadillac','Chevrolet', 'Fiat','Ford','Kia',
                                     'Mercedes','Mitsubishi','Nissan', 'Porsche','Smart',
                                     'Tesla','Toyota','Volvo','VW'
                                    ),
                              choiceValues =
                                list('BMW','Cadillac','Chevrolet', 'Fiat','Ford','Kia',
                                     'Mercedes','Mitsubishi','Nissan', 'Porsche','Smart',
                                     'Tesla','Toyota','Volvo','VW'),
                              selected = list("Tesla",'Toyota','Ford')),
           width = 8
         )
  ),
  column(8,
         dataTableOutput('tot_table')),
  column(12,
  mainPanel(
    plotOutput('bar_chart',height = "500px",width = "800px")
    
  )
  )
  
  
  
)
server <- function(input, output, session) {
  selectData = reactive({
    temp = subset(df, year>=input$year_choice[1] & year<= input$year_choice[2])
    #temp = df[df$year %in% input$year_choice,]
    temp = temp[temp$brand %in% input$brand,]
    #temp1 =df[df$AREA %in% input$l_state,]
    #my_data = rbind(temp,temp1)
    temp$year = as.factor(temp$year)
    return(temp)
  })
  # towrite = reactive({
  #   a = paste(paste("Line Chart of Cancer", input$choice),"Rate")
  #   return(a)})
  # #temp1 = df[df$AREA %in% input$l_state,]
  # #my_data = selectData()
  output$tot_table <- renderDataTable(selectData(),options = list(pageLength = 10))
    
  output$bar_chart <- renderPlot({
    ggplot(data=selectData(),
           aes(year))+
      geom_bar(aes(fill = brand, weight = count))+
      # theme(plot.title = element_text(size=22,hjust = 0.5))+
      labs(y = 'Number of Cars Sold (in Thousands)', 
           x = 'Year', 
           colour = 'Brand')+
      ggtitle("Electric Vehicle Sales Volume by Brand")+
      theme(plot.title = element_text(size=22,hjust = 0.5))

  })
  
  
  
}

shinyApp(ui, server)

