import Foundation

typealias BasketCompletion = (Result<BasketNfts, Error>) -> Void

protocol BasketService {
    func loadNft(completion: @escaping BasketCompletion)
    func updateNft(basket: BasketNfts, completion: @escaping BasketCompletion)
}

final class BasketServiceImpl: BasketService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNft(completion: @escaping BasketCompletion) {

        let request = BasketRequest(httpMethod: .get)
        networkClient
            .send(
                request: request,
                type: BasketNfts.self
            ) { result in
                switch result {
                case .success(let basket):
                    completion(.success(basket))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func updateNft(basket: BasketNfts, completion: @escaping BasketCompletion) {
        
        let request = BasketPutRequest(basket: basket)
        networkClient
            .send(
                request: request,
                type: BasketNfts.self
            ) { result in
                switch result {
                case .success(let basket):
                    completion(.success(basket))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
