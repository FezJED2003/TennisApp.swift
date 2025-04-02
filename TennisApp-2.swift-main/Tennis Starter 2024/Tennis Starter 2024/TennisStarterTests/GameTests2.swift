import XCTest
import CoreLocation

class GameTests2: XCTestCase{
    
    var viewController: ViewController!
    var game : Game!
    var extendedClass : ExtendedClass!
    
    override func setUp(){
        
        super.setUp()
        
        let storyBoard = UIStoryboard (name:  "Main", bundle: Bundle(for: ViewController.self))
        
        viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        
        XCTAssertNotNil(viewController,"ViewController failed to load from storyBoard")
        
        viewController.loadViewIfNeeded()
        
        game = viewController.game
        extendedClass = viewController.game.extendClass
        
    }
    
    
    func testGamesWon (){
        viewController.p1Button.isEnabled = true
        viewController.p2Button.isEnabled = true
        
        viewController.gameWon()
        viewController.game.extendClass.setplayer1 = 3
        
        
        XCTAssertTrue(viewController.p1Button.isEnabled, "p1Button should be disabled after")
        XCTAssertTrue(viewController.p1Button.isEnabled, "p2Button should be disabled after")
        
        
    }
    func testRestartGame() {
        viewController.game.extendClass.setplayer1 = 2
        viewController.game.extendClass.setplayer2 = 1
            viewController.restartPressed(UIButton())

            XCTAssertEqual(viewController.p1GamesLabel.text, "0")
            XCTAssertEqual(viewController.p2GamesLabel.text, "0")
            XCTAssertEqual(viewController.p1SetsLabel.text, "0")
            XCTAssertEqual(viewController.p2SetsLabel.text, "0")
            XCTAssertEqual(viewController.p1Button.isEnabled, true)
            XCTAssertEqual(viewController.p2Button.isEnabled, true)
        }
    
    
    
    func testWonGamep1 () {
        viewController.game.extendClass.setplayer1 = 3
        viewController.gameWon()
        
        
        XCTAssertFalse(viewController.p1Button.isEnabled, "p1 Button should be disabled")
        XCTAssertFalse(viewController.p1Button.isEnabled, "p2 Button should be disabled")

        
    }
    
    
    func testWonGamep2 () {
        viewController.game.extendClass.setplayer2 = 3
        viewController.gameWon()
        
        
        XCTAssertFalse(viewController.p1Button.isEnabled, "p1 Button should be disabled")
        XCTAssertFalse(viewController.p1Button.isEnabled, "p2 Button should be disabled")

        
    }
    
    func testRegularServeGamep1() {
        viewController.game.extendClass.gamep1 = 3
        viewController.game.extendClass.gamep2 = 2
        viewController.serve()
        
        XCTAssertEqual(viewController.game.extendClass.currentServe, 2) // Checks correct switching
    }

    func testRegularServeGamep2() {
        viewController.game.extendClass.gamep1 = 2
        viewController.game.extendClass.gamep2 = 2
        viewController.serve()
        
        XCTAssertEqual(viewController.game.extendClass.currentServe, 1) // Ensures switching logic works
    }

    func testTieBreakServe() {
        viewController.game.extendClass.tieBreak = true
        viewController.game.extendClass.tieBreakp1 = 2
        viewController.game.extendClass.tieBreakp2 = 1
        viewController.serve()
        
        XCTAssertEqual(viewController.game.extendClass.tieBreakserver, 1) // Now matches updated logic
    }

    
    
    func testPlayerWinsPoint() {
        viewController.game.extendClass.pointScore = 4
        viewController.player1Wins()
        
        XCTAssertEqual(viewController.game.extendClass.pointScore, 0)
        
        // Assert that game score for player 1 is incremented
        XCTAssertEqual(viewController.game.extendClass.gamep1, 1)
    }

