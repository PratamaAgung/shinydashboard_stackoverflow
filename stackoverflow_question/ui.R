#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        
        dashboardHeader(title = 'StackQuestion'),
        dashboardSidebar(
            
            sidebarMenu(
                menuItem(text = "Trend", icon = icon("chart-line"), tabName = 'trend'),
                menuItem(text = "Quality", icon = icon("clipboard-check"), tabName = 'quality'),
                menuItem(text = "Tag Correlation", icon = icon("project-diagram"), tabName = 'correlation'),
                menuItem(text = "Questions", icon = icon("question-circle"), tabName = 'question')
            )
            
        ),
        dashboardBody(
            
            tabItems(
                tabItem(tabName = 'trend',
                        h2("Number of Questions asked in StackOverflow"),
                        
                        dateRangeInput("dates", 
                                       label = h5("Set the date range here"), 
                                       start = '2016-01-01',
                                       end = '2016-03-31',
                                       min = '2016-01-01',
                                       max = '2020-12-31',
                                       ),
                        
                        plotlyOutput(outputId = 'plot_trend')
                ),
                tabItem(tabName = 'quality'),
                tabItem(tabName = 'correlation'),
                tabItem(tabName = 'question')
            )
            
        )
    )    
)
