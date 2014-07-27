library(shiny)

seriesSimulation = function(team1,team2,elo1,elo2,homeCourtAdj,K,C){
    
    team1wins = 0
    team2wins = 0
    newELO1 = elo1
    newELO2 = elo2
    
    for (i in 1:7){ #1 simulation for each game of the series
        
        #Home Court ELO Adjustment
        if (i == 1 | i == 2 | i == 5 | i == 7){
            team1home = 1
        }else{
            team1home = -1
        }
        
        #Check if series is over, then break
        if (i > 4){
            if (team1wins == 4 | team2wins == 4){
                break
            }
        }
        
        pTeam1 = 1 / (1 + 10^((newELO2 - newELO1 - team1home*homeCourtAdj)/C))
        pTeam2 = 1 - pTeam1
        rollGame = runif(1)
        
        if (rollGame < pTeam1){
            #Team 1 win
            team1wins = team1wins + 1
            newELO1 = newELO1 + K * (1 - pTeam1)
            newELO2 = newELO2 + K * (0 - pTeam2)
        }else{
            #Team 2 win
            team2wins = team2wins + 1
            newELO1 = newELO1 + K * (0 - pTeam1)
            newELO2 = newELO2 + K * (1 - pTeam2)
        }
    }
    
    #return df
    df = data.frame(matrix(nrow=2,ncol=4))
    names(df) = c("Team","Wins","Initial ELO","Final ELO")
    df[1,1] = team1; df[1,2] = team1wins; df[1,3] = elo1; df[1,4] = newELO1
    df[2,1] = team2; df[2,2] = team2wins; df[2,3] = elo2; df[2,4] = newELO2
    df
}

nba2014Playoffs = data.frame(matrix(ncol=4,nrow=16))
names(nba2014Playoffs) = c("Team","Conference","Seed","ELO")
nba2014Playoffs$Seed = rep(1:8,2)
nba2014Playoffs$Conference[1:8] = "Western"
nba2014Playoffs$Conference[9:16] = "Eastern"
nba2014Playoffs$Team = c("Spurs","Thunder","Clippers","Rockets","TrailBlazers","Warriors","Grizzlies","Mavericks","Pacers","Heat","Raptors","Bulls","Wizards","Nets","Bobcats","Falcons")
nba2014Playoffs$ELO = c(1100,1170,1090,1075,1055,1060,1060,1040,1115,1135,1030,995,1005,1015,940,1005)

shinyServer(
    function(input, output) {
        output$nba <- renderPrint({nba2014Playoffs})
        output$df <- renderPrint({
            input$goButton
            seriesSimulation(input$homeTeam,input$awayTeam,nba2014Playoffs[nba2014Playoffs$Team==input$homeTeam,4],nba2014Playoffs[nba2014Playoffs$Team==input$awayTeam,4],50,250,12)
            })
        #output$random <- renderPrint({round(runif(input$n),3)})
    }
)