    func testPlayer2WinsPoint() {
        viewController.game.extendClass.pointScore2 = 4
        viewController.player2Wins()
        
        XCTAssertEqual(viewController.game.extendClass.pointScore2, 0)
        
        XCTAssertEqual(viewController.game.extendClass.gamep2, 1)
    }

    
    func testPointsUpdateUi() {
        // Set the point values
        viewController.game.extendClass.pointScore = 2
        viewController.game.extendClass.pointScore2 = 3
        
        // Update the UI based on the current scores
        viewController.pointUpdateUI()

        // Check if the p1PointsLabel displays "30" for player 1
        XCTAssertEqual(viewController.p1PointsLabel.text, "30")
        
        // Check if the p2PointsLabel displays "40" for player 2
        XCTAssertEqual(viewController.p2PointsLabel.text, "40")
    }

    
    
    
    func lastSetPlayer1Wins() {
        viewController.game.extendClass.setplayer1 = 2
        viewController.game.extendClass.setplayer2 = 2
        viewController.game.extendClass.gamep1 = 6
        viewController.game.extendClass.gamep2 = 4
        
        
        viewController.finalSet()
        
        XCTAssertEqual(viewController.game.extendClass.setplayer1, 3, "Player 1 should win the final set.")
        
        
        
    }
    
    
    func lastSetPlayer2Wins() {
        viewController.game.extendClass.setplayer1 = 2
        viewController.game.extendClass.setplayer2 = 2
        viewController.game.extendClass.gamep1 = 6
        viewController.game.extendClass.gamep2 = 4
        
        
        viewController.finalSet()
        
        XCTAssertEqual(viewController.game.extendClass.setplayer1, 3, "Player 2 should win the final set.")
        
        
        
    }
    
    func testTieBreak() {
        viewController.game.extendClass.gamep1 = 6
        viewController.game.extendClass.gamep2 = 6
        
        viewController.tieBreakEnabled()
        
        XCTAssertTrue(viewController.game.extendClass.tieBreak, "TieBreak should be enabled at 6-6")
    }


    
    func testResetGame () {
        
        viewController.game.extendClass.setplayer1 = 2
        viewController.game.extendClass.setplayer2 = 1
        viewController.game.extendClass.gamep1 = 3
        viewController.game.extendClass.gamep2 = 2

        viewController.gameRestart()
        
        XCTAssertEqual(viewController.game.extendClass.setplayer1, 0)
        XCTAssertEqual(viewController.game.extendClass.setplayer2, 0)
        XCTAssertEqual(viewController.game.extendClass.pointScore, 0)
        XCTAssertEqual(viewController.game.extendClass.pointScore2, 0)
        XCTAssertTrue(viewController.p1Button.isEnabled)
        XCTAssertTrue(viewController.p2Button.isEnabled)


        
        
        
    }
    
    
    
    
    func testServePlayer1 () {
        
        viewController.game.extendClass.currentServe = 1
        viewController.serverUpdate()
        
        
        XCTAssertEqual(viewController.p1NameLabel.backgroundColor, UIColor.purple)
        XCTAssertEqual(viewController.p2NameLabel.backgroundColor, UIColor.clear)

        
    }
    
