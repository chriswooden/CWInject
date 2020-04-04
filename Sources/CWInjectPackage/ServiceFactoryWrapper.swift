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
  private let made: ((Any, Resolver) -> Void)
  private let makes: (Any.Type) -> Bool

  init<T: ServiceFactoryProtocol>(_ factory: T) {
    self.make = { factory.make(resolver: $0) }
    self.makes = { $0 == T.ServiceType.self }
    self.made = { factory.made($0 as! T.ServiceType, resolver: $1) }
  }

  func make<ServiceType>(resolver: Resolver) -> ServiceType {
    make(resolver) as! ServiceType
  }

  func makes<ServiceType>(_ type: ServiceType.Type) -> Bool {
    makes(type)
  }

  func made<ServiceType>(_ type: ServiceType, resolver: Resolver) {
    made(type, resolver)
  }
}
