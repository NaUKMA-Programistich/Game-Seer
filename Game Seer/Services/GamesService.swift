import Foundation
import UIKit

class GamesService {
    static let shared: GamesService = .init()

    private let coreML = CoreMLService()
    private var session = URLSession.shared
    private let decoder = JSONDecoder()

    private let STEAM_URL = "https://store.steampowered.com/api/appdetails?appids="

    func processImage(image: Data?, onResult: @escaping (Game) -> Void) {
        guard
            let data = image,
            let uiImage = UIImage(data: data)
        else { return }

        coreML.process(image: uiImage) { [self] dict in
            guard let result = dict.sorted(by: { $0.value > $1.value }).first else { return }
            processML(data: result) { gameDto in
                let game = Game(
                    name: gameDto.name,
                    id: gameDto.id,
                    description: gameDto.description,
                    percentage: String(result.value),
                    platforms: gameDto.platforms,
                    languages: gameDto.languages.withoutTags
                )
                print(game)
                onResult(game)
            }
        }
    }

    private func processML(data: (key: String, value: Float), onResult: @escaping (Game) -> Void) {
        let gameID = data.key.split(separator: "||")[1]
        getGameDetails(gameId: String(gameID)) { gameDTO in
            let game = Game(
                name: gameDTO.name,
                id: gameDTO.id,
                description: gameDTO.shortDescription,
                percentage: String(data.value),
                platforms: gameDTO.platforms,
                languages: gameDTO.languages.withoutTags
            )
            onResult(game)
        }
    }



    private func getGameDetails(gameId: String, onResult: @escaping (GameDto) -> Void) {
        guard let url = URL(string: STEAM_URL + gameId + "&l=english") else {
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

extension String{
    public var withoutTags: String{
        let pattern = "<[^>]+>"
        var str = self.filter{$0 != "*"}.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        str = str.replacingOccurrences(of: "languages with full audio support", with: "")
        return str
    }
}
