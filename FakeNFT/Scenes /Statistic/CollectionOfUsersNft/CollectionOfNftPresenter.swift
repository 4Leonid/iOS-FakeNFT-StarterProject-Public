import Foundation

protocol LikesInteraction: AnyObject {
    
    func getProfile() -> ProfileLikes
    func getLikes() -> [String]
    func getLikesString() -> String
    func appendLike(by likeId: String)
    func deleteLike(by likeId: String)
    func updateLikes(with newProfile: ProfileLikes)
}

protocol BasketInteraction: AnyObject {
    
    func getBasket() -> BasketNfts
    func getBasketNfts() -> [String]
    func getBasketString() -> String
    func appendNft(by id: String)
    func deleteNft(by id: String)
    func updateNfts(with newBasket: BasketNfts)
}

struct BasketNfts: Codable {
    var nfts: [String]
    
    func transformNfts() -> String {
        var transformLike = "nfts="
        transformLike += nfts.joined(separator: "%2C")
        return transformLike
    }
}

struct ProfileLikes: Codable {
    var likes: [String]
    
    func transformNfts() -> String {
        var transformLike = "likes="
        transformLike += likes.joined(separator: "%2C")
        return transformLike
    }
}

//MARK: - CollectionOfNftFabric
final class CollectionOfNftPresenter {
    
    var onNeedUpdate: (() -> Void)?
    
    private var nfts: [String]
    private var nftsFromNetwork: [NftModel] = []
    private var nftNetworkService: NftNetworkService
    private var profileService: ProfileNetworkService
    
    private let dispatchGroup = DispatchGroup()
    
    private var nftsWithLike: ProfileLikes
    private var nftsOnBasket: BasketNfts
    
    init(
        with nfts: [String]?,
        servicesAssembly: ServicesAssembly
    ) {
        self.nftsWithLike = ProfileLikes(likes: [])
        self.nftsOnBasket = BasketNfts(nfts: [])
        
        self.nftNetworkService = servicesAssembly.nftNetworkService
        self.profileService = servicesAssembly.profileService
        
        guard let nfts = nfts else {
            self.nfts = []
            return
        }
        self.nfts = nfts
        
        setNftsFromNetwork()
    }
    
    func isEmpty() -> Bool {
        
        return nftsFromNetwork.isEmpty
    }
    
    func getNftsCount() -> Int {
        
        nftsFromNetwork.count
    }
    
    func getNfts() -> [String] {
        
        nfts
    }
    
    func getNft(by index: Int) -> NftModel {
        
        if index > nftsFromNetwork.count { return MockData.shared.placeholderNft }
        return nftsFromNetwork[index]
    }
    
    func setNftsFromNetwork() {
        for nftId in nfts {
            self.dispatchGroup.enter()
            self.getNftFromNetwork(with: nftId)
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.onNeedUpdate?()
        }
    }
    
    func getNftFromNetwork(with id: String) {
        DispatchQueue.main.async {
            self.nftNetworkService.loadNft(by: id) { [weak self] result in
                defer { self?.dispatchGroup.leave() }
                switch result {
                case .success(let nftFromNetwork):
                    self?.nftsFromNetwork.append(nftFromNetwork)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//MARK: - LikesInteraction
extension CollectionOfNftPresenter: LikesInteraction {
    
    func getProfile() -> ProfileLikes {
        
        nftsWithLike
    }
    
    func getLikes() -> [String] {
        
        nftsWithLike.likes
    }
    
    func getLikesString() -> String {
        
        nftsWithLike.transformNfts()
    }
    
    func appendLike(by like: String) {
        
        nftsWithLike.likes.append(like)
    }
    
    func deleteLike(by likeId: String) {
        
        nftsWithLike.likes.removeAll {
            $0 == likeId
        }
    }
    
    func updateLikes(with newProfile: ProfileLikes) {
        
        nftsWithLike.likes = newProfile.likes
    }
}

//MARK: - BasketInteraction
extension CollectionOfNftPresenter: BasketInteraction {
    
    func getBasket() -> BasketNfts {
        
        nftsOnBasket
    }
    
    func getBasketNfts() -> [String] {
        
        nftsOnBasket.nfts
    }
    
    func getBasketString() -> String {
        
        nftsOnBasket.transformNfts()
    }
    
    func appendNft(by id: String) {
        
        nftsOnBasket.nfts.append(id)
    }
    
    func deleteNft(by id: String) {
        
        nftsOnBasket.nfts.removeAll {
            $0 == id
        }
    }
    
    func updateNfts(with newBasket: BasketNfts) {
        
        nftsOnBasket.nfts = newBasket.nfts
    }
}
