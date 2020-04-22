//
//  Resolver.swift
//  CWInject
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

import Foundation

public protocol Resolver {
  func resolve<T>(_ type: T.Type, id: String?) -> T
}

public extension Resolver {
  func resolve<T>(_ type: T.Type, id: String? = nil) -> T {
    resolve(type, id: id)
  }
}
