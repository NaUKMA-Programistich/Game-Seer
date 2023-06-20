import Foundation

struct Game: Codable {
    let name: String
    let id: Int
    let description: String
    let percentage: String
    let platforms: [String: Bool]
    let languages: String
    let screenshots: [Screenshot]
}
