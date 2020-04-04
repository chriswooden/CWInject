//
//  AnyAssembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

final class ServiceFactoryWrapper {
  private let make: (Resolver) -> Any
  private let makes: (Any.Type) -> Bool

  init<T: ServiceFactoryProtocol>(_ factory: T) {
    self.make = { factory.make($0) }
    self.makes = { $0 == T.ServiceType.self }
  }

  func make<AssemblyType>(_ resolver: Resolver) -> AssemblyType {
    make(resolver) as! AssemblyType
  }

  func makes<AssemblyType>(_ type: AssemblyType.Type) -> Bool {
    makes(type)
  }
}
