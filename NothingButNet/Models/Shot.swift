import Foundation

public struct Shot: Decodable {
    public var animated: Bool //": false,
    public var attachments_count: Int //": 0,
    public var attachments_url: String //": "https://api.dribbble.com/v1/shots/3817782/attachments",
    public var buckets_count: Int //": 34,
    public var buckets_url: String //": "https://api.dribbble.com/v1/shots/3817782/buckets",
    public var comments_count: Int //": 8,
    public var comments_url: String //": "https://api.dribbble.com/v1/shots/3817782/comments",
    public var created_at: Date //": "2017-09-19T18:10:49Z",
    public var description: String? //": "<p>Some icons from a recent set.</p>",
    public var height: Int //": 300,
    public var html_url: String //": "https://dribbble.com/shots/3817782-Gretchen-Rubin-Icons",
    public var id: Int //": 3817782,
    public var images: Images
    public var likes_count: Int //": 559,
    public var likes_url: String //": "https://api.dribbble.com/v1/shots/3817782/likes",
    public var projects_url: String //": "https://api.dribbble.com/v1/shots/3817782/projects",
    public var rebounds_count: Int //": 0,
    public var rebounds_url: String //": "https://api.dribbble.com/v1/shots/3817782/rebounds",
    public var tags: [String]
    public var team: Team?
    public var title: String
    public var updated_at: Date
    public var user: User
    public var views_count: Int
    public var width: Int
    
    static func popular(from data: Data) -> [Shot]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let shots = try decoder.decode([Shot].self, from: data)
            return Shot.createURLs(for: shots)
        } catch let error {
            debugPrint("\(error)")
            return nil
        }
    }
}

extension Shot {
    
    public enum List: String {
        case popular = ""
        case animated = "animated"
        case attachments = "attachments"
        case debuts = "debuts"
        case playoffs = "playoffs"
        case rebounds = "rebounds"
        case teams = "teams"
    }
    
    public enum Sort: String {
        case popular = ""
        case recent = "recent"
        case views = "views"
        case comments = "comments"
    }
    
    public static func fetchShots(list: List = .popular, sort: Sort = .popular, completion: @escaping ([Shot]?, Error?) -> Void) {
        let url = API.shots(list, sort).asURL()
        let task = NothingBut.Net.dataTask(with: url) { data, urlResponse, error in
            NothingBut.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let shots = Shot.popular(from: data)
            DispatchQueue.main.async {
                completion(shots, error)
            }
        }
        
        task.resume()
        NothingBut.setNetworkActivityIndicatorVisible(true)
    }

}

extension Shot {
    
    private static func createURLs(for shots: [Shot]) -> [Shot] {
        return shots.map({ (shot) -> Shot in
            var s = shot
            s.images.hidpiURL = URL(string: shot.images.hidpi ?? "")
            s.images.normalURL = URL(string: shot.images.normal)!
            s.images.teaserURL = URL(string: shot.images.teaser)!
            s.user.avatarURL = URL(string: s.user.avatar_url) ?? dribbbleURL
            if let team = s.team {
                s.team?.avatarURL = URL(string: team.avatar_url) ?? dribbbleURL
            }
            return s
        })
    }
    
    public func hidpiImageURL() -> URL {
        return images.hidpiURL ?? images.normalURL
    }
    
    public func profileImageURL() -> URL {
        return team?.avatarURL ?? user.avatarURL
    }
    
}
