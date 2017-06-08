import Foundation

//===

final
class StateWrapper
{
    var current: State?
    
    //===
    
    private
    init() { }
    
    //===
    
    private
    static
    var storage = NSMapTable<AnyObject, StateWrapper>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    //===
    
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
