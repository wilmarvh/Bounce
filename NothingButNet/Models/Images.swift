import Foundation

public struct Images: Decodable {
    var hidpi: String?
    public var hidpiURL: URL? = dribbbleURL
    var normal: String
    public var normalURL: URL = dribbbleURL
    var teaser: String
    public var teaserURL: URL = dribbbleURL
    
    private enum CodingKeys: String, CodingKey {
        case hidpi
        case normal
        case teaser
    }
}
