import Foundation

struct UsersRequest: NetworkRequest {
    
    var isUrlEncoded: Bool { false }
    var httpMethod: HttpMethod = .get
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.users)")
    }
}