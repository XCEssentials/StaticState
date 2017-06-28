import Foundation

/**
 Allows to track current state of each individual instance of any type that conforms to this protocol. It does not require to implement anything, but adds special dynamic instance level property `state`.
 */
public
protocol Stateful: class
{
    var state: State? { get set }
}
