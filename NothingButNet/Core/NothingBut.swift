import Foundation

public let dribbbleURL = URL(string: "https://www.dribbble.com")!

enum API {
    case user
    case users(String)
    case shots(Shot.List, Shot.Sort)
    case shotComments(Int)
    
    static let baseURL: URL = URL(string: "https://api.dribbble.com/v1/")!
    
    func asURL() -> URL {
        let url = API.baseURL.appendingPathComponent(self.pathComponent())
        switch self {
        case .shots:
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = [URLQueryItem(name: "per_page", value: "100")] + self.queryItems()
            return components?.url ?? url
        default:
            return url
        }
    }
    
    func queryItems() -> [URLQueryItem] {
        var items = [URLQueryItem]()
        
        switch self {
        case .user:
            break
        case .users(_):
            break
        case .shots(let list, let sort):
            if list != .popular {
                items.append(contentsOf: [URLQueryItem(name: "list", value: list.rawValue)])
            }
            if sort != .popular {
                items.append(contentsOf: [URLQueryItem(name: "sort", value: sort.rawValue)])
            }
        case .shotComments(_):
            break
        }
        
        return items
    }
    
    func pathComponent() -> String {
        switch self {
        case .user:
            return "user"
        case .users(let user):
            return "users/\(user)"
        case .shots:
            return "shots"
        case .shotComments(let id):
            return "\(API.shots(.popular, .popular).pathComponent())/\(id)/comments"
        }
    }
}

public class NothingBut {
    
    private var token: String = "ae04eff00cd0125a8615fa28ec64c347e8cd80dbc8fd3c5647632d129d5318eb"
    
    private var _session: URLSession?
    private var session: URLSession {
        if _session == nil {
            let configuration = HTTPLogger.defaultSessionConfiguration()
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
            HTTPLogger.register()
            _session = URLSession(configuration: configuration)
        }
        return _session!
    }
    
    // MARK: Singleton
    
    private static let shared = {
        return NothingBut()
    }()
    
    class var Net: URLSession {
        return NothingBut.shared.session
    }
    
    // MARK: Network activity
    
    static var numberOfCallsToSetVisible = 0
    
    static func setNetworkActivityIndicatorVisible(_ visible: Bool) {
        if visible {
            numberOfCallsToSetVisible = numberOfCallsToSetVisible + 1
        } else {
            numberOfCallsToSetVisible = numberOfCallsToSetVisible - 1
        }
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfCallsToSetVisible > 0
        }
    }

    // MARK: Dribbble Authorization
    
    private static let clientId = "f0ff3e66f65c40e8f33d61eca4743349ffa229de6d18be2cb0d5103d944fe8f3"
    
    private static let clientSecret = "305c8fa1ee13503d5465aa0a0e553428e2c6853e8abe2d60bf1548dd8c38f84b"
    
    public class func authorizeURL() -> URL {
        var components = URLComponents(string: "https://dribbble.com/oauth/authorize")!
        let clientId = URLQueryItem(name: "client_id", value: NothingBut.clientId)
        let state = URLQueryItem(name: "state", value: UUID().uuidString)
        components.queryItems = [clientId, state]
        return components.url!
    }
    
    public class func generateToken(with code: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://dribbble.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params = [
            "client_id": NothingBut.clientId,
            "client_secret": NothingBut.clientSecret,
            "code": code,
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = shared.session.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                debugPrint("\(error)")
            } else if let data = data {
                if let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                    let token = jsonObject["access_token"] as? String {
                    NothingBut.setToken(token)
                }
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
        task.resume()
    }
    
    public class func setToken(_ token: String) {
        shared.token = token
        shared._session = nil
    }
    
}
