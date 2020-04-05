# CWInjectPackage

CWInject is a lightweight depedndency injection framework for Swift apps, allowing for loosely-coupled components, which can then be maintained and tested more easily.

## DI Container

[Dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) (DI) is a software design pattern that uses inversion of control (IoC) for resolving dependencies. A DI container manages the type dependencies of your system. First, you register the types that should be resolved, with their dependencies. Then you use the DI container to get instances of those types whose dependencies are then automatically resolved by the DI container. In CWInject, the `Container` class represents the DI container.

### Registration in a DI Container

Here is an example of service registration:

```swift
let container = Container()
container.register(Animal.self) { _ in Cat(name: "Mimi") }
container.register(Person.self) { r in
    PetOwner(name: "Stephen", pet: r.resolve(Animal.self))
}
```

Where the protocols and classes are:

```swift
protocol Animal {
  var name: String { get }
}
protocol Person {
  var name: String { get }
}

class Cat: Animal {
  let name: String

  init(name: String) {
      self.name = name
  }
}

class PetOwner: Person {
  let name: String
  let pet: Animal

  init(name: String, pet: Animal) {
      self.name = name
      self.pet = pet
  }
}
```

After you register the components, you can get service instances from the container by calling the `resolve` method. It returns resolved components with the specified service (protocol) types.

```swift
let animal = container.resolve(Animal.self)
let person = container.resolve(Person.self)
let pet = (person as! PetOwner).pet

print(animal.name) // prints "Mimi"
print(animal is Cat) // prints "true"
print(person.name) // prints "Stephen"
print(person is PetOwner) // prints "true"
print(pet.name) // prints "Mimi"
print(pet is Cat) // prints "true"
```

Note that attempting to resolve a dependency that has not first been registered will lead to an assertion failure, as this is considered an invalid condition.

### Named Registration in a DI Container

If you would like to register two or more components for a service type, you can supply an id in the registrations to differentiate.

```swift
let container = Container()
container.register(Animal.self, id: "cat") { _ in Cat(name: "Mimi") }
container.register(Animal.self, id: "dog") { _ in Dog(name: "Hachi") }
```

Then you can get the service instances with the registered names:

```swift
let cat = container.resolve(Animal.self, id: "cat")!
let dog = container.resolve(Animal.self, id: "dog")!

print(cat.name) // prints "Mimi"
print(cat is Cat) // prints "true"
print(dog.name) // prints "Hachi"
print(dog is Dog) // prints "true"
```

Where `Dog` class is:

```swift
class Dog: Animal {
  let name: String

  init(name: String) {
      self.name = name
  }
}
```

## Circular Dependencies

_Circular dependencies_ are dependencies of instances that depend on each other. To define circular dependencies in CWInject, both of the dependencies must be injected through a property.

### Property/Property Dependencies

Assume that you have the following classes depending on each other, each via a property:

```swift
protocol ParentProtocol: AnyObject { }
protocol ChildProtocol: AnyObject { }

class Parent: ParentProtocol {
  var child: ChildProtocol?
}

class Child: ChildProtocol {
  weak var parent: ParentProtocol?
}
```

The circular dependencies are defined as below:

```swift
let container = Container()
container.register(Parent.self, factory: {
  Parent()
}, initCompleted: { parent, resolver in
  parent.child = resolver.resolve(ChildProtocol.self)
})
container.register(ChildProtocol.self, factory: {
  Child()
}, initCompleted: { child, resolver in
  child.parent = resolver.resolve(ParentProtocol.self)
})
```

Here both of the depending properties must be specified in the `initCompleted` callback to avoid infinite recursion and ensure both resolutions are complete.


### Initializer/Property Dependencies

_Currently Not supported._
