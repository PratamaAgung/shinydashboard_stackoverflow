#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$plot_trend <- renderPlotly({
        p1 <- master_data_agg_daily %>% 
            filter(date(date_only) > input$dates[1] & date(date_only) <= input$dates[2]) %>% 
            ggplot(mapping = aes(date_only, NumberOfQuestion, color = quality, group = quality,
                       text = glue("Date : {date_only}
                         Quality : {quality}
                         Question : {number(NumberOfQuestion, big.mark = ',', accuracy = 1)}")
            )) +
            scale_y_continuous(labels = number_format(big.mark = ",")) +
            scale_x_date(date_breaks = "1 month",
                         labels = date_format(format = "%b")
            ) +
            geom_line() +
            scale_color_manual(values=color.group) +
            labs(title = "",
                 x = NULL,
                 y = "Number of Questions",
                 color = "quality"
            )
        
        ggplotly(p1, tooltip = "text") 
    })
    
    output$master_data <- DT::renderDataTable({

        master_data %>%
            select(Title, Tags, CreationDate, quality) %>%
            mutate(CreationDate = format(CreationDate, '%d %b %Y'))
        
    })
    
    output$tag_quality <- renderPlotly({
        p2 <- tags_quality_data %>%
            filter(tags_split %in% input$tag_select) %>%
            spread(quality, NumberOfQuestion) %>%
            plot_ly(x = ~tags_split, y = ~LQ_CLOSE, type='bar', 
                    name = 'LQ_CLOSE',
                    text = 'LQ_CLOSE',
                    marker = list(color = color.group['LQ_CLOSE']),
                    hovertemplate = paste('<b>Tag: %{x}</b>q',
                                          '<br><i>Quality</i>: %{text}<br>',
                                          '<b>%{y:,}</b>')
                    ) %>%
            add_trace(y = ~LQ_EDIT, 
                      name = 'LQ_EDIT', 
                      marker = list(color = color.group['LQ_EDIT']),
                      text = 'LQ_EDIT',
                      hovertemplate = paste('<b>Tag: %{x}</b>q',
                                            '<br><i>Quality</i>: %{text}<br>',
                                            '<b>%{y:,}</b>')
                      ) %>%
            add_trace(y = ~HQ, 
                      name = 'HQ', 
                      marker = list(color = color.group['HQ']),
                      text = 'HQ',
                      hovertemplate = paste('<b>Tag: %{x}</b>q',
                                            '<br><i>Quality</i>: %{text}<br>',
                                            '<b>%{y:,}</b>')
                      ) %>%
            layout(yaxis = list(title = 'Number Of Question'), 
                   xaxis = list(title = 'Tag Name'),
                   barmode = 'stack')
        
        p2
    })

})
