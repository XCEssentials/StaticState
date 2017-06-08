import Foundation

//===

public
protocol DiscreteSystem: class { }

//===

public
extension DiscreteSystem
{
    public
    enum Errors // scope
    {
        public
        struct WrongState: Error { }
    }
}

//===

public
extension DiscreteSystem
{
    public
    var state: State.Wrapper
    {
        return State.Wrapper.get(for: self)
    }
    
    //===
    
    public
    func at<Input: State>(
        _: Input.Type
        ) throws -> Input
    {
        if
            let result = state.current as? Input
        {
            return result
        }
        else
        {
            throw DiscreteSystem.Errors.WrongState()
        }
    }
    
    //===
    
    public
    func update<Input: State>(
        _: Input.Type,
        mutation: (inout Input) -> Void
        ) throws
    {
        if
            var result = state.current as? Input
        {
            mutation(&result)
            state.current = result
        }
        else
        {
            throw DiscreteSystem.Errors.WrongState()
        }
    }
}
