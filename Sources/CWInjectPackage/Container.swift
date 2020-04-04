//
//  Container.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public class Container: Resolver {
  private var factories: [ServiceKey: ServiceFactoryWrapper]
  private var resolutionPool: [Any] = []

  public init() {
    factories = [:]
  }

  @discardableResult public func register<T>(_ type: T.Type, id: String? = nil, instance: T) -> Container {
    register(type, factory: { _ in instance })
  }

  @discardableResult public func register<T>(_ type: T.Type, id: String? = nil, factory: @escaping (Resolver) -> T, initCompleted: ((T, Resolver) -> Void)? = nil) -> Container {
    let key = ServiceKey(serviceType: type, id: id)
    assert(factories[key] == nil, "Pre-existing service registration for type, supply a uniqie id to regitser multiple services for the same type")
    let newFactory = ServiceFactory<T>(make: { factory($0) }, made: { initCompleted?($0, $1) })
    factories[key] = newFactory.wrapped
    return self
  }

  public func resolve<T>(_ type: T.Type, id: String? = nil) -> T? {
    if let service = resolutionPool.first(where: { $0 is T }) as? T {
      return service
    }
    guard let factory = factories[ServiceKey(serviceType: type, id: id)] else {
      return nil
    }
    let service = factory.make(resolver: self) as Any
    resolutionPool.append(service)
    let index = resolutionPool.count - 1
    factory.made(service, resolver: self)
    resolutionPool.remove(at: index)
    return service as? T
  }
}
