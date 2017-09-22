import Foundation

enum API {
    case user
    case users(String)
    case shots
    
    static let baseURL: URL = URL(string: "https://api.dribbble.com/v1/")!
    
    func asURL() -> URL {
        let url = API.baseURL.appendingPathComponent(self.pathComponent())
        switch self {
        case .shots:
            let queryItem = URLQueryItem(name: "per_page", value: "50")
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = [queryItem]
            return components?.url ?? url
        default:
            return url
        }
    }
    
    func pathComponent() -> String {
        switch self {
        case .user:
            return "user"
        case .users(let user):
            return "users/\(user)"
        case .shots:
            return "shots"
        }
    }
}

class NothingButNet {
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : "Bearer ae04eff00cd0125a8615fa28ec64c347e8cd80dbc8fd3c5647632d129d5318eb"]
        return URLSession(configuration: configuration)
    }()
    
    // MARK: Singleton
    
    open static let Net = {
        return NothingButNet()
    }()
    
    class var session: URLSession {
        return NothingButNet.Net.session
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
    
}
