//
//  Assembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public protocol Assembly {
  associatedtype ResolvedType
  func resolve(_ resolver: Resolver) -> ResolvedType
}

extension Assembly {
  func supports<T>(_ type: T.Type) -> Bool {
    type == ResolvedType.self
  }

  var wrapped: AnyAssembly {
    AnyAssembly(self)
  }
}