    func testServePlayer2() {
        viewController.game.extendClass.currentServe = 2
        viewController.serverUpdate()
        
        // Assert the correct player's name label has a purple background during their serve
        XCTAssertEqual(viewController.p2NameLabel.backgroundColor, UIColor.purple)
        XCTAssertEqual(viewController.p1NameLabel.backgroundColor, UIColor.clear)
    }

    
    
    
    func testGreenP1Lead () {
        
        
        viewController.game.extendClass.setplayer1 = 2
        viewController.game.extendClass.setplayer2 = 1
        
        viewController.checkGreen()
        
        XCTAssertEqual( viewController.p1SetsLabel.backgroundColor, UIColor.green)
        XCTAssertEqual(viewController.p2SetsLabel.backgroundColor, UIColor.clear )
        
        
    }
    
    
    func testGreenP2Lead () {
        
        
        viewController.game.extendClass.setplayer1 = 1
        viewController.game.extendClass.setplayer2 = 2
        
        viewController.checkGreen()
        
        XCTAssertEqual( viewController.p2SetsLabel.backgroundColor, UIColor.green)
        XCTAssertEqual(viewController.p1SetsLabel.backgroundColor, UIColor.clear )
        
        
    }
    
    
    func testGameAfterMatch() {
        
        viewController.game.extendClass.setplayer1 = 3
        viewController.gameRestart()
        
        
        XCTAssertEqual( viewController.game.extendClass.setplayer1, 0)
        XCTAssertEqual( viewController.game.extendClass.setplayer2, 0)
        XCTAssertEqual( viewController.p1SetsLabel.text,  "0")
        XCTAssertEqual( viewController.p2SetsLabel.text, "0")

        
    }
    
    
    func testButtonDisableAfterMatch (){
        
        viewController.game.extendClass.setplayer1 = 3
        viewController.gameWon()
        
        XCTAssertFalse(viewController.p1Button.isEnabled, "Player 1 button should be disabled")
        XCTAssertFalse(viewController.p2Button.isEnabled, "Player 2 button should be disabled")
        
    }
    
    
    
    
    func testTieBreakSwitch() {
        viewController.game.extendClass.tieBreak = true
        viewController.game.extendClass.tieBreakp1 = 0
        viewController.game.extendClass.tieBreakp2 = 0
        viewController.game.extendClass.pointsCount = 0

        viewController.serve()
        XCTAssertEqual(viewController.game.extendClass.currentServe, 1, "First serve should start with player 1")

        // Simulate 1st point (Switch to Player 2)
        viewController.game.extendClass.tieBreakp1 = 1
        viewController.serve()
        XCTAssertEqual(viewController.game.extendClass.currentServe, 2, "Server should switch after the first point")

        // Simulate 2nd point (Should stay with Player 2)
        viewController.game.extendClass.tieBreakp2 = 1
        viewController.serve()
        XCTAssertEqual(viewController.game.extendClass.currentServe, 2, "Server should stay after 2nd point")

        // Simulate 3rd point (Switch to Player 1)
        viewController.game.extendClass.tieBreakp1 = 2
        viewController.serve()
        XCTAssertEqual(viewController.game.extendClass.currentServe, 1, "Server should switch after 3rd point")
    }

    
    
    func testRestartButton() {
        viewController.restartPressed(UIButton())

        XCTAssertEqual(viewController.p1GamesLabel.text, "0", "Games should reset")
        XCTAssertEqual(viewController.p2GamesLabel.text, "0", "Games should reset")
        XCTAssertEqual(viewController.p1SetsLabel.text, "0", "Sets should reset")
        XCTAssertEqual(viewController.p2SetsLabel.text, "0", "Sets should reset")
        XCTAssertEqual(viewController.p1Button.isEnabled, true, "Buttons should be re-enabled")
    }

    func testPointUpdateUI() {
        viewController.game.extendClass.pointScore = 2
        viewController.game.extendClass.pointScore2 = 3

        viewController.pointUpdateUI()

        XCTAssertEqual(viewController.p1PointsLabel.text, "30", "Player 1 score should update")
        XCTAssertEqual(viewController.p2PointsLabel.text, "40", "Player 2 score should update")
    }
    
    func testSaveAndLoadMatchHistory() {
        let match1 = MatchRecord(date: "2025-03-29 12:00:00", player1: "Player A", player2: "Player B", score: "6-4, 7-6")
        let match2 = MatchRecord(date: "2025-03-30 14:00:00", player1: "Player C", player2: "Player D", score: "6-3, 6-2")

        var history = MatchHistory(matches: [match1, match2])
        saveMatchHistory(history: history)

        let loadedHistory = loadMatchHistory()

        XCTAssertEqual(loadedHistory.matches.count, 2, "Loaded history should contain two matches")
        XCTAssertEqual(loadedHistory.matches[0].player1, "Player A", "First match should be for Player A vs Player B")
        XCTAssertEqual(loadedHistory.matches[1].score, "6-3, 6-2", "Second match should have correct score")
    }

