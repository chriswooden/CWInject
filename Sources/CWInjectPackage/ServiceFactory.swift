//
//  ConcreteAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

struct ServiceFactory<AssembledType>: ServiceFactoryProtocol {
  private let make: (Resolver) -> AssembledType

  init(make: @escaping (Resolver) -> AssembledType) {
    self.make = make
  }

  func make(_ resolver: Resolver) -> AssembledType {
    make(resolver)
  }
}
