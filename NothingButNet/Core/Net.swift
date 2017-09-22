    import Foundation

    public class NothingBut {
        
        enum endpoints: String {
            case user = "user"
            case shots = "shots"
            
            static let baseURL: URL = URL(string: "https://api.dribbble.com/v1/")!
            
            func asURL() -> URL {
                return endpoints.baseURL.appendingPathComponent(self.rawValue)
            }
        }
        
        lazy var session: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization" : "Bearer ae04eff00cd0125a8615fa28ec64c347e8cd80dbc8fd3c5647632d129d5318eb"]
            return URLSession(configuration: configuration)
        }()
        
        // MARK: Singleton
        
        open static let Net = {
            return NothingBut()
        }()
        
        var numberOfCallsToSetVisible = 0
        
        func setNetworkActivityIndicatorVisible(_ visible: Bool) {
            if visible {
                numberOfCallsToSetVisible = numberOfCallsToSetVisible + 1
            } else {
                numberOfCallsToSetVisible = numberOfCallsToSetVisible - 1
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfCallsToSetVisible > 0
            }
        }
        
        // MARK: Functions
        
        public func fetchCurrentUser(completion: @escaping (User?, Error?) -> Void) {
            let url = endpoints.user.asURL()
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
        
        public func fetchPopularShots(completion: @escaping ([Shot]?, Error?) -> Void) {
            let url = endpoints.shots.asURL()
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
        
    }