    func RetestSaveAndLoadMatchHistory() {
        let testMatch = MatchRecord(date: "2025-03-30", player1: "Player A", player2: "Player B", score: "6-4, 7-5")
        var history = MatchHistory(matches: [testMatch])

        saveMatchHistory(history: history)

        let loadedHistory = loadMatchHistory()

        XCTAssertEqual(loadedHistory.matches.count, 1, "One match should be loaded.")
        XCTAssertEqual(loadedHistory.matches.first?.player1, "Player A", "Player 1 should match saved data.")
        XCTAssertEqual(loadedHistory.matches.first?.player2, "Player B", "Player 2 should match saved data.")
    }

    func testAddMatchToHistory() {
        let initialHistory = loadMatchHistory()
        let initialCount = initialHistory.matches.count

        addMatchToHistory(player1: "Player X", player2: "Player Y", score: "6-3, 6-2")

        let updatedHistory = loadMatchHistory()
        XCTAssertEqual(updatedHistory.matches.count, initialCount + 1, "Match count should increase after adding a match.")
    }

    func testTieBreakActivation() {
        viewController.game.extendClass.gamep1 = 6
        viewController.game.extendClass.gamep2 = 6

        viewController.tieBreakEnabled()

        XCTAssertTrue(viewController.game.extendClass.tieBreak, "TieBreak should activate at 6-6")
    }
    
    func testTieBreakStartWithZeroPoints() {
        viewController.game.extendClass.tieBreak = true
        viewController.game.extendClass.tieBreakp1 = 0
        viewController.game.extendClass.tieBreakp2 = 0

        viewController.serve()

        XCTAssertEqual(viewController.game.extendClass.currentServe, 1, "Tie-break should start with Player 1 serving.")
    }

    func testGameScoreResetAfterMatchWin() {
        viewController.game.extendClass.setplayer1 = 3
        viewController.gameRestart()

        XCTAssertEqual(viewController.game.extendClass.setplayer1, 0)
        XCTAssertEqual(viewController.game.extendClass.setplayer2, 0)
        XCTAssertEqual(viewController.game.extendClass.gamep1, 0)
        XCTAssertEqual(viewController.game.extendClass.gamep2, 0)
    }
    
    func testAddPointToPlayer1() {
        let game = Game()
        
        game.addPointToPlayer1()
        XCTAssertEqual(game.extendClass.pointScore, 1, "Player 1's point score should increment.")

        game.extendClass.tieBreak = true
        game.addPointToPlayer1()
        XCTAssertEqual(game.extendClass.tieBreakp1, 1, "Player 1's tie-break score should increment in tie-break mode.")
    }

    func testAddPointToPlayer2() {
        let game = Game()
        
        game.addPointToPlayer2()
        XCTAssertEqual(game.extendClass.pointScore2, 1, "Player 2's point score should increment.")

        game.extendClass.tieBreak = true
        game.addPointToPlayer2()
        XCTAssertEqual(game.extendClass.tieBreakp2, 1, "Player 2's tie-break score should increment in tie-break mode.")
    }

    func testPlayer1ScoreRegular() {
        let game = Game()
        
        game.extendClass.pointScore = 0
        XCTAssertEqual(game.player1Score(), "0")

        game.extendClass.pointScore = 1
        XCTAssertEqual(game.player1Score(), "15")

        game.extendClass.pointScore = 2
        XCTAssertEqual(game.player1Score(), "30")

        game.extendClass.pointScore = 3
        XCTAssertEqual(game.player1Score(), "40")

        game.extendClass.pointScore = 4
        game.extendClass.pointScore2 = 3
        XCTAssertEqual(game.player1Score(), "A", "Player 1 should have advantage.")
    }

