import Foundation

public struct Shot: Codable {
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
            return shots
        } catch let error {
            return nil
        }
    }
}

extension Shot {
    
    public static func fetchPopularShots(completion: @escaping ([Shot]?, Error?) -> Void) {
        let url = API.shots.asURL()
        let task = NothingBut.Net.session.dataTask(with: url) { data, urlResponse, error in
            NothingBut.Net.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let shots = Shot.popular(from: data)
            DispatchQueue.main.async {
                completion(shots, error)
            }
        }
        
        task.resume()
        NothingBut.Net.setNetworkActivityIndicatorVisible(true)
    }
    
    public static func loadNormalImage(`for` shot: Shot, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var image: UIImage? = nil
            if let url = URL(string: shot.images.normal) {
                let data = try! Data(contentsOf: url)
                image = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}
