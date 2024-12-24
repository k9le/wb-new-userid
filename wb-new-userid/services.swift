//
//  services.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation

protocol IUserIdProvider: AnyObject {
    var userId: String { get set }
}

class UserIdProvider: IUserIdProvider {
    var userId: String = ""
}

protocol IDatabase: AnyObject {
    var description: String { get }
}

class Database: IDatabase {
    var description: String
    init(_ userIdProvider: IUserIdProvider) {
        description = "db_\(userIdProvider.userId)"
        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}

protocol IFavoritesRepository: AnyObject {
    var description: String { get }
}

class FavoritesRepository: IFavoritesRepository {
    var description: String

    init(dbService: IDatabase) {
        description = "fr_" + dbService.description
        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}

protocol IProductsRepository: AnyObject {
    var description: String { get }
}

class ProductsRepository: IProductsRepository {
    var description: String

    init(dbService: IDatabase) {
        description = "pr_" + dbService.description
        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}

protocol IFavoritesService: AnyObject {
    var description: String { get }
}

class FavoritesService: IFavoritesService {
    var description: String

    init(favoritesRepository: IFavoritesRepository) {
        description = "fs_" + favoritesRepository.description
        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}

protocol IProfileService: AnyObject {
    var description: String { get }
}

class ProfileService: IProfileService {
    var description: String

    init(favoriteService: IFavoritesService) {
        description = "ps_" + favoriteService.description

        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}

protocol ICartService: AnyObject {
    var description: String { get }
}

class CartService: ICartService {
    var description: String

    init(profileService: IProfileService, productsRepository: IProductsRepository) {
        description = "cart_" + profileService.description
        print("\(NSStringFromClass(type(of: self))) \(description) created")
    }

    deinit {
        print("\(NSStringFromClass(type(of: self))) \(description) destroyed")
    }
}
