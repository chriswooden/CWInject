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

  init() {
    assemblies = []
  }

  init(assemblies: [AnyAssembly]) {
    self.assemblies = assemblies
  }

  public func register<T>(instance: T) -> Container {
    register() { _ in instance }
  }

  public func register<T>(assemble: @escaping (Resolver) -> T) -> Container {
    let type = T.self
    assert(!assemblies.contains(where: { $0.supports(type) }))
    let newAssembly = ConcreteAssembly<T>() { assemble($0) }
    return .init(assemblies: assemblies + [AnyAssembly(newAssembly)])
  }

  public func resolve<T>(_ type: T.Type) -> T? {
    assemblies.first(where: { $0.supports(type)})?.resolve(self)
  }
}
