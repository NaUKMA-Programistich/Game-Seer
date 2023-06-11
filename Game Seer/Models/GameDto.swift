import Foundation

struct GameDto: Codable {
    let name: String
    let id: Int
    let shortDescription: String
    let platforms: [String: Bool]
    let languages: String

    init?(from dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        guard let id = dictionary["steam_appid"] as? Int else { return nil }
        guard let shortDescription = dictionary["short_description"] as? String else { return nil }
        guard let platforms = dictionary["platforms"] as? [String: Bool] else { return nil}
        guard let languages = dictionary["supported_languages"] as? String else { return nil }

        self.name = name
        self.id = id
        self.shortDescription = shortDescription
        self.platforms = platforms
        self.languages = languages
    }

    var languagesWithoutTags: String {
        let pattern = "<[^>]+>"
        var str = languages.filter{$0 != "*"}.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        str = str.replacingOccurrences(of: "languages with full audio support", with: "")
        return str
    }
}
