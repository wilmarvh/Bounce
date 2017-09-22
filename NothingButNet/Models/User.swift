import Foundation

public struct User: Codable {
    var avatar_url: String
    var bio: String
    var buckets_count: Int
    var buckets_url: String
    var can_upload_shot: Bool
    var comments_received_count: Int
    var created_at: Date
    var followers_count: Int
    var followers_url: String
    var following_url: String
    var followings_count: Int
    var html_url: String
    var id: Int
    var likes_count: Int
    var likes_received_count: Int
    var likes_url: String
    var links: Links
    var location: String
    var name: String
    var pro: Bool
    var projects_count: Int
    var projects_url: String
    var rebounds_received_count: Int
    var shots_count: Int
    var shots_url: String
    var teams_count: Int?
    var teams_url: String?
    var type: String
    var updated_at: Date
    var username: String
    
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
        let task = NothingBut.Net.session.dataTask(with: url) { data, urlResponse, error in
            NothingBut.Net.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingBut.Net.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
    public static func fetch(with username: String, completion: @escaping (User?, Error?) -> Void) {
        let url = API.users(username).asURL()
        let task = NothingBut.Net.session.dataTask(with: url) { data, urlResponse, error in
            NothingBut.Net.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let user = User.new(from: data)
            DispatchQueue.main.async {
                completion(user, error)
            }
        }
        
        NothingBut.Net.setNetworkActivityIndicatorVisible(true)
        task.resume()
    }
    
}
