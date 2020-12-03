import Foundation

struct ServiceKey {
  let serviceType: Any.Type
  let id: String?
  let scope: ObjectScope
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
