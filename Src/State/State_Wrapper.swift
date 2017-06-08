import Foundation

//===

public
extension State
{
    final
    class Wrapper
    {
        public
        var current: State?
        
        //===
        
        private
        init() { }
        
        //===
        
        private
        static
        var storage = NSMapTable<AnyObject, Wrapper>(
            keyOptions: .weakMemory,
            valueOptions: .strongMemory
        )
        
        //===
        
        public
        static
        func get(for obj: AnyObject) -> Wrapper
        {
            if
                let result = storage.object(forKey: obj)
            {
                return result
            }
            else
            {
                let result = Wrapper()
                storage.setObject(result, forKey: obj)
                
                return result
            }
        }
    }
}
