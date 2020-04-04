//
//  ContainerTests.swift
//  CWInjectTests
//
//  Created by Christopher Wooden on 04/04/2020.
//  Copyright © 2020 Christopher Wooden. All rights reserved.
//

@testable import CWInjectPackage
import Foundation
import XCTest

class ContainerTests: XCTestCase {
  func test_resolve_registeredInstance_resolvesCorrectInstance() {
    struct Shared: Equatable {}
    let sharedInstance = Shared()
    let container = Container().register(Shared.self, instance: sharedInstance)
    XCTAssertEqual(container.resolve(Shared.self), sharedInstance)
  }

  func test_resolve_registeredFactory_resolvesCorrectType() {
    struct Service: Equatable {}
    let serviceInstance = Service()
    let container = Container().register(Service.self, factory: { _ in Service() }, initCompleted: nil)
    XCTAssertEqual(container.resolve(Service.self), serviceInstance)
  }

  func test_resolve_noRegistration_returnsNil() {
    struct Service {}
    let container = Container()
    XCTAssertNil(container.resolve(Service.self))
  }

  func test_resolve_circularDependencies_usesInitCompleted() {
    let container = Container()
    let parent = Parent()
    let child = Child()
    container.register(Parent.self, factory: { resolver -> Parent in
      parent
    }, initCompleted: { parent, resolver in
      parent.child = resolver.resolve(Child.self)
    })
    container.register(Child.self, factory: { _ -> Child in
      child
    }, initCompleted: { child, resolver in
      child.parent = resolver.resolve(Parent.self)
    })
    let resolvedParent = container.resolve(Parent.self)
    let resolvedChild = container.resolve(Child.self)
    XCTAssertEqual(resolvedParent?.child, child)
    XCTAssertEqual(resolvedChild?.parent, parent)
  }

  func test_resolve_multipleRegistrationsOfType_usesIDToDisambiguate() {
    struct Service: Equatable {
      let id: String
    }
    let container = Container().register(Service.self, id: "serviceA", factory: { _ in Service(id: "A") }, initCompleted: nil)
    container.register(Service.self, id: "serviceB", factory: { _ in Service(id: "B") }, initCompleted: nil)
    XCTAssertEqual(container.resolve(Service.self, id: "serviceA"), Service(id: "A"))
    XCTAssertEqual(container.resolve(Service.self, id: "serviceB"), Service(id: "B"))
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
