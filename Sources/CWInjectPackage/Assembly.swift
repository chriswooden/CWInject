//
//  Assembly.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public protocol Assembly {
  associatedtype AssembledType
  func assemble(_ resolver: Resolver) -> AssembledType
}

extension Assembly {
  func supports<T>(_ type: T.Type) -> Bool {
    type == AssembledType.self
  }
}
