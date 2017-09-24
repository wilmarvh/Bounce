import Foundation

public struct User: Codable {
    public var avatar_url: String
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
        let user = try? decoder.decode(User.self, from: data)
        return user
    }
}


extension User {
    
    public static func fetchCurrent(completion: @escaping (User?, Error?) -> Void) {
        let url = API.user.asURL()
        let task = NothingButNet.session.dataTask(with: url) { data, urlResponse, error in
            NothingButNet.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingButNet.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
    public static func fetch(with username: String, completion: @escaping (User?, Error?) -> Void) {
        let url = API.users(username).asURL()
        let task = NothingButNet.session.dataTask(with: url) { data, urlResponse, error in
            NothingButNet.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingButNet.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
}
