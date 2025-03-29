import XCTest

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
    
    func testRegularServeGamep1(){
        
        viewController.game.extendClass.gamep1 = 3
        viewController.game.extendClass.gamep2 = 2
        viewController.serve()
        
        
        XCTAssertEqual(viewController.game.extendClass.tieBreakserver,2)
    }
    
    func testRegularServeGamep2(){
        
        viewController.game.extendClass.gamep1 = 2
        viewController.game.extendClass.gamep2 = 2
        viewController.serve()
        
        
        XCTAssertEqual(viewController.game.extendClass.tieBreakserver,1)
    }
    
    
    
    func testTieBreakServe (){
        
        viewController.game.extendClass.tieBreak = true
        viewController.game.extendClass.tieBreakp1 = 2
        viewController.game.extendClass.tieBreakp2 = 1
        viewController.serve()
        
        XCTAssertEqual(viewController.game.extendClass.tieBreakserver, 1)
        
        
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
    
    func testTieBreakSwitch(){
        viewController.game.extendClass.tieBreak = true
        viewController.game.extendClass.tieBreakp1 = 2
        viewController.game.extendClass.tieBreakp2 = 2

        viewController.serve()
        
        
        XCTAssertEqual(viewController.game.extendClass.tieBreakserver, 1, "Server should switch after 2 points")
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

