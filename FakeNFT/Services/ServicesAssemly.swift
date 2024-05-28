final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let orderStorage: OrderStorageProtocol
    private let nftByIdStorage: NftByIdStorageProtocol
    private let nftNetworkStorage: NftNetworkStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        orderStorage: OrderStorageProtocol,
        nftByIdStorage: NftByIdStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.orderStorage = orderStorage
        self.nftByIdStorage = nftByIdStorage
        self.nftNetworkStorage = NftNetworkStorageImpl()
    }

    var nftService: NftServiceProtocol {
        NftService(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var orderService: OrderServiceProtocol {
        OrderService(
            networkClient: networkClient,
            orderStorage: orderStorage,
            nftByIdService: nftByIdService,
            nftStorage: nftByIdStorage)
    }
    
    var nftByIdService: NftByIdServiceProtocol {
        NftByIdService(
            networkClient: networkClient,
            storage: nftByIdStorage)
    }
    
    var paymentService: PaymentServiceProtocol {
        PaymentService(
            networkClient: networkClient)
    }
    
    var usersService: UsersService {
        UsersServiceImpl(networkClient: networkClient)
    }
    
    var basketService: BasketService {
        BasketServiceImpl(networkClient: networkClient)
    }
    
    var profileService: ProfileNetworkService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var nftNetworkService: NftNetworkService {
        NftNetworkServiceImpl(
            networkClient: networkClient,
            storage: nftNetworkStorage
        )
    }
}
 
