import Foundation

/**
 Allows to track current state of each individual instance of any type that conforms to this protocol. It does not require to implement anything, but adds special dynamic instance level property `state`.
 */
public
protocol Stateful: class
{
    /**
     Current state of the object. When it's `nil`, then it means that current state is "undefined".
     
     
     Use as follows:
     
     ```swift
     class MyView: UIView, Stateful
     {
        struct Normal: State { }
        struct Highlighted: State { let color: Int }
     
        var state: State?
     }
     
     let aView = MyView()
     
     aView.state = MyView.Normal()
     aView.state = MyView.Highlighted(color: 1)
     print(aView.state) // MyView.Highlighted(color: 1)
     ```
     */
    var state: State? { get set }
}
