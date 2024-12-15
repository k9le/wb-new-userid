//
//  services.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation

protocol IUserIdProvider {
    var userId: String { get set }
}

class UserIdProvider: IUserIdProvider {
    var userId: String = ""
}

protocol IDatabase {}

class Database: IDatabase {
    var dbpath: String
    init(_ userIdProvider: IUserIdProvider) {
        dbpath = "db_\(userIdProvider.userId)"
        print("DB \(dbpath) created")
    }
}

protocol IFavoritesRepository {}

class FavoritesRepository: IFavoritesRepository {
    init(dbService: IDatabase) {
        print("\(NSStringFromClass(type(of: self))) created")
    }
}

protocol IProductsRepository {}

class ProductsRepository: IProductsRepository {
    init(dbService: IDatabase) {
        print("\(NSStringFromClass(type(of: self))) created")
    }
}

protocol IFavoritesService {}

class FavoritesService: IFavoritesService {
    init(favoritesRepository: IFavoritesRepository) {
        print("\(NSStringFromClass(type(of: self))) created")
    }
}

protocol IProfileService {}

class ProfileService: IProfileService {
    init(favoriteService: IFavoritesService) {
        print("\(NSStringFromClass(type(of: self))) created")
    }
}

protocol ICartService {}

class CartService: ICartService {
    init(profileService: IProfileService, productsRepository: IProductsRepository) {
        print("\(NSStringFromClass(type(of: self))) created")
    }
}
