//
//  ConcreteAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

struct ConcreteAssembly<AssembledType>: Assembly {
  private let assemble: (Resolver) -> AssembledType

  init(assemble: @escaping (Resolver) -> AssembledType) {
    self.assemble = assemble
  }

  func assemble(_ resolver: Resolver) -> AssembledType {
    assemble(resolver)
  }
}
