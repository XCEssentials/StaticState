import Foundation

//===
/**
 Conformance to this protocl turns the type into a state.
 */
public
protocol State { }

//===

public
extension State
{
    /**
     Unique identifier of the state.
     
     Returns: An instance of `String` that contains full name of the type/state, inclduing module name and enclosing types (if this is a nested type).
     
     Use as follows (assume the module name is "MyApp"):
     
     ```swift
     class MyView: UIView, Stateful
     {
         struct Normal: State { }
     }
     
     let aView = MyView()
     aView.state = MyView.Normal()
     print(type(of: aView.state).identifier) // MyApp.MyView.Normal
     ```
     
     */
    static
    var identifier: String { return String(reflecting: self) }
}
