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
  private var resolutionPool: [ServiceKey: Any] = [:]

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

  public func resolve<T>(_ type: T.Type, id: String? = nil) -> T {
    let key = ServiceKey(serviceType: type, id: id)
    if let service = resolutionPool[key] as? T {
      return service
    }
    guard let factory = factories[ServiceKey(serviceType: type, id: id)] else {
      assert(false, "Cannot resolve dependency of type: \(T.self), id: \(String(describing: id)). Ensure a registration exists")
    }
    let service = factory.make(resolver: self) as Any
    resolutionPool[key] = service
    factory.made(service, resolver: self)
    resolutionPool.removeValue(forKey: key)
    return service as! T
  }
}
