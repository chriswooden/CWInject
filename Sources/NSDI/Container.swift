import Foundation

public class Container: Resolver {
  private var factories: [ServiceKey: ServiceFactoryWrapper]
  private var resolutionPool = ResolutionPool()

  public init() {
    factories = [:]
  }

  @discardableResult public func register<T>(_ type: T.Type, id: String? = nil, scope: ObjectScope = .prototype, factory: @escaping (Resolver) -> T, initCompleted: ((T, Resolver) -> Void)? = nil) -> Container {
    let key = ServiceKey(serviceType: type, id: id, scope: scope)
    assert(factories[key] == nil, "Pre-existing service registration for type, supply a uniqie id to regitser multiple services for the same type")
    let newFactory = ServiceFactory<T>(make: { factory($0) }, made: { initCompleted?($0, $1) })
    factories[key] = newFactory.wrapped
    return self
  }

  public func resolve<T>(_ type: T.Type, id: String? = nil) -> T {
    guard let key = (Array(factories.keys).first { $0.serviceType == T.self && $0.id == id }) else {
      assert(false, "Cannot resolve dependency of type: \(T.self), id: \(String(describing: id)). Ensure a registration exists")
    }
    guard let factory = factories[key] else {
      assert(false, "Cannot resolve dependency of type: \(T.self), id: \(String(describing: id)). Ensure a registration exists")
    }
    return resolve(key: key, factory: factory)
  }

  private func resolve<T>(key: ServiceKey, factory: ServiceFactoryWrapper) -> T {
    return resolutionPool.resolve { () -> T in
      if let previouslyResolved = resolutionPool.resolved[key] as? T {
        return previouslyResolved
      } else {
        let resolvedService = factory.make(resolver: self) as Any
        if let previouslyResolved = resolutionPool.resolved[key] as? T {
          return previouslyResolved
        }
        resolutionPool.resolved[key] = resolvedService
        factory.made(resolvedService, resolver: self)
        return resolvedService as! T
      }
    }
  }
}

private class ResolutionPool {
  var resolved: [ServiceKey: Any] = [:]
  private var depth = 0

  func resolve<T>(factory: () -> T) -> T {
    depth = depth + 1
    defer {
      depth = depth - 1
      if depth == 0 {
        resolved.forEach {
          if $0.key.scope != .singleton {
            resolved.removeValue(forKey: $0.key)
          }
        }
      }
    }
    return factory()
  }
}
