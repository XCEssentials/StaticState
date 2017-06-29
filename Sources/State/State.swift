import Foundation

/**
 Conformance to this protocl turns the type into a state.
 */
public
protocol State: Equatable
{
    /**
     Reference-based type to which this state might be applied.
     */
    associatedtype Owner: AnyObject
    
    /**
     Unique identifier of the state.
     
     Having this on instance level gives opportunity to distinct different instances of the same type, if needed.
     
     Use as follows (assume the module name is "MyApp"):
     
     ```swift
     class MyView: UIView, Stateful
     {
         struct Normal: State { typealias Owner = MyView }
     }
     
     let aView = MyView()
     aView.state = MyView.Normal()
     print(type(of: aView.state).identifier) // MyApp.MyView.Normal
     ```
     */
    var identifier: String { get }
}

/**
 Default implementation of `Equatable` protocol.
 */
extension State
{
    public
    static
    func == (left: Self, right: Self) -> Bool
    {
        return left.identifier == right.identifier
    }
}

//===

public
extension State
{
    /**
     Default implementation of `identifier` instance level property is based on recommended behavior when any two instances of the same state have identical identifiers, regardless of any internal data/properties.
     */
    var identifier: String
    {
        return "Owner: \(String(reflecting: Owner.self)),"
            + " state: \(String(reflecting: type(of: self)))"
    }
}

//===

public
typealias SSTState = State