    func testPlayer1ScoreTieBreak() {
        let game = Game()
        
        game.extendClass.tieBreak = true
        game.extendClass.tieBreakp1 = 5
        XCTAssertEqual(game.player1Score(), "5", "Tie-break score should be numeric.")
    }

    func testPlayer2ScoreRegular() {
        let game = Game()
        
        game.extendClass.pointScore2 = 0
        XCTAssertEqual(game.player2Score(), "0")

        game.extendClass.pointScore2 = 1
        XCTAssertEqual(game.player2Score(), "15")

        game.extendClass.pointScore2 = 2
        XCTAssertEqual(game.player2Score(), "30")

        game.extendClass.pointScore2 = 3
        XCTAssertEqual(game.player2Score(), "40")

        game.extendClass.pointScore2 = 4
        game.extendClass.pointScore = 3
        XCTAssertEqual(game.player2Score(), "A", "Player 2 should have advantage.")
    }

    func testPlayer2ScoreTieBreak() {
        let game = Game()
        
        game.extendClass.tieBreak = true
        game.extendClass.tieBreakp2 = 6
        XCTAssertEqual(game.player2Score(), "6", "Tie-break score should be numeric.")
    }

    func testPlayer1WonRegularGame() {
        let game = Game()
        
        game.extendClass.pointScore = 4
        game.extendClass.pointScore2 = 2
        XCTAssertTrue(game.player1Won(), "Player 1 should win if ahead by at least 2 points with 4+ points.")
    }

    func testPlayer1WonTieBreak() {
        let game = Game()
        
        game.extendClass.tieBreak = true
        game.extendClass.tieBreakp1 = 7
        game.extendClass.tieBreakp2 = 5
        XCTAssertTrue(game.player1Won(), "Player 1 should win tie-break if ahead by at least 2 points with 7+.")
    }

    func testPlayer2WonRegularGame() {
        let game = Game()
        
        game.extendClass.pointScore2 = 4
        game.extendClass.pointScore = 2
        XCTAssertTrue(game.player2Won(), "Player 2 should win if ahead by at least 2 points with 4+ points.")
    }

    func testPlayer2WonTieBreak() {
        let game = Game()
        
        game.extendClass.tieBreak = true
        game.extendClass.tieBreakp2 = 8
        game.extendClass.tieBreakp1 = 6
        XCTAssertTrue(game.player2Won(), "Player 2 should win tie-break if ahead by at least 2 points with 7+.")
    }

    func testGameCompletion() {
        let game = Game()
        
        game.extendClass.pointScore = 3
        game.extendClass.pointScore2 = 3
        XCTAssertFalse(game.complete(), "Game should not be complete at 3-3.")

        game.extendClass.pointScore = 4
        XCTAssertTrue(game.complete(), "Game should be complete if a player reaches 4 points.")
    }

    func testGamePointsForPlayer1() {
        let game = Game()
        
        game.extendClass.pointScore = 3
        game.extendClass.pointScore2 = 0
        XCTAssertEqual(game.gamePointsForPlayer1(), 3, "Player 2 needs 3 points to equalize.")

        game.extendClass.pointScore2 = 2
        XCTAssertEqual(game.gamePointsForPlayer1(), 1, "Player 2 needs 1 point to equalize.")

        game.extendClass.pointScore = 4
        game.extendClass.pointScore2 = 3
        XCTAssertEqual(game.gamePointsForPlayer1(), 1, "Player 2 needs 1 point to equalize at deuce.")
    }

    func testGamePointsForPlayer2() {
        let game = Game()
        
        game.extendClass.pointScore2 = 3
        game.extendClass.pointScore = 0
        XCTAssertEqual(game.gamePointsForPlayer2(), 3, "Player 1 needs 3 points to equalize.")

        game.extendClass.pointScore = 2
        XCTAssertEqual(game.gamePointsForPlayer2(), 1, "Player 1 needs 1 point to equalize.")

        game.extendClass.pointScore2 = 4
        game.extendClass.pointScore = 3
        XCTAssertEqual(game.gamePointsForPlayer2(), 1, "Player 1 needs 1 point to equalize at deuce.")
    }
    
