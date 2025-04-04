//
//  GameLogic.swift
//  TennisStarter
//
//  Created by FERANMI YAKUBU-OLUGBENGA on 04/04/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

class GameLogic  {
    var game : Game
    var extendClass : ExtendedClass
    weak var viewController: ViewController?
    
    init(game: Game, extendClass: ExtendedClass, viewController: ViewController) {
        self.game = game
        self.extendClass = extendClass
        self.viewController = viewController
        
        
    }
    
    
    
    
    func ResetScores () {
        
        game.extendClass.gamep1 = 0
        game.extendClass.gamep2 = 0
        game.extendClass.tieBreakp1 = 0
        game.extendClass.tieBreakp2 = 0
        game.extendClass.setplayer1 = 0
        game.extendClass.setplayer2 = 0
        game.extendClass.currentServe = 1
        game.extendClass.pointScore = 0
        game.extendClass.pointScore2 = 0


        
        
    }


    func finalSet(){
        
        if game.extendClass.setplayer1 == 2 && game.extendClass.setplayer2 == 2 {
            
            if game.extendClass.gamep1 >= 6 && game.extendClass.gamep1 >= game.extendClass.gamep2 + 2{
                
                game.extendClass.setplayer1 += 1
                
            } else if game.extendClass.gamep2 >= 6 && game.extendClass.gamep2 >= game.extendClass.gamep1{
                
                game.extendClass.setplayer2 += 1
                
            }
            
            
            
        }
        
    }
    
    
    
    func serve() {
        if game.extendClass.tieBreak {
            let totalTiebreakPoints = game.extendClass.tieBreakp1 + game.extendClass.tieBreakp2 + game.extendClass.pointsCount

            if totalTiebreakPoints == 0 {
                game.extendClass.currentServe = 1
            } else if totalTiebreakPoints == 1 {
                game.extendClass.currentServe = 2
            } else {
                let index = (totalTiebreakPoints - 1) / 2
                game.extendClass.currentServe = (index % 2 == 0) ? 2 : 1
            }
            
            // Ensure tieBreakserver is updated
            game.extendClass.tieBreakserver = game.extendClass.currentServe

        } else {
            game.extendClass.totalGamePoint = game.extendClass.gamep1 + game.extendClass.gamep2 + game.extendClass.pointsCount
            let totalGames = game.extendClass.totalGamePoint
            game.extendClass.currentServe = (totalGames % 2 == 0) ? 1 : 2
        }

        viewController?.serverUpdate()
    }
    
    
    
    
    
    
}


