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
     class MyView: Stateful
     {
        struct Normal: State
        {
            typealias Owner = MyView
        }
     
        struct Highlighted: State
        {
            typealias Owner = MyView
     
            let color: Int
        }
     
        var state: Any?
     }
     
     let aView = MyView()
     
     aView.state = MyView.Normal()
     aView.state = MyView.Highlighted(color: 1)
     print(aView.state) // MyView.Highlighted(color: 1)
     ```
     */
    var state: Any? { get set }
}

//===

extension Stateful
{
    /**
     Allows to set current state to `newState`.
     
     Use as follows:
     
     ```swift
     class MyView: Stateful
     {
         struct Disabled: State
         {
             typealias Owner = MyView
             
             var opacity: Float
         }
     
         var state: Any?
     }
     
     let aView = MyView()
     
     aView.set(MyView.Disabled(opacity: 0.3))
     ```
     
     - Parameter newState: An instance of type that conforms to `State` protocol, or `nil`. This value will be set as new current state.
     */
    func set<Input>(_ newState: Input?) where
        Input: State,
        Input.Owner == Self
    {
        state = newState
    }
    
    /**
     Provides read-only access to the `state` property value from `Stateful` protocol.
     
     Use as follows:
     
     ```swift
     class MyView: Stateful
     {
        var state: State?
     }
     
     let aView = MyView()
     
     let current = aView.currentState() // same as access 'aView.state' directly
     ```
     
     - Returns: Current state without conversion to a specific state type, if it's set, or `nil` otherwise.
     */
    func currentState() -> Any?
    {
        return state
    }
    
    /**
     Allows to mutate current state, if it's of `ExpectedState` type.
     
     Use as follows:
     
     ```swift
     class MyView: Stateful
     {
        struct Disabled: State
        {
            typealias Owner = MyView
     
            var opacity: Float
        }
         
        var state: Any?
     }
     
     let aView = MyView()
     
     try? aView.update(MyView.Disabled.self){
     
        $0.opacity += 0.1
     }
     ```
     
     - Parameter expected: Expected current state type.
     - Parameter mutation: Closure that will be used to mutate current state.
     
     - Throws: `Errors.WrongState` if current state is NOT of `expected` type.
     */
    func update<ExpectedState>(
        _ expected: ExpectedState.Type,
        mutation: (inout ExpectedState) -> Void
        ) throws
        where
        ExpectedState: State,
        ExpectedState.Owner == Self
    {
        if
            var result = state as? ExpectedState
        {
            mutation(&result)
            state = result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    /**
     Allows to mutate current state, if it's of `ExpectedState` type.
     
     Use as follows:
     
     ```swift
     class MyView: Stateful
     {
        struct Disabled: State
        {
            typealias Owner = MyView
     
            var opacity: Float
        }
     
        var state: Any?
     }
     
     let aView = MyView()
     
     try? aView.update{ (disabled: inout MyView.Disabled) in
     
        disabled.opacity += 0.1
     }
     ```
     
     - Parameter mutation: Closure that will be used to mutate current state.
     
     - Throws: `Errors.WrongState` if current state is NOT of `expected` type.
     */
    func update<ExpectedState>(
        _ mutation: (inout ExpectedState) -> Void
        ) throws
        where
        ExpectedState: State,
        ExpectedState.Owner == Self
    {
        if
            var result = state as? ExpectedState
        {
            mutation(&result)
            state = result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    /**
     Sets current state to `nil`.
     */
    func resetCurrentState()
    {
        return state = nil
    }
}

//===

public
typealias SSTStateful = Stateful
