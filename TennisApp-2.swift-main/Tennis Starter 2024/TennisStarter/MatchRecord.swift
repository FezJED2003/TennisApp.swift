import Foundation

struct MatchRecord: Codable {
    let date: String
    let player1: String
    let player2: String
    let score: String
}

struct MatchHistory: Codable {
    var matches: [MatchRecord]
}

func getFilePath() -> URL? {
    if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentURL.appendingPathComponent("TennisHistory.txt")
        
        print("File path: \(fileURL.path)")
        
        return fileURL
    }
    return nil
}




// code adapted from My CMS, 2023

func saveMatchHistory(history: MatchHistory) {
    guard let fileURL = getFilePath() else {
        print(" No file path found.")
        return
    }

    do {
        let jsonData = try JSONEncoder().encode(history)
        try jsonData.write(to: fileURL, options: .atomic)

        //  Confirm that the data was saved
        print(" Match history has been saved.")
        
    } catch {
        print(" Error saving match history: \(error.localizedDescription)")
    }
}
// end of adapted code
func loadMatchHistory() -> MatchHistory {
    guard let fileURL = getFilePath() else {
        print(" No file path found.")
        return MatchHistory(matches: [])
    }

    do {
        let jsonData = try Data(contentsOf: fileURL)
        
        //  Print file contents before decoding
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(" Reading from file:\n\(jsonString)")
        }

        let history = try JSONDecoder().decode(MatchHistory.self, from: jsonData)
        return history

    } catch {
        print(" Error loading match history: \(error.localizedDescription)")
    }

    return MatchHistory(matches: [])
}
// code adapted from near point 2015
func addMatchToHistory(player1: String, player2: String, score: String) {
    var history = loadMatchHistory()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentDate = formatter.string(from: Date())
// end of adapted code
    let newMatch = MatchRecord(date: currentDate, player1: player1, player2: player2, score: score)
    history.matches.append(newMatch)

    //  Save the updated match history
    saveMatchHistory(history: history)
}
