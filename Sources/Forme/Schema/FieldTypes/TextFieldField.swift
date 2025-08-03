//
//  TextFieldTypes.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//


import SwiftUI

public struct TextFieldField: @preconcurrency FormField {
    public let key: String
    public let label: String
    public let placeholder: String
    public let defaultValue: String
    public let validators: [Validator]

    public init(
        key: String,
        label: String,
        placeholder: String = "",
        defaultValue: String = "",
        validators: [Validator] = []
    ) {
        self.key = key
        self.label = label
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.validators = validators
    }

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
