import Foundation

struct GameDto: Codable {
    let name: String
    let shortDescription: String

    init?(from dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        guard let shortDescription = dictionary["short_description"] as? String else { return nil }

        self.name = name
        self.shortDescription = shortDescription
    }
}
