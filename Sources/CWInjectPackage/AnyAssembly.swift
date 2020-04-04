//
//  AnyAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public final class AnyAssembly {
  private let resolve: (Resolver) -> Any
  private let supports: (Any.Type) -> Bool

  init<T: Assembly>(_ assembly: T) {
    self.resolve = { assembly.resolve($0) }
    self.supports = { $0 == T.ResolvedType.self }
  }

  public func resolve<AssemblyType>(_ resolver: Resolver) -> AssemblyType {
    resolve(resolver) as! AssemblyType
  }

  public func supports<AssemblyType>(_ type: AssemblyType.Type) -> Bool {
    supports(type)
  }
}
