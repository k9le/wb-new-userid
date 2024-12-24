//
//  services-provider.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 24.12.2024.
//

import Foundation
import Combine

class ServicesProvider {

    var disposeBag = Set<AnyCancellable>()

    // MARK: - user id
    private let userIdProviderWrapper = InstantServiceWrapper(
        serviceFactory: UserIdProviderFactory()
    )
    var userIdProvider: IUserIdProvider { userIdProviderWrapper.service }

    // MARK: - database
    private lazy var databaseWrapper = LazyServiceWrapper(
        serviceFactory: DatabaseFactory(
            userIdProvider: userIdProviderWrapper.provider
        )
    ).store(in: &disposeBag)
    var database: IDatabase { databaseWrapper.service }

    // MARK: - favoritesRepository
    private lazy var favoritesRepositoryWrapper = LazyServiceWrapper(
        serviceFactory: FavoritesRepositoryFactory(
            dbServiceProvider: databaseWrapper.provider
        )
    ).store(in: &disposeBag)
    var favoritesRepository: IFavoritesRepository { favoritesRepositoryWrapper.service }

    // MARK: - productsRepository
    private lazy var productsRepositoryWrapper = LazyServiceWrapper(
        serviceFactory: ProductsRepositoryFactory(
            dbServiceProvider: databaseWrapper.provider
        )
    ).store(in: &disposeBag)
    var productsRepository: IProductsRepository { productsRepositoryWrapper.service }

    // MARK: - favoritesService
    private lazy var favoritesServiceWrapper = LazyServiceWrapper(
        serviceFactory: FavoritesServiceFactory(
            favoritesRepositoryProvider: favoritesRepositoryWrapper.provider
        )
    ).store(in: &disposeBag)
    var favoritesService: IFavoritesService { favoritesServiceWrapper.service }

    // MARK: - profileService
    private lazy var profileServiceWrapper = LazyServiceWrapper(
        serviceFactory: ProfileServiceFactory(
            favoritesServiceProvider: favoritesServiceWrapper.provider
        )
    ).store(in: &disposeBag)
    var profileService: IProfileService { profileServiceWrapper.service }

    // MARK: - cartService
    private lazy var cartServiceWrapper = LazyServiceWrapper(
        serviceFactory: CartServiceFactory(
            profileServiceProvider: profileServiceWrapper.provider,
            productRepositoryProvider: productsRepositoryWrapper.provider
        )
    ).store(in: &disposeBag)
    var cartService: ICartService { cartServiceWrapper.service }

    func prepareForNewUserId(_ userId: String) {
        userIdProvider.userId = userId
        
        disposeBag.forEach {
            $0.cancel()
        }
    }
}
