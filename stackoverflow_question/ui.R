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
    dashboardPage(skin = 'yellow',
        
        dashboardHeader(title = 'StackQuestion'),
        dashboardSidebar(
            
            sidebarMenu(
                menuItem(text = "Trend", icon = icon("chart-line"), tabName = 'trend'),
                menuItem(text = "Tag Quality", icon = icon("clipboard-check"), tabName = 'quality'),
                menuItem(text = "Questions", icon = icon("question-circle"), tabName = 'question')
            )
            
        ),
        dashboardBody(
            
            tabItems(
                tabItem(tabName = 'trend',
                        h2('Number of Questions asked in StackOverflow'),
                        h4('Developer are using StackOverflow intensively during their works. Let\'s see how they behave!'),
                        p(em('Data source: https://www.kaggle.com/imoore/60k-stack-overflow-questions-with-quality-rate')),
                        
                        dateRangeInput("dates", 
                                       label = h5("Set the date range here"), 
                                       start = '2016-01-01',
                                       end = '2016-02-28',
                                       min = '2016-01-01',
                                       max = '2020-12-31',
                                       ),
                        
                        plotlyOutput(outputId = 'plot_trend'),
                        
                        h5('Notes:'),
                        p('HQ: High-quality posts with 30+ score and without a single edit'),
                        p('LQ_EDIT: Low-quality posts with a negative score and with multiple community edits. However, they still remain open after the edits'),
                        p('LQ_CLOSE: Low-quality posts that were closed by the community without a single edit'),
                ),
                tabItem(tabName = 'quality',
                        h2('Tag Question Quality'),
                        
                        selectInput(inputId = "tag_select",
                            label = "You can choose the tags to be compared",
                            multiple = T, 
                            selected = c("java", "python"),
                            choices = unique(tags_quality_data$tags_split)
                        ),
                        
                        plotlyOutput(outputId = 'tag_quality'),
                        
                        p(em('*Note: Only significant tags are shown'))
                ),
                tabItem(tabName = 'question',
                        
                        h2("StackOverflow Question Data"),
                        h4("Here are the list of some questions in the StackOverflow"),
                        
                        DT::dataTableOutput(outputId = "master_data")
                        
                )
            )
            
        )
    )    
)
