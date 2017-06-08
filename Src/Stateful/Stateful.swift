import Foundation

//===

public
protocol Stateful: class { }

//===

public
extension Stateful
{
    var state: State?
    {
        get
        {
            return StateWrapper.get(for: self).current
        }
        
        set(newState)
        {
            StateWrapper.get(for: self).current = newState
        }
    }
}
