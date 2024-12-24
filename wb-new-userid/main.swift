//
//  main.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation


let servicesProvider = ServicesProvider()

servicesProvider.prepareForNewUserId("1")

print(servicesProvider.cartService.description)
print("\n\n")

servicesProvider.prepareForNewUserId("2")

print("\n\n")
print(servicesProvider.cartService.description)
