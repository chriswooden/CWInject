//
//  Container.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public class Container: Resolver {
  private var factories: [ServiceFactoryWrapper]
  private var resolutionPool: [Any] = []

  public init() {
    factories = []
  }

  private init(factories: [ServiceFactoryWrapper]) {
    self.factories = factories
  }

  public func register<T>(instance: T) -> Container {
    register(factory: { _ in instance })
  }

  @discardableResult public func register<T>(factory: @escaping (Resolver) -> T, initCompleted: ((T, Resolver) -> Void)? = nil) -> Container {
    assert(!factories.contains(where: { $0.makes(T.self) }))
    let newFactory = ServiceFactory<T>(make: { factory($0) }, made: { initCompleted?($0, $1) })
    factories.append(newFactory.wrapped)
    return self
  }

  public func resolve<T>(_ type: T.Type) -> T? {
    if let service = resolutionPool.first(where: { $0 is T }) as? T {
      return service
    }
    guard let factory = factories.first(where: { $0.makes(type)}) else {
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
