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

  func test_registerInstance_addsNewAssembly() {
    struct Shared {}
    let container = Container().register(instance: Shared())
    XCTAssertEqual(container.assemblies.count, 1)
  }

  func test_registerFactory_addsNewAssembly() {
    struct Service {}
    let container = Container().register { _ in Service() }
    XCTAssertEqual(container.assemblies.count, 1)
  }

  func test_resolve_registeredInstance_resolvesCorrectInstance() {
    struct Shared: Equatable {}
    let sharedInstance = Shared()
    let container = Container().register(instance: sharedInstance)
    XCTAssertEqual(container.resolve(Shared.self), sharedInstance)
  }

  func test_resolve_registeredFactory_resolvesCorrectType() {
    struct Service: Equatable {}
    let serviceInstance = Service()
    let container = Container().register(instance: serviceInstance)
    XCTAssertEqual(container.resolve(Service.self), serviceInstance)
  }

  func test_resolve_noRegistration_returnsNil() {
    struct Service {}
    let container = Container()
    XCTAssertNil(container.resolve(Service.self))
  }
}
