import Foundation

import XCEAssociatedStorage

//===
/**
 Class-based wrapper for instances of `State`-conforming types. Allows to store instances of value types by reference, necessary for placing value type based state instances into collections like `NSMapTable`.
 */
final
class StateWrapper
{
    /**
     The wrapped value itself. Can be updated/mutated during life time of the wrapper. It's `nil` in the beginning, until current state is set explicitly.
     */
    var current: State?
    
    //===
    
    /**
     This initializer does nothing, but it's declared private to ensure that the wrapper type won't be instantiated directly, the designated way of use of this class is via the static `get` function.
     */
    private
    init() { }
    
    //===
    
    /**
     Internal global storage of current states of all instances of all types that conform to `Stateful` protocol.
     */
    private
    static
    var storage = AssociatedStorage()
    
    //===
    
    /**
     Provides access to current state wrapper for the given object.
     
     It implements one-to-one relationship between instances of `State`-conforming types and their corresponding `StateWrapper` instances. It always returns the same `StateWrapper` instance for the same `obj` object. A `StateWrapper` instance that corresponds to a given `obj` object is being lazy initialized when a wrapper for this object is being accessed the very first time.
     
     - Parameter obj: The object for which we want to get its `StateWrapper` instance.
     
     - Returns: An instance of `StateWrapper` that corresponds to the given `obj` object.
     */
    static
    func get<Object: Stateful>(for obj: Object) -> StateWrapper
    {
        return storage.get(for: obj){ _ in return StateWrapper() }
    }
}

//===
