//
//  Container.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public struct Container: Resolver {
  let factories: [ServiceFactoryWrapper]

  public init() {
    factories = []
  }

  private init(factories: [ServiceFactoryWrapper]) {
    self.factories = factories
  }

  public func register<T>(instance: T) -> Container {
    register() { _ in instance }
  }

  public func register<T>(factory: @escaping (Resolver) -> T) -> Container {
    assert(!factories.contains(where: { $0.makes(T.self) }))
    let newFactory = ServiceFactory<T>() { factory($0) }
    return .init(factories: factories + [newFactory.wrapped])
  }

  public func resolve<T>(_ type: T.Type) -> T? {
    factories.first(where: { $0.makes(type)})?.make(self)
  }
}
