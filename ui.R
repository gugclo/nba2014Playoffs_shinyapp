library(shiny)

nba2014Playoffs = data.frame(matrix(ncol=4,nrow=16))
names(nba2014Playoffs) = c("Team","Conference","Seed","ELO")
nba2014Playoffs$Seed = rep(1:8,2)
nba2014Playoffs$Conference[1:8] = "Western"
nba2014Playoffs$Conference[9:16] = "Eastern"
nba2014Playoffs$Team = c("Spurs","Thunder","Clippers","Rockets","TrailBlazers","Warriors","Grizzlies","Mavericks","Pacers","Heat","Raptors","Bulls","Wizards","Nets","Bobcats","Falcons")
nba2014Playoffs$ELO = c(1100,1170,1090,1075,1055,1060,1060,1040,1115,1135,1030,995,1005,1015,940,1005)

shinyUI(
    fluidPage(
        # Application title
        titlePanel("7 Game Series between two NBA 2013-2014 Playoff Teams"),
        
        sidebarPanel(
            selectInput("homeTeam",label="Home Team",choices=nba2014Playoffs$Team,selected="Spurs"),
            selectInput("awayTeam",label="Away Team",choices=nba2014Playoffs$Team,selected="Heat"),
            actionButton("goButton", "Simulate Matchup")
        ),
        mainPanel(
            h5("What it does:"),
            h6("This Shiny App will generate simulated predictions based on ELO Ratings from 2013-2014 Regular Season.  All you have to do is select home and away teams from the sidebar panel and hit Simulate Matchup!"),
            h5("How it works:"),
            h6("Once the user has selected a home and away team, each team is run through a seriesSimulation function that runs a Monte Carlo simulation for a 7 game series using win probabilities calculated from each teams ELO rating with a home-court adjustment."),
            p("Data Frame of NBA 2014 Playoff Teams with ELO Rating:"),
            verbatimTextOutput("nba"),
            p("Series Result:"),
            verbatimTextOutput("df")
        )
    )
)