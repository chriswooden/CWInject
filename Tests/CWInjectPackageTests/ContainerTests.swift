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
    let container = Container().register(instance: sharedInstance)
    XCTAssertEqual(container.resolve(Shared.self), sharedInstance)
  }

  func test_resolve_registeredFactory_resolvesCorrectType() {
    struct Service: Equatable {}
    let serviceInstance = Service()
    let container = Container().register(factory: { _ in Service() }, initCompleted: nil)
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
    container.register(factory: { resolver -> Parent in
      parent
    }, initCompleted: { parent, resolver in
      parent.child = resolver.resolve(Child.self)
    })
    container.register(factory: { _ -> Child in
      child
    }, initCompleted: { child, resolver in
      child.parent = resolver.resolve(Parent.self)
    })
    let resolvedParent = container.resolve(Parent.self)
    let resolvedChild = container.resolve(Child.self)
    XCTAssertEqual(resolvedParent?.child, child)
    XCTAssertEqual(resolvedChild?.parent, parent)
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
