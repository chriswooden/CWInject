@testable import NSDI
import Foundation
import XCTest

class ContainerTests: XCTestCase {
  func test_resolve_singleton_resolvesCorrectInstance() throws {
    class Service: NSObject {}
    let container = Container().register(Service.self, scope: .singleton, factory: { _ in Service() }, initCompleted: nil)
    XCTAssertEqual(try container.resolve(Service.self), try container.resolve(Service.self))
  }

  func test_resolve_prototype_resolvesCorrectType() throws {
    struct Service: Equatable {}
    let serviceInstance = Service()
    let container = Container().register(Service.self, factory: { _ in Service() }, initCompleted: nil)
    XCTAssertEqual(try container.resolve(Service.self), serviceInstance)
  }

  func test_resolve_circularDependencies_injectorToPropertyInjection_resolvesBothDependencies() throws {
    let container = Container()
    container.register(Parent.self, factory: { resolver in
      Parent(child: try! resolver.resolve(Child.self))
    })
    container.register(Child.self, factory: { _ in
      Child()
    }, initCompleted: { child, resolver in
      child.parent = try! resolver.resolve(Parent.self)
    })

    let resolvedParent = try container.resolve(Parent.self)
    XCTAssertNotNil(resolvedParent)
    XCTAssertNotNil(resolvedParent.child)
    XCTAssertEqual(resolvedParent, resolvedParent.child?.parent)
  }

  func test_resolve_circularDependencies_propertyToPropertyInjection_resolvesBothDependencies() throws {
    let container = Container()
    container.register(Parent.self, factory: { _ in
      Parent()
    }, initCompleted: { parent, resolver in
      parent.child = try! resolver.resolve(Child.self)
    })
    container.register(Child.self, factory: { _ in
      Child()
    }, initCompleted: { child, resolver in
      child.parent = try! resolver.resolve(Parent.self)
    })
    let resolvedParent = try container.resolve(Parent.self)
    XCTAssertNotNil(resolvedParent)
    XCTAssertNotNil(resolvedParent.child)
    XCTAssertEqual(resolvedParent, resolvedParent.child?.parent)
  }

  func test_resolve_multipleRegistrationsOfType_usesIDToDisambiguate() throws {
    struct Service: Equatable {
      let id: String
    }
    let container = Container().register(Service.self, id: "serviceA", factory: { _ in Service(id: "A") }, initCompleted: nil)
    container.register(Service.self, id: "serviceB", factory: { _ in Service(id: "B") }, initCompleted: nil)
    XCTAssertEqual(try container.resolve(Service.self, id: "serviceA"), Service(id: "A"))
    XCTAssertEqual(try container.resolve(Service.self, id: "serviceB"), Service(id: "B"))
  }
}

class Parent: NSObject {
  var child: Child?
  init(child: Child? = nil) {
    self.child = child
  }
}

class Child: NSObject {
  weak var parent: Parent?
  init(parent: Parent? = nil) {
    self.parent = parent
  }
}
