import UIKit

class MatchHistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let history = loadMatchHistory()
        
        let historyText = history.matches.map { match in
            return "\(match.date)\n\(match.player1) vs \(match.player2) - \(match.score)\n"
        }.joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.historyTextView?.text = historyText.isEmpty ? "No match history available." : historyText
        }
    }
}

