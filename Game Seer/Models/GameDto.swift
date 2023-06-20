import Foundation

struct GameDto: Codable {
    let name: String
    let id: Int
    let shortDescription: String
    let platforms: [String: Bool]
    let languages: String
    let screenshots: [Screenshot]

    init?(from dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        guard let id = dictionary["steam_appid"] as? Int else { return nil }
        guard let shortDescription = dictionary["short_description"] as? String else { return nil }
        guard let platforms = dictionary["platforms"] as? [String: Bool] else { return nil}
        guard let languages = dictionary["supported_languages"] as? String else { return nil }
        guard let screenshotsData = dictionary["screenshots"] as? [[String: Any]] else { return nil }
        
        var screenshots: [Screenshot] = []
        for screenshotData in screenshotsData {
            if let screenshot = Screenshot(from: screenshotData) {
                screenshots.append(screenshot)
            }
        }
        
        self.name = name
        self.id = id
        self.shortDescription = shortDescription
        self.platforms = platforms
        self.languages = languages
        self.screenshots = screenshots
    }

    var languagesWithoutTags: String {
        let pattern = "<[^>]+>"
        var str = languages.filter{$0 != "*"}.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        str = str.replacingOccurrences(of: "languages with full audio support", with: "")
        return str
    }
}
struct Screenshot: Codable, Identifiable{
    let id: Int
    let pathThumbnail: String
    let pathFull: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case pathThumbnail = "path_thumbnail"
        case pathFull = "path_full"
    }
    init?(from dictionary: [String: Any]) {
            guard let id = dictionary["id"] as? Int else { return nil }
            guard let pathThumbnail = dictionary["path_thumbnail"] as? String else { return nil }
            guard let pathFull = dictionary["path_full"] as? String else { return nil }
            
            self.id = id
            self.pathThumbnail = pathThumbnail
            self.pathFull = pathFull
    }
}
