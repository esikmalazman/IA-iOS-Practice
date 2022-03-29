import UIKit

//MARK: - Adapter Design Pattern (Reference)  : https://medium.com/swiftcraft/swift-solutions-adapter-pattern-a2118a6a2910
///     Benefits
/// - Enable object with similar functionality to work together even having incompatible interfaces
/// - Allow integration that result code cleaner and easier

///     Use cases
/// - Component share similar functionality with existing objects in app
/// - The component has incompatible interface with other object in app (Often third party framework)
/// - Component source code cannot be modified
/// - Component need to integrate in app

//MARK: - 1. Adapter pattern(Swift Extensions Approach)

protocol Jumping {
    func jump()
}

class Dog : Jumping {
    func jump() {
        print("Dog jump")
    }
}

class Cat : Jumping {
    func jump() {
        print("Cat jump")
    }
}

let cat = Cat()
let dog = Dog()

/// The Adaptee
/// - Leaping from has similar function like dog and cat
/// - Even both of them jump, but the interfaces is differrent
/// - Frog need to call leap() instead of jump() to get same functionality

class Frog {
    func leap() {
        print("Leaps")
    }
}

/// The Adapter
/// - Integrate component by implement Adapter pattern
/// - Confrom frog class to Jumping and create a wrapper function to make other object recognize
/// - Enable to get same behaviour like cat and dog without change existing implementation

extension Frog : Jumping {
    func jump() {
        self.leap()
    }
}

let frog = Frog()

/// How object would work before and after we adapt the frog's interface

/// Before
/// The calles need to know explicit frog interface

var animalsWithoutAdapter : [Jumping] = [dog,cat]

func jumpAlls(animalsWithoutAdapter : [Jumping], frog : Frog? = nil) {
    for animal in animalsWithoutAdapter {
        animal.jump()
    }
    if let frog = frog {
        frog.leap()
    }
}

/// After
/// With adapter, we can treat frog like cat and dog
/// Simplify function without extra frog parameter
/// Under the hood, frog is still leap but the caller do not have any knowlege how the frog jump when it conform to Adapter

var animalsWithAdapter : [Jumping] = [dog,cat,frog]

func jumpAlls(animalsWithAdapter : [Jumping]) {
    for animals in animalsWithAdapter {
        animals.jump()
    }
}


//MARK: - 2. Adapter(Dedicated Adapter Approach)
/// Create an adapter class that hold foreign component in private property
/// Extending Frog object, maybe leading to more exposed to other objects
/// With dedicated Adapter, the caller does not need to manipulated Frog object directly, it can only use by what expose by FrogAdapter
/// Give complete control on what to expose to caller
class FrogAdapter : Jumping {
    private let frog = Frog()
    func jump() {
        frog.leap()
    }
}



