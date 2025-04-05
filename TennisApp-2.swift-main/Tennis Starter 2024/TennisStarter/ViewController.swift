import UIKit
import AVFoundation
import SwiftUI
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    var game = Game()
    var extendClass = ExtendedClass()
    var logic: GameLogic!
    let calenderManager = CalendarManager ()
    
    var audio: AVAudioPlayer?
    let locationManager = CLLocationManager()
    var locationUser : CLLocation?
    
    let matchLocation = CLLocation(latitude:51.5074 , longitude: -0.1278)
    let currentMatch = CLLocation (latitude: 40.748750, longitude: -73.843638)
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUser = location
        updateDistance()

        // Get user's current location
        getCityAndCountry(for: location) { userLocationName in
            DispatchQueue.main.async {
                self.LocationFrom.text = "You are in \(userLocationName ?? "Unknown Location")"
            }
        }

        // Get current match location
        getCityAndCountry(for: currentMatch) { matchLocationName in
            DispatchQueue.main.async {
                self.currentMatchLabel.text = "Current Match: \(matchLocationName ?? "Unknown Location")"
            }
        }

        // Get future match location (London match in this case)
        getCityAndCountry(for: matchLocation) { futureMatchLocationName in
            DispatchQueue.main.async {
                self.locationLabel.text = "Future Match: \(futureMatchLocationName ?? "Unknown Location")"
            }
        }
    }

        func updateDistance() {
            guard let userLoc = locationUser else { return }
            
            let distanceToMatch = userLoc.distance(from: matchLocation) / 1000
            DispatchQueue.main.async {
                self.locationLabel.text = "London Match: \(String(format: "%.2f", distanceToMatch)) km away"
            }
        }
        
        func getCityAndCountry(for location: CLLocation, completion: @escaping (String?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    completion(nil)
                    return
                }
                
                let city = placemark.locality ?? "Unknown City"
                let country = placemark.country ?? "Unknown Country"
                completion("\(city), \(country)")
            }
        }
    
    
    
    
    
    
    
    @IBOutlet weak var currentMatchLabel: UILabel!
    @IBOutlet weak var LocationFrom: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p1NameLabel: UILabel!
    @IBOutlet weak var p2NameLabel: UILabel!
    
    @IBOutlet weak var p1PointsLabel: UILabel!
    @IBOutlet weak var p2PointsLabel: UILabel!
    
    @IBOutlet weak var p1GamesLabel: UILabel!
    @IBOutlet weak var p2GamesLabel: UILabel!
    
    @IBOutlet weak var p1SetsLabel: UILabel!
    @IBOutlet weak var p2SetsLabel: UILabel!
    
    @IBOutlet weak var p1PreviousSetsLabel: UILabel!
    @IBOutlet weak var p2PreviousSetsLabel: UILabel!
    
    
    var secondWindow: UIWindow?
    var secondWindowView: UIView?
    
    
    
    func player1Wins() {
        if game.player1Won() {
            if game.extendClass.tieBreak {
                game.extendClass.setplayer1 += 1
                game.extendClass.pointsCount += game.extendClass.gamep1 + game.extendClass.gamep2 + 1
                p1SetsLabel.text = "\(game.extendClass.setplayer1)"
                
                game.extendClass.gamep1 = 0
                game.extendClass.gamep2 = 0
                game.extendClass.tieBreakp1 = 0
                game.extendClass.tieBreakp2 = 0
                
                p1GamesLabel.text = "0"
                p2GamesLabel.text = "0"
                p1PointsLabel.text = "0"
                p2PointsLabel.text = "0"
                logic.serve()
                serverUpdate()
                
                game.extendClass.tieBreak = false
            } else {
                game.extendClass.pointScore = 0
                game.extendClass.pointScore2 = 0
                game.extendClass.gamep1 += 1
                p1GamesLabel.text = "\(game.extendClass.gamep1)"
                
                // Check for game win condition
                if game.extendClass.gamep1 >= 6 && (game.extendClass.gamep1 - game.extendClass.gamep2) >= 2 {
                    game.extendClass.pointsCount += game.extendClass.gamep1 + game.extendClass.gamep2
                    game.extendClass.gamep1 = 0
                    game.extendClass.gamep2 = 0
                    game.extendClass.setplayer1 += 1
                    p1SetsLabel.text = "\(game.extendClass.setplayer1)"
                    p1GamesLabel.text = "0"
                    p2GamesLabel.text = "0"
                    saveMatchHistory()
                    
                    let nextMatchDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        let calendarManager = CalendarManager()

                        let player1 = p1NameLabel.text ?? "Player 1"
                        let player2 = p2NameLabel.text ?? "Player 2"

                        calendarManager.scheduleMatch(
                            title: "Next Match: (player1) vs (player2)",
                            date: nextMatchDate,
                            on: self
                        )
                    }
                
                // Start tiebreak if the game reaches 6-6
                if game.extendClass.setplayer1 == 6 && game.extendClass.setplayer2 == 6 {
                    game.extendClass.tieBreak = true
                    p1PointsLabel.text = "0"
                    p2PointsLabel.text = "0"
                }
            }
            pointUpdateUI()
        }
    }
    
    func player2Wins() {
        if game.player2Won() {
            if game.extendClass.tieBreak {
                game.extendClass.setplayer2 += 1
                game.extendClass.pointsCount += game.extendClass.gamep1 + game.extendClass.gamep2 + 1
                p2SetsLabel.text = "\(game.extendClass.setplayer2)"
                
                game.extendClass.gamep1 = 0
                game.extendClass.gamep2 = 0
                game.extendClass.tieBreakp1 = 0
                game.extendClass.tieBreakp2 = 0
                
                p1GamesLabel.text = "0"
                p2GamesLabel.text = "0"
                p1PointsLabel.text = "0"
                p2PointsLabel.text = "0"
                logic.serve()
                serverUpdate()
                game.extendClass.tieBreak = false
            } else {
                game.extendClass.pointScore = 0
                game.extendClass.pointScore2 = 0
                game.extendClass.gamep2 += 1
                p2GamesLabel.text = "\(game.extendClass.gamep2)"
                
                // Check for game win condition
                if game.extendClass.gamep2 >= 6 && (game.extendClass.gamep2 - game.extendClass.gamep1) >= 2 {
                    game.extendClass.pointsCount += game.extendClass.gamep1 + game.extendClass.gamep2
                    game.extendClass.gamep1 = 0
                    game.extendClass.gamep2 = 0
                    game.extendClass.setplayer2 += 1
                    p2SetsLabel.text = "\(game.extendClass.setplayer2)"
                    p1GamesLabel.text = "0"
                    p2GamesLabel.text = "0"
                    saveMatchHistory()
                    let nextMatchDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        let calendarManager = CalendarManager()

                        let player1 = p1NameLabel.text ?? "Player 1"
                        let player2 = p2NameLabel.text ?? "Player 2"

                        calendarManager.scheduleMatch(
                            title: "Next Match: (player1) vs (player2)",
                            date: nextMatchDate,
                            on: self
                        )
                }
            }
            pointUpdateUI()
        }
    }
    func saveMatchHistory() {
        let player1 = p1NameLabel.text ?? "Player 1"
        let player2 = p2NameLabel.text ?? "Player 2"
        let score = "\(game.extendClass.setplayer1) - \(game.extendClass.setplayer2)"
        
        var locationText = "Unknown Location"
        
        if let userLoc = locationUser {
            getCityAndCountry(for: userLoc) { userLocationName in
                locationText = userLocationName ?? "Unknown Location"
                let matchInfo = "\(player1) vs \(player2) - \(score) (\(locationText))"
                addMatchToHistory(player1: player1, player2: player2, score: matchInfo)
                self.scheduleNextMatch(player1: player1, player2: player2)
            }
        } else {
            let matchInfo = "\(player1) vs \(player2) - \(score)"
            addMatchToHistory(player1: player1, player2: player2, score: matchInfo)
            let nextMatchDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            calenderManager.scheduleMatch(title: "Next Match: (player1) vs (player2)", date: nextMatchDate, on: self)
            scheduleNextMatch(player1: player1, player2: player2)
        }
    }
    
    
    func scheduleNextMatch(player1: String, player2: String) {
        let nextMatchDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let matchTitle = "Next Match: (player1) vs (player2)"
        calenderManager.scheduleMatch(title: matchTitle, date: nextMatchDate, on: self)

        let alert = UIAlertController(title: "Next Match Scheduled", message: "A match has been added to your calendar for tomorrow.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    let nextMatchDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    let calendarManager = CalendarManager()


    
    
    
    func startClear () {
        
        if game.extendClass.gamep1 == 0 || game.extendClass.gamep2 == 0{
            p1GamesLabel.backgroundColor = UIColor.clear
            p2GamesLabel.backgroundColor = UIColor.clear
        } else if game.extendClass.setplayer1 == 0 || game.extendClass.setplayer2 == 0{
            p1SetsLabel.backgroundColor = UIColor.clear
            p2SetsLabel.backgroundColor = UIColor.clear
            
        } else if game.extendClass.pointScore == 0 || game.extendClass.pointScore2 == 0{
            p1PointsLabel.backgroundColor = UIColor.clear
            p2PointsLabel.backgroundColor = UIColor.clear
            
        }
        
        
        
    }
    
    
    func checkGreen () {
        startClear()
        
        if game.extendClass.setplayer1 >= 1 || game.extendClass.setplayer2 >= 1{
            if game.extendClass.setplayer1 > game.extendClass.setplayer2{
                
                p1SetsLabel.backgroundColor = UIColor.green
                p2SetsLabel.backgroundColor = UIColor.clear
                
            } else if game.extendClass.setplayer1 == game.extendClass.setplayer2{
                
                p2SetsLabel.backgroundColor = UIColor.clear
                p1SetsLabel.backgroundColor = UIColor.clear
                
            } else {
                p1SetsLabel.backgroundColor = UIColor.clear
                p2SetsLabel.backgroundColor = UIColor.green
                
            }
            
            
        }
        
        if game.extendClass.gamep1 >= 1 || game.extendClass.gamep2 >= 1{
            if game.extendClass.gamep1 > game.extendClass.gamep2{
                p1GamesLabel.backgroundColor = UIColor.green
                p2GamesLabel.backgroundColor = UIColor.clear
                
            } else if game.extendClass.gamep1 == game.extendClass.gamep2{
                p2GamesLabel.backgroundColor = UIColor.clear
                p1GamesLabel.backgroundColor = UIColor.clear
                
            } else {
                p1GamesLabel.backgroundColor = UIColor.clear
                p2GamesLabel.backgroundColor = UIColor.green
                
            }
            
        }
        
        if game.extendClass.pointScore >= 1 || game.extendClass.pointScore2 >= 1{
            if game.extendClass.pointScore > game.extendClass.pointScore2{
                p1PointsLabel.backgroundColor = UIColor.green
                p2PointsLabel.backgroundColor = UIColor.clear
                
            } else if game.extendClass.pointScore == game.extendClass.pointScore2{
                p2PointsLabel.backgroundColor = UIColor.clear
                p1PointsLabel.backgroundColor = UIColor.clear
                
            } else if game.extendClass.pointScore < game.extendClass.pointScore2{
                p1PointsLabel.backgroundColor = UIColor.clear
                p2PointsLabel.backgroundColor = UIColor.green
                
            }
            
        }
        
        
        
        
        
        
    }
    
    
    func overridenSets (){
        
        game.extendClass.totalSetsAmount = game.extendClass.setplayer1 + game.extendClass.setplayer2
        
        if game.extendClass.totalSetsAmount > game.extendClass.countSets {
            
            game.extendClass.countSets += 1
            
        }
        
        
    }
    
    
    func wonGame () {
        if game.extendClass.setplayer1 == 3 || game.extendClass.setplayer2  == 3 {
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            
            showWinner()
        }
    }
    
    func showWinner () {
        
        let winner = game.extendClass.setplayer1 > game.extendClass.setplayer2 ? "Player 1" : "Player 2"
        
        
        let alert = UIAlertController(
            title: "Match Over",
            message: "\(winner) wins!",
            preferredStyle: .alert
            
        )
        
        let okAction = UIAlertAction(title:"OK" , style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func sound() {
        guard let sound = Bundle.main.url(forResource: "Sound", withExtension: "wav") else { return }
        
        do {
            audio = try AVAudioPlayer(contentsOf: sound)
            audio?.play()
        } catch {
            print("Error playing sound")
        }
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
  
        
        // Engage notification center
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAdditionalScreen),
            name: UIScene.willConnectNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenDisconnect),
            name: UIScene.didDisconnectNotification,
            object: nil
        )
        logic = GameLogic (game: game , extendClass: extendClass, viewController: self)
    }
     
    @IBAction func buttonPressed(_ sender: UIButton) {
        let screens = UIScreen.screens
        guard screens.count > 1 else {
            print("No external screen detected")
            return
        }
        
        let externalScreen = screens[1]
        setupExternalScreen(externalScreen)
    }
    
    
    
    func setupExternalScreen(_ externalScreen: UIScreen) {
        secondWindow = UIWindow(frame: externalScreen.bounds)
        secondWindow?.screen = externalScreen
        
        let externalScreen = UIStoryboard(name: "Main" , bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        secondWindow?.rootViewController = externalScreen
        
        
        
        
        secondWindow!.isHidden = false
        secondWindow!.makeKeyAndVisible()
        
        secondWindowView!.backgroundColor = .cyan
    }
    
    @objc func handleAdditionalScreen(notification: NSNotification) {
        guard let windowScene = (notification.object as? UIWindowScene) else {return}
        
        guard  windowScene.session.role == .windowExternalDisplayNonInteractive else {return}
        
        secondWindow = UIWindow(windowScene: windowScene)
        
        let viewController = UIViewController()
        
        secondWindow!.rootViewController = viewController
        
        secondWindowView = UIView (frame: secondWindow!.frame)
        
        secondWindow!.addSubview(secondWindowView!)
        
        secondWindow!.isHidden = false
        
        secondWindow!.makeKeyAndVisible()
        
        secondWindowView!.backgroundColor = .cyan
    }
    
    // Handle disconnection
    @objc func handleScreenDisconnect(notification: NSNotification) {
        secondWindow = nil
        secondWindowView = nil
    }
    
    
    
    func ExternalDisplayUpdate () {
        if let screens = secondWindow?.rootViewController as? ViewController{
            
            screens.p1PointsLabel.text = p1PointsLabel.text
            screens.p2PointsLabel.text = p2PointsLabel.text
            screens.p1GamesLabel.text = p1GamesLabel.text
            screens.p2GamesLabel.text = p2GamesLabel.text
            screens.p1SetsLabel.text = p1SetsLabel.text
            screens.p2SetsLabel.text = p2SetsLabel.text
            screens.p1GamesLabel.backgroundColor = p1GamesLabel.backgroundColor
            screens.p2GamesLabel.backgroundColor = p2GamesLabel.backgroundColor
            screens.p1SetsLabel.backgroundColor = p1SetsLabel.backgroundColor
            screens.p2SetsLabel.backgroundColor = p2SetsLabel.backgroundColor
            screens.p1PointsLabel.backgroundColor = p1PointsLabel.backgroundColor
            screens.p2PointsLabel.backgroundColor = p2PointsLabel.backgroundColor
            screens.p1SetsLabel.backgroundColor = p1SetsLabel.backgroundColor
            screens.p2SetsLabel.backgroundColor = p2SetsLabel.backgroundColor
            screens.p1NameLabel.backgroundColor = p1NameLabel.backgroundColor
            screens.p2NameLabel.backgroundColor = p2NameLabel.backgroundColor
            
            
        }
        
        
        
    }
    
    
    
    
    
    func gameWon () {
        logic.serve()
        if game.extendClass.setplayer1 == 3 || game.extendClass.setplayer2 == 3{
            
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            showWinner()
            
        }
        
        
        
    }
    
    func gameRestart () {
        
        p1GamesLabel.text = "0"
        p2GamesLabel.text = "0"
        p1PointsLabel.text = "0"
        p2PointsLabel.text = "0"
        p2NameLabel.backgroundColor = UIColor.clear
        p1NameLabel.backgroundColor = UIColor.clear
        p1SetsLabel.text = "0"
        p2SetsLabel.text = "0"
        p1Button.isEnabled = true
        p2Button.isEnabled = true
        p1GamesLabel.backgroundColor = UIColor.clear
        p2GamesLabel.backgroundColor = UIColor.clear
        p1SetsLabel.backgroundColor = UIColor.clear
        p2SetsLabel.backgroundColor = UIColor.clear
        p1PointsLabel.backgroundColor = UIColor.clear
        p2PointsLabel.backgroundColor = UIColor.clear
        logic.ResetScores()
        
    }
    
    
    
    
    
   
    
    func serverUpdate() {
        if game.extendClass.currentServe == 1 {
            p1NameLabel.backgroundColor = UIColor.purple
            p2NameLabel.backgroundColor = UIColor.clear
        } else {
            p2NameLabel.backgroundColor = UIColor.purple
            p1NameLabel.backgroundColor = UIColor.clear
        }
        
        if game.extendClass.recentSound != game.extendClass.currentServe {
            sound()
        }
    }
    
    
    
    
    
    
    func tieBreakEnabled() {
        
        // Checking if both players have 6 games each, enabling tie-break
        if game.extendClass.gamep1 == 6 && game.extendClass.gamep2 == 6 {
            game.extendClass.tieBreak = true
            p1PointsLabel.text = "0"
            p2PointsLabel.text = "0"
        }
        
        if game.extendClass.tieBreak {
            p1PointsLabel.text = "\(game.extendClass.tieBreakp1)"
            p2PointsLabel.text = "\(game.extendClass.tieBreakp2)"
            logic.serve() // Call the serve function when tie-break is enabled
        } else {
            // Otherwise, display regular points
            p1PointsLabel.text = game.player1Score()
            p2PointsLabel.text = game.player2Score()
        }
    }
    
    
    func isTieBreakEnabled () {
        
        
        if game.extendClass.tieBreak{
            
            
            p1PointsLabel.text = "\(game.extendClass.tieBreakp1)"
            p2PointsLabel.text =  "\(game.extendClass.tieBreakp2)"
        } else{
            
            p1PointsLabel.text = game.player1Score()
            p2PointsLabel.text = game.player2Score()
        }
        
    }
    
    func pointUpdateUI(){
        
        
        tieBreakEnabled()
        isTieBreakEnabled()
        
        
        player1Wins()
        player2Wins()
        serverUpdate()
        overridenSets()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /********Methods*********/
    @IBAction func p1AddPointPressed(_ sender: UIButton) {
        game.addPointToPlayer1()
        serverUpdate()
        pointUpdateUI()
        gameWon()
        wonGame()
        checkGreen()
        ExternalDisplayUpdate()
        sound()
        logic.finalSet()

        
    }
    
    @IBAction func p2AddPointPressed(_ sender: UIButton) {
        game.addPointToPlayer2()
        serverUpdate()
        pointUpdateUI()
        gameWon()
        wonGame()
        checkGreen()
        ExternalDisplayUpdate()
        sound()
        logic.finalSet()

    }
    
    @IBAction func restartPressed(_ sender: AnyObject) {
        gameRestart()
        logic.ResetScores()
        ExternalDisplayUpdate()
        
        
    }
    
    
    
    
    @IBAction func showScreenButton(_ sender: Any) {
        
        
        
        
        
    }
    
    
    @IBAction func showMatchHistory(_ sender: UIButton) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        
        if let matchHistoryVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MatchHistoryViewController") as? MatchHistoryViewController {
            
            navigationController?.pushViewController(matchHistoryVC, animated: true)
        }
        
        
        
    }
    
}

