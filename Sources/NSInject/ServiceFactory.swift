import Foundation

struct ServiceFactory<ServiceType>: ServiceFactoryProtocol {
  private let make: (Resolver) -> ServiceType
  private let made: ((ServiceType, Resolver) -> Void)?

  init(make: @escaping (Resolver) -> ServiceType, made: ((ServiceType, Resolver) -> Void)?) {
    self.make = make
    self.made = made
  }

  func make(resolver: Resolver) -> ServiceType {
    make(resolver)
  }

  func made(_ service: ServiceType, resolver: Resolver) {
    made?(service, resolver)
  }
}
