//
//  Assembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

protocol ServiceFactoryProtocol {
  associatedtype ServiceType
  func make(_ resolver: Resolver) -> ServiceType
}

extension ServiceFactoryProtocol {
  func makes<T>(_ type: T.Type) -> Bool {
    type == ServiceType.self
  }

  var wrapped: ServiceFactoryWrapper {
    ServiceFactoryWrapper(self)
  }
}