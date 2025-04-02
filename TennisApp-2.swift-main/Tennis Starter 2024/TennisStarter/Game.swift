class Game {
  
     var extendClass = ExtendedClass()
    
    
   
    
    /**
     
     This method will be called when player 1 wins a point and update the state of the instance of Game to reflect the change
     */
    func addPointToPlayer1(){
        if extendClass.tieBreak{
            
            extendClass.tieBreakp1 += 1
            
        } else{
            extendClass.pointScore += 1
            
        }
    }
    
    /**
     This method will be called when player 2 wins a point
     */
    func addPointToPlayer2(){
        if extendClass.tieBreak{
            
            extendClass.tieBreakp2 += 1
            
        } else{
            extendClass.pointScore2 += 1
            
        }
    }

    /**
     Returns the score for player 1, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String {
        
        if extendClass.tieBreak {
            return "\(extendClass.tieBreakp1)"
            
        }
        else if extendClass.duce(){
            return "40"
            
        }
        else if extendClass.pointScore >= 4 && extendClass.pointScore == extendClass.pointScore2 + 1{
            return "A"
            
        }
        
        return "\(extendClass.playerScore())"
        
    }

    /**
     Returns the score for player 2, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String {
        if extendClass.tieBreak {
            return "\(extendClass.tieBreakp2)"
            
        }
        else if extendClass.duce(){
            return "40"
            
        }
        else if extendClass.pointScore2 >= 4 && extendClass.pointScore2 == extendClass.pointScore + 1{
            return "A"
            
        }
        return "\(extendClass.player2Score())"

    }
    
    /**
     Returns true if player 1 has won the game, false otherwise
     */
    func player1Won() -> Bool{
        
        if extendClass.tieBreak{
            return extendClass.tieBreakp1 >= 7 && extendClass.tieBreakp1 >= extendClass.tieBreakp2 + 2
            
        } else if extendClass.pointScore >= 4 && extendClass.pointScore >= extendClass.pointScore2 + 2 {
            
            return true
        }else{
            
            return false
        }
        
        
                
    }
    
    /**
     Returns true if player 2 has won the game, false otherwise
     */
    func player2Won() -> Bool{
        if extendClass.tieBreak{
            return extendClass.tieBreakp2 >= 7 && extendClass.tieBreakp2 >= extendClass.tieBreakp1 + 2
            
        } else if extendClass.pointScore2 >= 4 && extendClass.pointScore2 >= extendClass.pointScore + 2 {
            
            return true
        }else{
            
            return false
        }
        
        
    }
    
    /**
     Returns true if the game is finished, false otherwise
     */
    func complete() ->Bool {
        if extendClass.pointScore >= 4{
            return true
            
            
        }
        if extendClass.pointScore2 >= 4{
            return true
            
            
        }
        
        
        return false
        
    }
    
    /**
     If player 1 would win the game if they won the next point, returns the number of points player 2 would need to win to equalise the score, otherwise returns 0
     e.g. if the score is 40:15 to player 1, player 1 would win if they scored the next point, and player 2 would need 2 points in a row to prevent that, so this method should return 2 in that case.
     */
    func gamePointsForPlayer1() -> Int{
        
        
        if extendClass.pointScore < 3{
            return 0
        }
        
        if extendClass.pointScore == 3 {
            switch extendClass.pointScore2 {
                
            case 0:
                return 3
                
            case 1:
                return 2
                
            case 2:
                return 1
                
                
            default:
                0
                
                
            }
        }
        
        
        if extendClass.pointScore >= 4 && extendClass.pointScore - extendClass.pointScore2 == 1 {
            
            return 1
            
        }
        
        return 0
        
    }
    
    /**
     If player 2 would win the game if they won the next point, returns the number of points player 1 would need to win to equalise the score
     */
    func gamePointsForPlayer2() -> Int {
        
        
        if extendClass.pointScore2 < 3{
            return 0
        }
        
        if extendClass.pointScore2 == 3 {
            switch extendClass.pointScore {
                
            case 0:
                return 3
                
            case 1:
                return 2
                
            case 2:
                return 1
                
                
            default:
                0
                
                
            }
        }
        
        
        if extendClass.pointScore2 >= 4 && extendClass.pointScore2 - extendClass.pointScore == 1 {
            
            return 1
            
        }
        
        return 0
        
    }
}

