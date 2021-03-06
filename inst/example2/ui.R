library(shinydashboard)
library(shiny)
library(data.table)
library(rhandsontable)
library(traittools)
library(sbformula)
library(openxlsx)
library(shinyFiles)

shinyUI( 
  shinydashboard::dashboardPage(
    skin="yellow",
    dashboardHeader(title = "Data Processing"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Phenotyping Dashboard", icon = icon("dashboard"),
                 menuSubItem(text = "Data Processing", tabName = "data_processing")
                 )
       ) 
    ),
    
  dashboardBody(
  tabItems(
     tabItem(tabName = "dashboard",
               h2("HIDAP Modules"),
               p(
                 class = "text-muted",
                 paste("Building..."
                 ))
       ),
###########
#begin data_processing tabItem
  tabItem(tabName = "data_processing",
          h2("Data Quality and Processing"),   

          
        tabsetPanel(
            tabPanel("Check", #begin tabset "CHECK"
                fluidRow(
                  
                   shinyFilesButton('file', 'File select', 'Please select a file',FALSE),
                   actionButton("calculate", "Calculate",icon("play-circle-o")),
                   HTML('<div style="float: right; margin: 0 5px 5px 10px;">'),
                   actionLink('exportButton', 'Download data'),
                   HTML('</div>'),
                     box(rHandsontableOutput("hot_btable",height = "1400px",width = "1400px"),
                         height = "3400px",width ="2400px")
                   
                   #column(5, shinyFileChoose(input, 'files', session=session,
                    #                          roots=c(wd='.'), filetypes=c('', '.txt'))),
                   #column(3, actionButton("calculate", "Calculate",icon("calculator"))),
                   #column(3, actionButton("exportButton", "Download", icon("download")))
                 ),
                 
                 tags$style(type='text/css', "#file { width:150px; margin-top: 25px;}"),
                 tags$style(HTML('#file {background-color:#0099cc; color: #ffffff}')),  
                 tags$style(type='text/css', "#calculate { width:150px; margin-top: 25px;}"),
                 tags$style(HTML('#calculate {background-color:#21b073; color: #ffffff}'))
                 #tags$style(type='text/css', "#exportButton { width:50%; margin-top: 25px;}"),
                 #tags$style(HTML('#exportButton {background-color:#30c9ae; color: #ffffff}')),

                ),#end tab Panel "CHECK"
            
            tabPanel("Trait List", #begin Trait List Panel"
                     fluidRow(
                       box(rHandsontableOutput("hot_td_trait",height = "1400px",width = "1400px"),
                           height = "3400px",width ="2400px")
                       
                     )#end fluidRow
                  )
            
            
            
      )
    )#End data_processing tabItem




  )
)

)
)
  
