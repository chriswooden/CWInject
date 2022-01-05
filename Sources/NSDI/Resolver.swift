import Foundation

public protocol Resolver {
  func resolve<T>(_ type: T.Type, id: String?) throws -> T
}

public extension Resolver {
  func resolve<T>(_ type: T.Type, id: String? = nil) throws -> T {
    try resolve(type, id: id)
  }
}
