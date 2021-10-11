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
