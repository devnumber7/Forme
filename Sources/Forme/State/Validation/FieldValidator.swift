
/// A “rule” that checks one raw field value and returns a validation error
/// - Parameter value: the untyped field value to inspect
/// - Returns: an error message if invalid, or `nil` if valid
public protocol FieldValidator{
    func validate(_ value: Any) -> String?
}
