import SwiftUI

/// A model object that owns form state and publishes changes for SwiftUI views.
///
/// `FormModel` tracks:
///  - User-entered values (`values`)
///  - Which fields have been interacted with (`touched`)
///  - Schema metadata for each field (`schema`)
///
/// You bind SwiftUI controls to this model, ask it to validate or serialize,
/// and it keeps everything in sync on the main actor.
@MainActor
public final class FormModel: ObservableObject {
    
    /// The current values for each field, keyed by field identifier.
    @Published public var values: [String: Any] = [:]
    
    /// Metadata for each registered field, including validators and defaults.
    private var schema: [String: FieldSchema] = [:]
    
    /// Tracks whether each field has been touched (user interacted with it).
    @Published public var touched: [String: Bool] = [:]
    
    
    // MARK: - Binding API
    
    /// Returns a two‐way binding to a `String` value for the given field key.
    ///
    /// - Parameter key: The unique identifier of the text field.
    /// - Returns: A `Binding<String>` that reads from and writes to `values[key]`.
    public func stringBinding(forField key: String) -> Binding<String> {
        Binding(
            get: { self.values[key] as? String ?? "" },
            set: { self.values[key] = $0 }
        )
    }
    
    
    // MARK: - Field Registration
    
    /// Registers a field’s schema metadata under the given key.
    ///
    /// - Parameters:
    ///   - key: The unique identifier for the field.
    ///   - schema: A `FieldSchema` containing default value, validators, and serializer.
    public func registerField(key: String, schema: FieldSchema) {
        self.schema[key] = schema
        // Optionally initialize default value:
        if values[key] == nil {
            values[key] = schema.defaultValue
        }
    }
    
    
    // MARK: - Touched State
    
    /// Marks the specified field as touched (user has interacted with it).
    ///
    /// - Parameter key: The unique identifier of the field to mark.
    public func markTouched(for key: String) {
        touched[key] = true
    }
    
    /// Returns whether the specified field has been marked as touched.
    ///
    /// - Parameter key: The unique identifier of the field.
    /// - Returns: `true` if the field is touched; otherwise `false`.
    public func isTouched(_ key: String) -> Bool {
        return touched[key] == true
    }
    
    
    // MARK: - Validation
    
    /// Returns the first validation error message for the given field, if any.
    ///
    /// - Parameter key: The unique identifier of the field to validate.
    /// - Returns: A `String` error message if validation fails, or `nil` if valid or unregistered.
    public func error(for key: String) -> String? {
        guard let fieldSchema = schema[key] else {
            return nil
        }
        let rawValue = values[key] ?? fieldSchema.defaultValue
        return fieldSchema.validate(rawValue)
    }
    
    /// Returns whether *all* registered fields currently validate successfully.
    ///
    /// - Returns: `true` if every field’s `validate(_:)` returns `nil`; otherwise `false`.
    public func isValid() -> Bool {
        for (key, fieldSchema) in schema {
            let rawValue = values[key] ?? fieldSchema.defaultValue
            if fieldSchema.validate(rawValue) != nil {
                return false
            }
        }
        return true
    }
    
    /// Marks *all* registered fields as touched, causing validation errors to appear in the UI.
    public func validateAll() {
        for key in schema.keys {
            touched[key] = true
        }
    }
    
    
    // MARK: - Serialization
    
    /// Serializes all field values according to each field’s `FieldSerializable` logic.
    ///
    /// - Returns: A dictionary of field keys to serialized values (omitting any that return `nil`).
    public func serializeAll() -> [String: Any] {
        var output: [String: Any] = [:]
        for (key, fieldSchema) in schema {
            let rawValue = values[key] ?? fieldSchema.defaultValue
            if let serialized = fieldSchema.serialize(rawValue) {
                output[key] = serialized
            }
        }
        return output
    }
    
    
    // MARK: - Reset & Direct Access
    
    /// Resets the touched state for all fields without altering their current values.
    public func reset() {
        for key in touched.keys {
            touched[key] = false
        }
    }
    
    /// Sets the raw value for a given field key.
    ///
    /// - Parameters:
    ///   - newValue: The new value to assign.
    ///   - key: The unique identifier of the field.
    public func setValue(_ newValue: Any, for key: String) {
        values[key] = newValue
    }
    
    /// Returns the current value for a field, or its default if unset.
    ///
    /// - Parameter key: The unique identifier of the field.
    /// - Returns: The user-entered value, or the `FieldSchema`’s `defaultValue`, or `nil` if unregistered.
    public func value(for key: String) -> Any? {
        if let v = values[key] {
            return v
        }
        return schema[key]?.defaultValue
    }
}