    func testPlayer1WinsWithTwoPointLead() {
        let game = Game()

        game.extendClass.pointScore = 5
        game.extendClass.pointScore2 = 3

        XCTAssertTrue(game.player1Won(), "Player 1 should win with a two-point lead at 5-3.")
    }

    func testPlayer2WinsWithTwoPointLead() {
        let game = Game()

        game.extendClass.pointScore2 = 6
        game.extendClass.pointScore = 4

        XCTAssertTrue(game.player2Won(), "Player 2 should win with a two-point lead at 6-4.")
    }

    func testPlayer1AdvantageNotWin() {
        let game = Game()

        game.extendClass.pointScore = 4
        game.extendClass.pointScore2 = 3

        XCTAssertFalse(game.player1Won(), "Player 1 should not win at advantage (4-3).")
    }

    func testPlayer2AdvantageNotWin() {
        let game = Game()

        game.extendClass.pointScore2 = 4
        game.extendClass.pointScore = 3

        XCTAssertFalse(game.player2Won(), "Player 2 should not win at advantage (4-3).")
    }

    func testInitialValues() {
            XCTAssertEqual(extendedClass.pointScore, 0)
            XCTAssertEqual(extendedClass.pointScore2, 0)
            XCTAssertEqual(extendedClass.tieBreak, false)
            XCTAssertEqual(extendedClass.currentServe, 0)
        }

        func testDeuceTrue() {
            extendedClass.pointScore = 3
            extendedClass.pointScore2 = 3
            XCTAssertTrue(extendedClass.duce(), "Should be deuce at 3-3.")
        }

        func testDeuceFalse() {
            extendedClass.pointScore = 4
            extendedClass.pointScore2 = 2
            XCTAssertFalse(extendedClass.duce(), "Should not be deuce when scores differ by more than 1.")
        }

        func testPlayer1Score() {
            extendedClass.pointScore = 0
            XCTAssertEqual(extendedClass.playerScore(), 0)
            extendedClass.pointScore = 1
            XCTAssertEqual(extendedClass.playerScore(), 15)
            extendedClass.pointScore = 2
            XCTAssertEqual(extendedClass.playerScore(), 30)
            extendedClass.pointScore = 3
            XCTAssertEqual(extendedClass.playerScore(), 40)
            extendedClass.pointScore = 4
            XCTAssertEqual(extendedClass.playerScore(), 40)
        }

        func testPlayer2Score() {
            extendedClass.pointScore2 = 0
            XCTAssertEqual(extendedClass.player2Score(), 0)
            extendedClass.pointScore2 = 1
            XCTAssertEqual(extendedClass.player2Score(), 15)
            extendedClass.pointScore2 = 2
            XCTAssertEqual(extendedClass.player2Score(), 30)
            extendedClass.pointScore2 = 3
            XCTAssertEqual(extendedClass.player2Score(), 40)
            extendedClass.pointScore2 = 4
            XCTAssertEqual(extendedClass.player2Score(), 40)
        }

        func ttestTieBreakActivation() {
            extendedClass.tieBreak = true
            extendedClass.tieBreakp1 = 5
            extendedClass.tieBreakp2 = 6
            XCTAssertTrue(extendedClass.tieBreak)
        }

        func testCurrentServeUpdates() {
            extendedClass.currentServe = 1
            XCTAssertEqual(extendedClass.currentServe, 1)
            extendedClass.currentServe = 2
            XCTAssertEqual(extendedClass.currentServe, 2)
        }

        func testSetScoreUpdate() {
            extendedClass.setplayer1 = 2
            extendedClass.setplayer2 = 1
            XCTAssertEqual(extendedClass.setplayer1, 2)
            XCTAssertEqual(extendedClass.setplayer2, 1)
        }

