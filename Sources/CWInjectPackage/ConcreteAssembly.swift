//
//  ConcreteAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

struct ConcreteAssembly<AssembledType>: Assembly {
  private let factory: (Resolver) -> AssembledType

  init(_ type: AssembledType.Type, factory: @escaping (Resolver) -> AssembledType) {
    self.factory = factory
  }

  func assemble(_ resolver: Resolver) -> AssembledType {
    factory(resolver)
  }
}
