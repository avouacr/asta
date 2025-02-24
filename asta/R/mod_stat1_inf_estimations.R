#' stat1_inf_estimations UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_stat1_inf_estimations_ui <- function(id){
  ns <- NS(id)
 
  
  tabItem(tabName = "subitem8",
          h2("Estimations"),
          tags$br(),
          fluidRow(column(4,
                          wellPanel(
                            
                            tags$p("Param\u00e8tres", style = "font-size : 110%; font-weight : bold; text-decoration : underline;"),
                            selectInput(ns("select1"),
                                        "Quel indicateur voulez-vous estimer ?",
                                        choices = c("Taux de pauvret\u00e9 (en %)"="PAUVRE","Moyenne d'\u00e2ge"="AGE","Moyenne des revenus disponibles (en \u20ac)"="REV_DISPONIBLE","Moyenne du patrimoine (en \u20ac)"="PATRIMOINE")),
                            sliderInput(ns("slide1"),
                                        "Choisissez la taille de l'\u00e9chantillon :",
                                        min = 1,
                                        max = 5418,
                                        value = 1000),
                            actionButton(ns("go1"), "Tirer un \u00e9chantillon et estimer l'indicateur" )
                          )
                          
                          
                          ),
                   
                   
                   column(5,
                          
                          tags$p("Visualisation de l'\u00e9chantillon", 
                                 style = "font-size : 110%; font-weight : bold; text-decoration : underline;"),
                          DTOutput(ns("dt1"))
                          
                          ),
                   
                   
                   column(3,
                          
                          tags$p("Calcul de l'estimation", 
                                 style = "font-size : 110%; font-weight : bold; text-decoration : underline;"),
                          
                                              infoBox(
                                                title = "Valeur recherch\u00e9e",
                                                value = textOutput(ns("vraie")),
                                                # subtitle = "Source : Grandile",
                                                icon = icon("chart-line"),
                                                #fill = TRUE,
                                                color="green",
                                                width=12
                                              ),
                                              infoBox(
                                                title = "Valeur estim\u00e9e",
                                                value = textOutput(ns("estime")),
                                                subtitle = "l'estimateur utilis\u00e9 est la moyenne empirique",
                                                icon = icon("chart-line"),
                                                #fill = TRUE,
                                                color="aqua",
                                                width=12
                                              )
                                              
                                              ))
          
          
          
          )
  
}
    
#' stat1_inf_estimations Server Functions
#'
#' @noRd 
mod_stat1_inf_estimations_server <- function(id,global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    local <- reactiveValues(dt = NULL,echant = NULL,taille_echant = NULL,select=NULL)
    
    observeEvent(input$go1,{
      
      local$dt <- global$dt
      local$taille_echant <- input$slide1
      local$echant <- local$dt %>% sample_n(local$taille_echant)
      local$select <- input$select1
      
    })
    
    output$dt1 <- renderDT({
      
      validate(need(expr = !is.null(local$dt),
                    message = "Choisissez un indicateur dans le menu d\u00e9roulant et cliquez pour afficher l'\u00e9chantillon"))
      
      t <- local$echant %>% select(1,5,9,10,11)
      DT::datatable(t,rownames = FALSE)
      
    })
    
    output$vraie <- renderText({
      
      req(local$dt)
      t <- local$dt %>% mutate(PAUVRE = ifelse(PAUVRE == "1",TRUE,FALSE))
      a <- mean(t[,local$select])
      if (local$select=="PAUVRE"){
        b <- a*100
      }
     else {
       b <- a
     }
      format_box(b)
      
    })
    
    output$estime <- renderText({
      
      req(local$dt)
      t <- local$echant %>% mutate(PAUVRE = ifelse(PAUVRE == "1",TRUE,FALSE))
      a <- mean(t[,local$select])
      if (local$select=="PAUVRE"){
        b <- a*100
      }
      else {
        b <- a
      }
      format_box(b)
      
    })
    
    
  })
}
    
## To be copied in the UI
# mod_stat1_inf_estimations_ui("stat1_inf_estimations")
    
## To be copied in the server
# mod_stat1_inf_estimations_server("stat1_inf_estimations")
