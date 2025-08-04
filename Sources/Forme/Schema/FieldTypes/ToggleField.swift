import SwiftUI

/// A form field that renders a SwiftUI `Toggle` and binds it to a `Bool` value
/// in the `FormModel`.
public struct ToggleField: @preconcurrency FormField {

    // MARK: - Stored Properties
    public let key: String
    public let label: String
    public let defaultValue: Bool
    public let validators: [Validator]

    // MARK: - Initializer
    public init(
        key: String,
        label: String,
        defaultValue: Bool = false,
        validators: [Validator] = []
    ) {
        self.key = key
        self.label = label
        self.defaultValue = defaultValue
        self.validators = validators
    }

    // MARK: - FormField
    /// Wraps itself in a `FormElement` so it can be stored in a `FormSchema`
    /// and rendered generically by `FormView`.
    @MainActor
    public func intoFormElement() -> FormElement {
        FormElement(id: key) { model in
            AnyView(
                Toggle(isOn: Binding<Bool>(
                    get: {
                        (model.value(for: key) as? Bool) ?? defaultValue
                    },
                    set: { newValue in
                        model.setValue(newValue, for: key)
                        model.markTouched(for: key)
                    }
                )) {
                    Text(label)
                }
                .toggleStyle(.switch)
                .onAppear {
                    // Register the field with its schema the first time it appears.
                    model.registerField(
                        key: key,
                        schema: FieldSchema(
                            key: key,
                            defaultValue: defaultValue,
                            validator: validators
                        )
                    )
                }
                .padding(.vertical, 4)
            )
        }
    }
}
