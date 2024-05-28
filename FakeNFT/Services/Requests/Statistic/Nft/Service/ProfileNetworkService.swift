import Foundation

typealias ProfileCompletion = (Result<ProfileLikes, Error>) -> Void

protocol ProfileNetworkService {
    func loadNft(completion: @escaping ProfileCompletion)
    func updateLikes(profile: ProfileLikes, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileNetworkService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNft(completion: @escaping ProfileCompletion) {

        let request = ProfileRequest(httpMethod: .get)
        networkClient
            .send(
                request: request,
                type: ProfileLikes.self
            ) { result in
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func updateLikes(profile: ProfileLikes, completion: @escaping ProfileCompletion) {
        
        let request = ProfilePutRequest(profile: profile)
        networkClient
            .send(
                request: request,
                type: ProfileLikes.self
            ) { result in
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
