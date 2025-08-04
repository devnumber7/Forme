import SwiftUI

/// A SwiftUI view that renders a form based on a `FormSchema` and manages its submission state.
///
/// Use `FormView` to display fields defined in a schema and handle validation, touched state,
/// and submission via a `FormModel`.
public struct FormView<Content: View>: View {
    // MARK: - Public Properties

    /// The form model that holds values, validation state, and touched flags.
    @ObservedObject public var model: FormModel

    /// The schema that defines which fields to render and in what order.
    public let schema: FormSchema

    /// An optional closure to customize how each field is rendered.
    private let fieldContent: ((FormElement, FormModel) -> Content)?

    // MARK: - Initializers

    /// Creates a `FormView` with a given model and schema, using default field rendering.
    ///
    /// - Parameters:
    ///   - model: The `FormModel` instance managing form data.
    ///   - schema: The `FormSchema` defining form structure.
    public init(model: FormModel, schema: FormSchema) {
        self.model = model
        self.schema = schema
        self.fieldContent = nil
    }

    /// Creates a `FormView` with a custom field rendering closure.
    ///
    /// - Parameters:
    ///   - model: The `FormModel` instance managing form data.
    ///   - schema: The `FormSchema` defining form structure.
    ///   - fieldContent: A closure that takes a `FormElement` and its `FormModel` and returns a custom view for that field.
    public init(
        model: FormModel,
        schema: FormSchema,
        @ViewBuilder fieldContent: @escaping (FormElement, FormModel) -> Content
    ) {
        self.model = model
        self.schema = schema
        self.fieldContent = fieldContent
    }

    // MARK: - View Body

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Render each form field
                ForEach(schema.fields) { element in
                    renderField(element)
                }

                // Render the submit button
                renderSubmitButton()
            }
            .padding()
            .scrollDismissesKeyboard(.interactively)
        }
    }

    // MARK: - Private Helpers

    /// Renders a single form field using either the custom renderer or the default implementation.
    ///
    /// - Parameter element: The `FormElement` to render.
    /// - Returns: A view representing the form field.
    @ViewBuilder
    private func renderField(_ element: FormElement) -> some View {
        if let custom = fieldContent {
            custom(element, model)
        } else {
            // Default renderer just calls the FormElement's render closure
            element.renderView(model: model)
        }
    }

    /// Renders the default submit button, which marks all fields as touched and disables itself when invalid.
    ///
    /// - Returns: A view for the submit button.
    @ViewBuilder
    private func renderSubmitButton() -> some View {
        Button(action: handleSubmit) {
            Text("Submit")
                .frame(maxWidth: .infinity)
                .padding()
                .background(model.isValid() ? Color.accentColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .disabled(!model.isValid())
    }

    /// Called when the submit button is tapped. Marks all fields as touched,
    /// triggering validation messages to appear.
    private func handleSubmit() {
        model.validateAll()
    }
}
