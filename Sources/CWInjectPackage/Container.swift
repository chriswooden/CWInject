//
//  Container.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public struct Container: Resolver {
  let assemblies: [AnyAssembly]

  public init() {
    assemblies = []
  }

  private init(assemblies: [AnyAssembly]) {
    self.assemblies = assemblies
  }

  public func register<T>(instance: T) -> Container {
    register() { _ in instance }
  }

  public func register<T>(factory: @escaping (Resolver) -> T) -> Container {
    assert(!assemblies.contains(where: { $0.supports(T.self) }))
    let newAssembly = ConcreteAssembly<T>() { factory($0) }
    return .init(assemblies: assemblies + [newAssembly.wrapped])
  }

  public func resolve<T>(_ type: T.Type) -> T? {
    assemblies.first(where: { $0.supports(type)})?.resolve(self)
  }
}
