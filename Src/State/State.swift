import Foundation

//===

public
protocol State { }

//===

public
extension State
{
    static
    var id: String { return "\(self)" }
}
