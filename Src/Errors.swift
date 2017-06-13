import Foundation

//===

/**
 Enclosing type/scope for all errors that are used in this library.
 */
public
enum Errors // scope
{
    /**
     Thrown by pre-implemented functions of `StatefulWithHelpers` protocol when current state is not the same as expected one.
     */
    public
    struct WrongState: Error { }
}
