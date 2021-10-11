import Foundation

public protocol Resolver {
  func resolve<T>(_ type: T.Type, id: String?) -> T
}

public extension Resolver {
  func resolve<T>(_ type: T.Type, id: String? = nil) -> T {
    resolve(type, id: id)
  }
}
