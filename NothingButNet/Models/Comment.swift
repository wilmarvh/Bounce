import Foundation

public struct Comment: Decodable {
    public var body: String //": "<p><a href=\"https://dribbble.com/606911\">@Bartosz Żaczek</a> Thanks for the honesty man, it's meant to be different and not that formal as a lots of fintech apps.</p>\n\n<p><a href=\"https://dribbble.com/754539\">@Robert Ligthart ✌</a> Thanks for your honest opinion man 😉</p>",
    public var created_at: Date //": "2017-09-13T13:45:18Z",
    public var id: Int //": 6548063,
    public var likes_count: Int //": 1,
    public var likes_url: String //": "https://api.dribbble.com/v1/shots/3803685/comments/6548063/likes",
    public var updated_at: Date //": "2017-09-13T13:45:37Z",
    public var user: User
    
    static func comments(from data: Data) -> [Comment]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let comments = try decoder.decode([Comment].self, from: data)
            return comments
        } catch let error {
            debugPrint("\(error)")
            return nil
        }
    }

}

extension Comment {
    
    public static func fetch(for shot: Shot,completion: @escaping ([Comment]?, Error?) -> Void) {
        let url = API.shotComments(shot.id).asURL()
        let task = NothingBut.Net.dataTask(with: url) { data, urlResponse, error in
            NothingBut.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let comments = Comment.comments(from: data)
            DispatchQueue.main.async {
                completion(comments, error)
            }
        }

        task.resume()
        NothingBut.setNetworkActivityIndicatorVisible(true)
    }
    
}
