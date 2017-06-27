import Foundation

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
     This initializer does nothing, but it's declared private to ensure that the wrapper type won't be instantiated directly, the designated way of use of this class is by using the static `get` function.
     */
    private
    init() { }
    
    //===
    
    /**
     Internal global storage of current states of all instances of all types that conform to `Stateful` protocol.
     
     - Note: The storage is initialized with `keyOptions` set to `weakMemory` and `valueOptions` set to `strongMemory`, which means each value is being kept in this collection as long as the object that is used as key is being kept in memory; as soon as the `key` object is deallocated the whole record automatically being removed from the storage. It is supposed that the object for which we need to store current state is used as `key` and its current state, inserted in a wrapper, is used as `value`. This technique allows to automatically release current state wrapper from memory as soon as its object is deallocated.
     */
    private
    static
    var storage = NSMapTable<AnyObject, StateWrapper>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    //===
    
    /**
     Provides access to current state wrapper for the given object.
     
     To be more precise, it implements one-to-one relationship between instances of `State`-conforming types and their corresponding `StateWrapper` instances. It always returns the same `StateWrapper` instance for the same `obj` object. A `StateWrapper` instance that corresponds to a given `obj` object is being lazy initialized when a wrapper for this object is being accessed the very first time.
     
     - Parameter obj: The object for which we want to get its `StateWrapper` instance.
     
     - Returns: An instance of `StateWrapper` that corresponds to the given `obj` object.
     */
    static
    func get(for obj: AnyObject) -> StateWrapper
    {
        if
            let result = storage.object(forKey: obj)
        {
            return result
        }
        else
        {
            let result = StateWrapper()
            storage.setObject(result, forKey: obj)
            
            return result
        }
    }
}
