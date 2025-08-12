//
//  FormSchema.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

/// A schema that declares the fields and their order for a form.
///
/// `FormSchema` is a lightweight, immutable container that describes what a
/// form should render. You typically create it using the `@FormBuilder`
/// result builder, which keeps schema definitions concise and readable.
///
/// The first sentence is a one‑line summary per Swift API Design Guidelines.
/// The remainder provides context and usage details following Apple’s
/// documentation style. Use clear, active language and prefer terms your
/// API also uses (e.g., “field”, “schema”).
///
/// ### Example
///
/// ```swift
/// let schema = FormSchema {
///     TextFieldElement(id: "name", label: "Name", placeholder: "Full name")
///     ToggleElement(id: "newsletter", label: "Subscribe")
/// }
/// ```
///
/// `FormSchema` does not enforce validation or persistence. Pair it with
/// your form state and validation logic.
public struct FormSchema{
    /// The ordered list of form elements that make up the schema.
    ///
    /// The order of this array determines the visual order when rendering
    /// the form. The schema does not deduplicate or validate elements.
    public let fields : [FormElement]
    
    /// The identifiers of all elements in `fields`, in order.
    ///
    /// Useful for lookups, diffing, or persistence layers that key values by
    /// element ID.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    public var fieldIDs: [String]{
        fields.map(\.id)
    }
    
    /// Creates a schema from a builder that returns the elements to include.
    ///
    /// Prefer this initializer with the `@FormBuilder` attribute to declare
    /// schemas in a natural, list‑like style.
    ///
    /// - Parameter content: A closure, marked with `@FormBuilder`, that
    ///   produces the array of `FormElement` values for the schema.
    ///
    /// ### Example
    /// ```swift
    /// let schema = FormSchema {
    ///     PickerElement(id: "country", label: "Country", options: ["US", "CA"]) 
    ///     ToggleElement(id: "terms", label: "Agree to Terms")
    /// }
    /// ```
    public init(@FormBuilder _ content: () -> [FormElement]) {
        self.fields = content()
    }
    
    
}
