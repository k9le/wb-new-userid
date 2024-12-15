//
//  factories.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation

class UserIdProviderFactory: IServiceFactory {
    func make() -> IUserIdProvider {
        UserIdProvider()
    }
}

class DatabaseFactory: IServiceFactory {
    private let userIdProvider: any IServiceProvider<IUserIdProvider>

    init(userIdProvider: any IServiceProvider<IUserIdProvider>) {
        self.userIdProvider = userIdProvider
    }

    func make() -> IDatabase {
        Database(userIdProvider.instance)
    }
}

class FavoritesRepositoryFactory: IServiceFactory {

    private let dbServiceProvider: any IServiceProvider<IDatabase>

    init(dbServiceProvider: any IServiceProvider<IDatabase>) {
        self.dbServiceProvider = dbServiceProvider
    }

    func make() -> IFavoritesRepository {
        FavoritesRepository(dbService: dbServiceProvider.instance)
    }
}

class ProductsRepositoryFactory: IServiceFactory {

    private let dbServiceProvider: any IServiceProvider<IDatabase>

    init(dbServiceProvider: any IServiceProvider<IDatabase>) {
        self.dbServiceProvider = dbServiceProvider
    }

    func make() -> IProductsRepository {
        ProductsRepository(dbService: dbServiceProvider.instance)
    }
}

class FavoritesServiceFactory: IServiceFactory {

    private let favoritesRepositoryProvider: any IServiceProvider<IFavoritesRepository>

    init(favoritesRepositoryProvider: any IServiceProvider<IFavoritesRepository>) {
        self.favoritesRepositoryProvider = favoritesRepositoryProvider
    }

    func make() -> IFavoritesService {
        FavoritesService(favoritesRepository: favoritesRepositoryProvider.instance)
    }
}

class ProfileServiceFactory: IServiceFactory {

    private let favoritesServiceProvider: any IServiceProvider<IFavoritesService>

    init(favoritesServiceProvider: any IServiceProvider<IFavoritesService>) {
        self.favoritesServiceProvider = favoritesServiceProvider
    }

    func make() -> IProfileService {
        ProfileService(favoriteService: favoritesServiceProvider.instance)
    }
}


class CartServiceFactory: IServiceFactory {

    private let profileServiceProvider: any IServiceProvider<IProfileService>
    private let productRepositoryProvider: any IServiceProvider<IProductsRepository>

    init(
        profileServiceProvider: any IServiceProvider<IProfileService>,
        productRepositoryProvider: any IServiceProvider<IProductsRepository>
    ) {
        self.profileServiceProvider = profileServiceProvider
        self.productRepositoryProvider = productRepositoryProvider
    }

    func make() -> ICartService {
        CartService(
            profileService: profileServiceProvider.instance,
            productsRepository: productRepositoryProvider.instance
        )
    }
}
