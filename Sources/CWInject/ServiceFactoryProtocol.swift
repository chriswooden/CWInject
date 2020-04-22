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
  func make(resolver: Resolver) -> ServiceType
  func made(_ service: ServiceType, resolver: Resolver)
}

extension ServiceFactoryProtocol {
  var wrapped: ServiceFactoryWrapper {
    ServiceFactoryWrapper(self)
  }
}
