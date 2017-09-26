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
            debugPrint("\(error)")
            return nil
        }
    }
}

extension Shot {
    
    public static func fetchPopularShots(completion: @escaping ([Shot]?, Error?) -> Void) {
        let url = API.shots.asURL()
        let task = NothingButNet.session.dataTask(with: url) { data, urlResponse, error in
            NothingButNet.setNetworkActivityIndicatorVisible(false)
            guard let data = data else {
                return completion(nil, error)
            }
            let shots = Shot.popular(from: data)
            DispatchQueue.main.async {
                completion(shots, error)
            }
        }
        
        task.resume()
        NothingButNet.setNetworkActivityIndicatorVisible(true)
    }
    
    public static func loadImage(`for` shot: Shot, completion: @escaping (Int, UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let remoteImageURL = URL(string: shot.images.hidpi ?? shot.images.normal) else { return }
            let filename = "\(shot.id)_" + remoteImageURL.lastPathComponent
            var image: UIImage?
            var localImageURL: URL?
            // try and load from documents directory
            if let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                let url = documentsDirectory.appendingPathComponent(filename)
                localImageURL = url
                do {
                    let localData = try Data(contentsOf: url)
                    image = UIImage(data: localData)
                } catch { /* no such file found */ }
            }
            
            // load remote image if no local image is found
            if image == nil {
                NothingButNet.setNetworkActivityIndicatorVisible(true)
                let data = try! Data(contentsOf: remoteImageURL)
                if let validImage = UIImage(data: data) {
                    do {
                        image = validImage
                        if let url = localImageURL {
                            let pngData = UIImagePNGRepresentation(validImage)
                            try pngData?.write(to: url)
                        }
                    } catch let error {
                        debugPrint(error)
                    }
                }
                NothingButNet.setNetworkActivityIndicatorVisible(false)
            }
            
            // complete
            DispatchQueue.main.async {
                completion(shot.id, image)
            }
        }
    }
    
    public static func loadProfileImage(`for` shot: Shot, completion: @escaping (Int, UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
                return
            }
            
            var filename = ""
            var image: UIImage?
            var remoteURL: URL?
            
            // determine whether to load team or user
            if let team = shot.team {
                filename = "team_\(team.id).png"
                remoteURL = URL(string: team.avatar_url)
            } else {
                filename = "user_\(shot.user.id).png"
                remoteURL = URL(string: shot.user.avatar_url)
            }
            
            // try and load from documents directory
            let localURL = documentsDirectory.appendingPathComponent(filename)
            do {
                let localData = try Data(contentsOf: localURL)
                image = UIImage(data: localData)
            } catch { /* no such file found */ }
            
            // load remote image if no local image is found
            if image == nil {
                guard let url = remoteURL else { return }
                
                NothingButNet.setNetworkActivityIndicatorVisible(true)
                let data = try! Data(contentsOf: url)
                if let validImage = UIImage(data: data) {
                    do {
                        image = validImage
                        let pngData = UIImagePNGRepresentation(validImage)
                        try pngData?.write(to: localURL)
                    } catch let error {
                        debugPrint(error)
                    }
                }
                NothingButNet.setNetworkActivityIndicatorVisible(false)
            }
            
            // complete
            DispatchQueue.main.async {
                completion(shot.id, image)
            }
        }
    }
    
}

extension Shot {
    
    public func anyImageFromCache() -> UIImage? {
        var image: UIImage? = nil
        if let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            guard let remoteImageURL = URL(string: self.images.hidpi ?? self.images.normal) else { return nil }
            let filename = "\(self.id)_" + remoteImageURL.lastPathComponent
            let url = documentsDirectory.appendingPathComponent(filename)
            do {
                let localData = try Data(contentsOf: url)
                if self.animated {
                    image = UIImage.gif(data: localData)
                } else {
                    image = UIImage(data: localData)
                }
            } catch { /* no image found */ }
        }
        return image
    }
    
}
