//
//  PickerField.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//


import SwiftUI

/// A form field that renders a SwiftUI `Picker` bound to a `String` value.
public struct PickerField: @preconcurrency FormField {

    // MARK: – Stored Properties
    public let key: String
    public let label: String
    public let options: [String]          // the selectable values
    public let defaultValue: String
    public let validators: [Validator]

    // MARK: – Initializer
    public init(
        key: String,
        label: String,
        options: [String],
        defaultValue: String = "",
        validators: [Validator] = []
    ) {
        self.key = key
        self.label = label
        self.options = options
        self.defaultValue = defaultValue
        self.validators = validators
    }

    // MARK: – FormField
    @MainActor
    public func intoFormElement() -> FormElement {
        FormElement(id: key) { model in
            AnyView(
                VStack(alignment: .leading, spacing: 6) {
                    Text(label)
                        .font(.headline)

                    Picker(selection: Binding<String>(
                        get: {
                            (model.value(for: key) as? String) ?? defaultValue
                        },
                        set: { newValue in
                            model.setValue(newValue, for: key)
                            model.markTouched(for: key)
                        }
                    )) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    } label: {
                        Text(label)    // accessibility label
                    }
                    .pickerStyle(.menu)

                    // Live validation error, shown only after first interaction
                    if model.isTouched(key), let error = model.error(for: key) {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.2), value: error)
                    }
                }
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
            )
        }
    }
}
