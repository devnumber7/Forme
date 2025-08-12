//
//  TextFieldTypes.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//


import SwiftUI

/// A form field that renders a single-line text input with an optional label,
/// placeholder, default value, and validation rules.
///
/// `TextFieldField` integrates with the form model by registering its schema on
/// appearance and keeping the model value in sync with the SwiftUI `TextField`.
/// Validation errors are surfaced beneath the field once the user has interacted
/// with it (i.e., when the field is marked as "touched").
///
/// ### Example
/// ```swift
/// let name = TextFieldField(
///     key: "name",
///     label: "Name",
///     placeholder: "Jane Appleseed",
///     defaultValue: "",
///     validators: [NonEmptyValidator()]
/// )
///
/// // In your view builder:
/// name.intoFormElement()
/// ```
public struct TextFieldField: @preconcurrency FormField {
    
    /// A stable identifier used to store and retrieve this field's value from the
    /// form model. Must be unique within a form.
    public let key: String
    
    /// The user-visible label displayed above the text field.
    public let label: String
    
    /// Hint text shown inside the text field when no value is present.
    public let placeholder: String
    
    /// The initial value seeded into the form model if no value has been provided.
    public let defaultValue: String
    
    /// An ordered list of validation rules evaluated against the field's raw value.
    /// The first validator to return a non-`nil` message is presented as the error.
    public let validators: [Validator]

    /// Creates a text field form component.
    ///
    /// - Parameters:
    ///   - key: A unique identifier used to persist this field's value in the model.
    ///   - label: The user-facing label rendered above the control.
    ///   - placeholder: Hint text shown when the field is empty. Defaults to an empty string.
    ///   - defaultValue: The initial value to seed into the model. Defaults to an empty string.
    ///   - validators: Validation rules to apply to the value. Defaults to an empty array.
    public init( key: String, label: String, placeholder: String = "",
                 defaultValue: String = "", validators:[Validator] = []) {
        self.key = key
        self.label = label
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.validators = validators
    }

    /// Builds the renderable `FormElement` for this field.
    ///
    /// The element registers a `FieldSchema` with the provided model on appearance
    /// and keeps the model's value synchronized with the SwiftUI `TextField`.
    ///
    /// - Returns: A `FormElement` that renders the labeled text field, displays
    ///   validation errors when present, and participates in the form lifecycle.
    @MainActor public func intoFormElement() -> FormElement {
        FormElement(id: key) { model in
            AnyView(
                VStack(alignment: .leading, spacing: 6) {
                Text(label)
                    .font(.headline)

                TextField(placeholder, text: model.stringBinding(forField: key))
                    .textFieldStyle(.roundedBorder)
                    .onAppear {
                        model.registerField(
                            key: key,
                            schema: FieldSchema(
                                key: key,
                                defaultValue: defaultValue,
                                validator: validators
                            )
                        )
                    }
                    .onChange(of: model.value(for: key) as? String ?? "") { _ in
                        model.markTouched(for: key)
                    }

                if model.isTouched(key), let error = model.error(for: key) {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: error)
                }
            })
       
        }
    }
}
