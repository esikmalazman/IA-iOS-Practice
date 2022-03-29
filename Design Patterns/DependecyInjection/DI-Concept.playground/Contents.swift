//: A UIKit based Playground for presenting user interface
// https://cocoacasts.com/dependency-injection-in-swift

import UIKit


//MARK: - Example 1
// Object
final class RequestManager{}
// Sample VC that declare a requestManager property with type RequestManager
final class VC1 : UIViewController {
    var requestManager : RequestManager?
}

// Set property value without DI
/// - Task VC to initialize request manager property (VC responsible creating requestManager object)
/// - The VC know the behaviour and initialisation of requestManager object
final class SetWithoutDI : UIViewController {
    lazy var requestManager : RequestManager? = RequestManager()
}

// Set property value with DI
/// Inject copy of RequestManager object into VC
/// The VC do not know the initialisation of the object
final class SetWithDI : UIViewController {
    var requestManager : RequestManager?
}
/// Init VC
let vc = SetWithDI()
/// Configure VC and inject DI with property injection
vc.requestManager = RequestManager()

//MARK: - Sample 2
// Protocol with Type Serializer
protocol Serializer {
    func serialize(data : AnyObject) -> NSData?
}
// Object that implement Serializer protocol
final class RequestSerializer : Serializer {
    func serialize(data: AnyObject) -> NSData? {
        return NSData()
    }
}
// Initialize RequestSerializer object
let serializerObject = RequestSerializer()

/// Has a property serializer with type Serializer protocol
/// The class responsible to initiate the object with type Serializer
final class SetWithoutDIDataManager {
    var serializer : Serializer? = RequestSerializer()
}
/// The class no longer responsible to initiate RequestSerializer object
/// Allow to easily replace RequestSerializer object with other object as long it implement Serializer protocol
final class SetWithDIDataManager {
    var serializer : Serializer?
}

let dataManager = SetWithDIDataManager()
/// Inject DI with property injection
dataManager.serializer = RequestSerializer()


//MARK: - Benefits
///  1. Transparency
///  - By use DI into object, the responsible and requirement on class more clear
///  - By inject a RequestManager into VC, we can see VC depends on RequestManager and can assume VC is responsible for Managing/Handling
///
///  2. Testing
///  - Allow easier to make Unit Test to set up and isolate behaviour
///  - Easy to replace dependencies object with Mock object

/// Create mock class that implement Serializer protocol
final class MockRequestSerializer : Serializer {
    func serialize(data: AnyObject) -> NSData? {
        return NSData()
    }
}
let mockDataManager = SetWithDIDataManager()
/// Serializer in MockDataManger can be set is due to MockRequestSerializer object conform to Serializer protocol
mockDataManager.serializer = MockRequestSerializer()


/// 3. Separation of concerns
/// - The class  does not responsible to initialize dependency object, even it know the behaviour of the object
/// - If class responsible to initialize to many dependencies VC it can be very messy and hard to test
///
/// 4. Coupling
/// - DI allow to use the power of protocol and reduce coupling in class/object/project

//MARK: - Types
/// 1. Initializer Injection
/// - Pass the dependencies during initialization
/// - Allow dependencies of initialization become immutable
final class DI_InializerDataManager {
    // Property cannot be mutated
    private let serializer : Serializer
    // Guarantee copy of DataManager with type Serializer installed correctly
    init(serializer : Serializer) {
        self.serializer = serializer
    }
}

// Initialize data manager with DI initializer injection
// Only have one way to set serializer property is by pass it during initialization
let di_InitializerDataManager = DI_InializerDataManager(serializer: serializerObject)

/// 2. Property Injection
/// - Dependencies are injected through property oin class/struct that require dependencies
/// - Dependecies can be mutabale(modified/replaced)
/// - Best DI options when using Storyboards, due to it does not allow to inject custom initializer
final class DI_PropertyDataManager {
    var requestManager : RequestManager?
}
// Initialize vc
let di_PropertyDataManager = DI_PropertyDataManager()
// Inject dependencies with properties
di_PropertyDataManager.requestManager = RequestManager()
/// 3. Method Injection
/// - Dependencies can be injected when they needed
/// - DI injected through method that accept dependency as parameter
/// - Parent object lose control at dependencies(Serializer Type Object) but this type of DI provide flexibility
final class DI_MethodDataManager {
    /// Serializer type were injected through arguement of the method
    func serializeRequest(with serializer : Serializer)-> NSData? {
        return serializer.serialize(data: NSData())
    }
}

let di_MethodDataManager = DI_MethodDataManager()
// DI injected through method
di_MethodDataManager.serializeRequest(with: RequestSerializer())
