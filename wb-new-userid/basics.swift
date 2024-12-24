//
//  basics.swift
//  wb-new-userid
//
//  Created by Vasiliy Fedotov on 15.12.2024.
//

import Foundation
import Combine

protocol IServiceFactory<ReturnType> {
    associatedtype ReturnType
    func make() -> ReturnType
}

protocol IServiceProvider<ReturnType> {
    associatedtype ReturnType
    var instance: ReturnType { get }
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

extension AbstractServiceRef: Cancellable {
    func cancel() {
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

struct InstantServiceWrapper<T, TFactory: IServiceFactory<T>> {

    private let serviceRef: InstantServiceRef<T, TFactory>

    init(serviceFactory: TFactory) {
        self.serviceRef = .init(serviceFactory: serviceFactory)
    }

    var service: T {
        serviceRef.instance
    }

    var provider: some IServiceProvider<T> {
        serviceRef
    }

    func store(in bag: inout Set<AnyCancellable>) -> Self {
        serviceRef.store(in: &bag)
        return self
    }
}

struct LazyServiceWrapper<T, TFactory: IServiceFactory<T>> {

    private let serviceRef: LazyServiceRef<T, TFactory>

    init(serviceFactory: TFactory) {
        self.serviceRef = .init(serviceFactory: serviceFactory)
    }

    var service: T {
        serviceRef.instance
    }

    var provider: some IServiceProvider<T> {
        serviceRef
    }

    func store(in bag: inout Set<AnyCancellable>) -> Self {
        serviceRef.store(in: &bag)
        return self
    }
}
