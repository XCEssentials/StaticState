import Foundation

//===

/**
 Allows to track current state of each individual instance of any type that conforms to this protocol. It does not require to implement anything, but adds special dynamic instance level property `state`.
 */
public
protocol Stateful: class { }

//===

public
extension Stateful
{
    /**
     Current state of the object. When it's `nil`, then it means that current state is "undefined". This is a dynamic property, its life time is limited by lifetime of the object to which this property belongs and is completely independent from the same property of other instances of the same type.
     
     
     Use as follows:
     
     ```swift
     class MyView: UIView, Stateful
     {
         struct Normal: State { }
         struct Highlighted: State { let color: Int }
     }
     // ...
     let aView = MyView()
     // ...
     aView.state = MyView.Normal()
     aView.state = MyView.Highlighted(color: 1)
     print(aView.state) // MyView.Highlighted(color: 1)
     ```
     */
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
