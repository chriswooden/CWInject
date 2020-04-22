//
//  ServiceKey.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

struct ServiceKey {
  let serviceType: Any.Type
  let id: String?
}

extension ServiceKey: Hashable {
  static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
    lhs.serviceType == rhs.serviceType && lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    ObjectIdentifier(serviceType).hash(into: &hasher)
    id?.hash(into: &hasher)
  }
}
