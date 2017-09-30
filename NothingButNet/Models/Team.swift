import Foundation

public struct Team: Decodable {
    var avatar_url: String //": "https://cdn.dribbble.com/users/40433/avatars/normal/41b86a77ca368dd4a969397ef39ba9a6.png?1472167036",
    public var avatarURL: URL = dribbbleURL //": "https://cdn.dribbble.com/users/40433/avatars/normal/41b86a77ca368dd4a969397ef39ba9a6.png?1472167036",
    public var bio: String //": "Digital Agency in SF, NY, LA and Iceland. Clients include Google, Reuters, Facebook, Uber, ESPN, Red Bull, Samsung, Airbnb, Lonely Planet, Verizon &amp; Dropbox. public ",
    public var buckets_count: Int //": 0,
    public var buckets_url: String //": "https://api.dribbble.com/v1/users/40433/buckets",
    public var can_upload_shot: Bool //": true,
    public var comments_received_count: Int //": 4081,
    public var created_at: Date //": "2011-06-14T01:42:09Z",
    public var followers_count: Int //": 65674,
    public var followers_url: String //": "https://api.dribbble.com/v1/users/40433/followers",
    public var following_url: String //": "https://api.dribbble.com/v1/users/40433/following",
    public var followings_count: Int //": 532,
    public var html_url: String //": "https://dribbble.com/ueno",
    public var id: Int //": 40433,
    public var likes_count: Int //": 698,
    public var likes_received_count: Int //": 155475,
    public var likes_url: String //": "https://api.dribbble.com/v1/users/40433/likes",
    public var links: Links
    public var location: String? //": "San Francisco, CA",
    public var members_count: Int //": 28,
    public var members_url: String //": "https://api.dribbble.com/v1/teams/40433/members",
    public var name: String //": "ueno.",
    public var pro: Bool //": false,
    public var projects_count: Int //": 38,
    public var projects_url: String //": "https://api.dribbble.com/v1/users/40433/projects",
    public var rebounds_received_count: Int //": 31,
    public var shots_count: Int //": 384,
    public var shots_url: String //": "https://api.dribbble.com/v1/users/40433/shots",
    public var team_shots_url: String //": "https://api.dribbble.com/v1/teams/40433/shots",
    public var type: String //": "Team",
    public var updated_at: Date //": "2017-09-20T21:33:32Z",
    public var username: String //": "ueno"
    
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
        case members_count
        case members_url
        case name
        case pro
        case projects_count
        case projects_url
        case rebounds_received_count
        case shots_count
        case shots_url
        case team_shots_url
        case type
        case updated_at
        case username
    }
}
