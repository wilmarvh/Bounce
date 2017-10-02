import Foundation

public struct User: Decodable {
    var avatar_url: String
    public var avatarURL: URL = dribbbleURL
    public var bio: String
    public var buckets_count: Int
    public var buckets_url: String
    public var can_upload_shot: Bool
    public var comments_received_count: Int
    public var created_at: Date
    public var followers_count: Int
    public var followers_url: String
    public var following_url: String
    public var followings_count: Int
    public var html_url: String
    public var id: Int
    public var likes_count: Int
    public var likes_received_count: Int
    public var likes_url: String
    public var links: Links
    public var location: String?
    public var name: String
    public var pro: Bool
    public var projects_count: Int
    public var projects_url: String
    public var rebounds_received_count: Int
    public var shots_count: Int
    public var shots_url: String
    public var teams_count: Int?
    public var teams_url: String?
    public var type: String
    public var updated_at: Date
    public var username: String

    static func new(from data: Data) -> User? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            var user = try decoder.decode(User.self, from: data)
            user.avatarURL = URL(string: user.avatar_url)!
            return user
        } catch let error {
            debugPrint("\(error)")
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case avatar_url
        case bio
        case buckets_count
        case buckets_url
        case can_upload_shot
        case comments_received_count
        case created_at
        case followers_count
        case followers_url
        case following_url
        case followings_count
        case html_url
        case id
        case likes_count
        case likes_received_count
        case likes_url
        case links
        case location
        case name
        case pro
        case projects_count
        case projects_url
        case rebounds_received_count
        case shots_count
        case shots_url
        case teams_count
        case teams_url
        case type
        case updated_at
        case username
    }
}


extension User {
    
    public static func fetchCurrent(completion: @escaping (User?, Error?) -> Void) {
        let url = API.user.asURL()
        let task = NothingBut.Net.dataTask(with: url) { data, urlResponse, error in
            NothingBut.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingBut.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
    public static func fetch(with username: String, completion: @escaping (User?, Error?) -> Void) {
        let url = API.users(username).asURL()
        let task = NothingBut.Net.dataTask(with: url) { data, urlResponse, error in
            NothingBut.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingBut.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
    mutating func createURLs() {
        if let url = URL(string: avatar_url) {
            avatarURL = url
        }
    }
    
}
