//
//  basics.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation

protocol IServiceFactory<ReturnType> {
    associatedtype ReturnType
    func make() -> ReturnType
}

protocol IServiceProvider<ReturnType> {
    associatedtype ReturnType
    var instance: ReturnType { get }
}

protocol IServiceKiller {
    func killService()
}

class AbstractServiceRef<T, TFactory: IServiceFactory<T>>{
    private let serviceFactory: TFactory
    private var _service: T?
    private let createInstantly: Bool

    init(serviceFactory: TFactory, createInstantly: Bool) {
        self.serviceFactory = serviceFactory
        self.createInstantly = createInstantly
        let _ = createInstantly ? createService() : nil
    }

    @discardableResult
    private func createService() -> T {
        let service = serviceFactory.make()
        _service = service
        return service
    }
}

extension AbstractServiceRef: IServiceProvider {
    var instance: T {
        if let _service { return _service }
        return createService()
    }
}

extension AbstractServiceRef: IServiceKiller {
    func killService() {
        _service = createInstantly ? createService() : nil
    }
}

final class LazyServiceRef<T, TFactory: IServiceFactory<T>>: AbstractServiceRef<T, TFactory> {
    init(serviceFactory: TFactory) {
        super.init(serviceFactory: serviceFactory, createInstantly: false)
    }
}

final class InstantServiceRef<T, TFactory: IServiceFactory<T>>: AbstractServiceRef<T, TFactory> {
    init(serviceFactory: TFactory) {
        super.init(serviceFactory: serviceFactory, createInstantly: true)
    }
}


@propertyWrapper
struct InstantServiceWrapper<T, TFactory: IServiceFactory<T>> {

    private let serviceRef: InstantServiceRef<T, TFactory>

    init(serviceFactory: TFactory) {
        self.serviceRef = .init(serviceFactory: serviceFactory)
    }

    var wrappedValue: T {
        serviceRef.instance
    }

    var projectedValue: some IServiceProvider<T> {
        serviceRef
    }
}

@propertyWrapper
struct LazyServiceWrapper<T, TFactory: IServiceFactory<T>> {

    private let serviceRef: LazyServiceRef<T, TFactory>

    init(serviceFactory: TFactory) {
        self.serviceRef = .init(serviceFactory: serviceFactory)
    }

    var wrappedValue: T {
        serviceRef.instance
    }

    var projectedValue: some IServiceProvider<T> {
        serviceRef
    }
}
