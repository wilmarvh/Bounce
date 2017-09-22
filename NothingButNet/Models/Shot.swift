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

