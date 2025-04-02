//
//  ExtendedClass.swift
//  TennisStarter
//
//  Created by FERANMI YAKUBU-OLUGBENGA on 02/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//



  class ExtendedClass {
    var pointScore : Int = 0
    var pointScore2 : Int = 0
    var gamep1 : Int = 0
    var gamep2 : Int = 0
    var setplayer1 : Int = 0
    var setplayer2 : Int = 0
    var tieBreak : Bool = false
    var tieBreakp1 : Int = 0
    var tieBreakp2 : Int = 0
    var tieBreakserver : Int = 0
    var totalSetsAmount : Int = 0
    var countSets : Int = 0
    var pointsCount : Int = 0
    var currentServe : Int = 0
      var recentSound : Int = 0
      var totalGamePoint : Int = 0
    init(){
        pointScore = 0
        pointScore2 = 0
    }
    
    
    func duce ()-> Bool{
    
        if pointScore >= 3 && pointScore == pointScore2{
            
            return true
            
        }
        
        else{
            return false
            
        }
        
    }
    
    
    
    func playerScore () -> Int{
        
        
        switch pointScore{
            
        case 0:
            return 0
            
        case 1:
            return 15
            
        case 2:
            return 30
            
        case 3:
            return 40
            
            
        default:
            return 40
            
        }
        
        
        
        
    }
    
    
    

    
    
    
    
    func player2Score () -> Int{
        

                
        switch pointScore2{
            
        case 0:
            return 0
            
        case 1:
            return 15
            
        case 2:
            return 30
            
        case 3:
            return 40
        
            
        default:
            return 40
            
        }
        
        
                
    }
    
    
    
    
    
        
    }
    
    
    
    
    

