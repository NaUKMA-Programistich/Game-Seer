import Foundation
import UIKit

class GamesService {
    static let shared: GamesService = .init()

    private let coreML = CoreMLService()
    private var session = URLSession.shared
    private let decoder = JSONDecoder()

    private let steamUrl = "https://store.steampowered.com/api/appdetails?appids="

    private var fixedMap: [String:String] = [:]

    init() {
        fixedMap.updateValue("271590", forKey: "362003")
        fixedMap.updateValue("397540", forKey: "8950")
    }

    func processImage(image: Data?, onResult: @escaping (Game) -> Void) {
        guard
            let data = image,
            let uiImage = UIImage(data: data)
        else { return }

        coreML.process(image: uiImage) { [self] dict in
            guard let result = dict
                .sorted(by: { $0.value > $1.value })
                .filter({ !$0.key.starts(with: "Lost Ark")  })
                .first
            else { return }
            processML(data: result) { game in
                onResult(game)
            }
        }
    }

    private func processML(data: (key: String, value: Float), onResult: @escaping (Game) -> Void) {
        let gameID = String(data.key.split(separator: "||")[1])
        let fixedGameId = fixedMap[gameID] ?? gameID

        getGameDetails(gameId: String(fixedGameId)) { gameDTO in
            let game = Game(
                name: gameDTO.name,
                id: gameDTO.id,
                description: gameDTO.shortDescription,
                percentage: String(data.value),
                platforms: gameDTO.platforms,
                languages: gameDTO.languagesWithoutTags,
                screenshots: gameDTO.screenshots
            )
            onResult(game)
        }
    }



    private func getGameDetails(gameId: String, onResult: @escaping (GameDto) -> Void) {
        guard let url = URL(string: steamUrl + gameId + "&l=english") else {
            print("Bad url")
            return
        }

        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Bad data")
                return
            }
            do {
                let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard
                    let gameData = decodedData?[gameId] as? [String: Any],
                    let gameInfo = gameData["data"] as? [String: Any],
                    let gameDto = GameDto(from: gameInfo)
                else { return }
                onResult(gameDto)
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

}


extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