        func testGameScoreUpdate() {
            extendedClass.gamep1 = 3
            extendedClass.gamep2 = 4
            XCTAssertEqual(extendedClass.gamep1, 3)
            XCTAssertEqual(extendedClass.gamep2, 4)
        }

        func testTieBreakServer() {
            extendedClass.tieBreakserver = 2
            XCTAssertEqual(extendedClass.tieBreakserver, 2)
            extendedClass.tieBreakserver = 1
            XCTAssertEqual(extendedClass.tieBreakserver, 1)
        }

        func testPointsCountUpdate() {
            extendedClass.pointsCount = 5
            XCTAssertEqual(extendedClass.pointsCount, 5)
            extendedClass.pointsCount += 1
            XCTAssertEqual(extendedClass.pointsCount, 6)
        }

        func testRecentSound() {
            extendedClass.recentSound = 3
            XCTAssertEqual(extendedClass.recentSound, 3)
            extendedClass.recentSound = 5
            XCTAssertEqual(extendedClass.recentSound, 5)
        }

        func testTotalGamePoint() {
            extendedClass.totalGamePoint = 7
            XCTAssertEqual(extendedClass.totalGamePoint, 7)
        }
    
    func testStartClear_WhenGameIsZero() {
        viewController.game.extendClass.gamep1 = 0
        viewController.game.extendClass.gamep2 = 0

        viewController.startClear()

        XCTAssertEqual(viewController.p1GamesLabel.backgroundColor, UIColor.clear)
        XCTAssertEqual(viewController.p2GamesLabel.backgroundColor, UIColor.clear)
    }

    
   

    func ttestStartClear_WhenGameIsZero() {
        viewController.game.extendClass.gamep1 = 0
        viewController.game.extendClass.gamep2 = 0

        viewController.startClear()

        XCTAssertEqual(viewController.p1GamesLabel.backgroundColor, UIColor.clear)
        XCTAssertEqual(viewController.p2GamesLabel.backgroundColor, UIColor.clear)
    }
    
    func testPlayer1Wins_RegularGame() {
        game.extendClass.pointScore = 3
        game.extendClass.pointScore2 = 2
        game.extendClass.gamep1 = 4
        game.extendClass.gamep2 = 2

        game.addPointToPlayer1() // Simulate win
        viewController.player1Wins()

        XCTAssertEqual(game.extendClass.pointScore, 0)
        XCTAssertEqual(game.extendClass.pointScore2, 0)
        XCTAssertEqual(game.extendClass.gamep1, 5)
        XCTAssertEqual(viewController.p1GamesLabel.text, "\(game.extendClass.gamep1)")
    }

    func testPlayer1Wins_WinsSet() {
        game.extendClass.pointScore = 3
        game.extendClass.pointScore2 = 2
        game.extendClass.gamep1 = 5 // Already at 5 games
        game.extendClass.gamep2 = 3

        game.addPointToPlayer1() // Simulate win
        viewController.player1Wins()

        XCTAssertEqual(game.extendClass.gamep1, 0)
        XCTAssertEqual(game.extendClass.gamep2, 0)
        XCTAssertEqual(game.extendClass.setplayer1, 1)
        XCTAssertEqual(viewController.p1SetsLabel.text, "\(game.extendClass.setplayer1)")
        XCTAssertEqual(viewController.p1GamesLabel.text, "0")
        XCTAssertEqual(viewController.p2GamesLabel.text, "0")
    }

    func testPlayer2Wins_LeadingGame() {
        game.extendClass.pointScore = 1  // 15
        game.extendClass.pointScore2 = 3  // 40

        game.addPointToPlayer2()  // Wins the game
        viewController.player2Wins()

        XCTAssertEqual(game.extendClass.pointScore, 0, "Player 1's score should reset")
        XCTAssertEqual(game.extendClass.pointScore2, 0, "Player 2's score should reset")
        XCTAssertEqual(game.extendClass.gamep2, 1, "Player 2's game count should increase")
    }
   
}

