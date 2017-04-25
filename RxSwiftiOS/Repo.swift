import Foundation

struct Repo {
    let id: Int
    let name: String
    let username: String?
    let language: String

    init?(object: [String: Any]) {
        guard let id = object["id"] as? Int,
            let name = object["name"] as? String,
            let fullName = object["full_name"] as? String,
            let language = object["language"] as? String else { return nil }
        self.id = id
        self.name = name
        self.language = language
        self.username = fullName.components(separatedBy: "/")[0]
    }

    init(_ id: Int, _ name: String, _ language: String) {
        self.id = id
        self.name = name
        self.language = language
        self.username = ""
    }

    init(_ id: Int, _ name: String, _ language: String, _ username: String) {
        self.id = id
        self.name = name
        self.language = language
        self.username = username
    }
}
