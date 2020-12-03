import Foundation

final class ServiceFactoryWrapper {
  private let make: (Resolver) -> Any
  private let made: ((Any, Resolver) -> Void)

  init<T: ServiceFactoryProtocol>(_ factory: T) {
    self.make = { factory.make(resolver: $0) }
    self.made = { factory.made($0 as! T.ServiceType, resolver: $1) }
  }

  func make<ServiceType>(resolver: Resolver) -> ServiceType {
    make(resolver) as! ServiceType
  }

  func made<ServiceType>(_ type: ServiceType, resolver: Resolver) {
    made(type, resolver)
  }
}
