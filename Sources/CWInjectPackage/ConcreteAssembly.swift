//
//  ConcreteAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

struct ConcreteAssembly<AssembledType>: Assembly {
  private let resolve: (Resolver) -> AssembledType

  init(resolve: @escaping (Resolver) -> AssembledType) {
    self.resolve = resolve
  }

  func resolve(_ resolver: Resolver) -> AssembledType {
    resolve(resolver)
  }
}
