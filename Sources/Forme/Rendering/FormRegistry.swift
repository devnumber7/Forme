//
//  FormRegistry.swift
//  Forme
//
//  Created by Aryan Palit on 8/4/25.
//


import SwiftUI

/// A global registry for custom form field renderers.
///
/// Stores closures keyed by field identifier.  All accesses are isolated
/// to the main actor, so you can safely register and look up renderers
/// from anywhere in your SwiftUI code.
@MainActor
public final class FormRegistry {
    /// The shared singleton instance.
    public static let shared = FormRegistry()
    
    /// Maps field IDs to their custom render closures.
    ///
    /// Each closure takes the `FormElement` and its `FormModel` and
    /// returns an `AnyView` to display in place of the default.
    private var renderers: [String: (FormElement, FormModel) -> AnyView] = [:]
    
    /// Private to enforce singleton.
    private init() {}
    
    // MARK: - Registration
    
    /// Registers a custom renderer for a given field ID.
    ///
    /// - Parameters:
    ///   - fieldID: The `FormElement.id` to override.
    ///   - renderer: A closure that renders that element.
    public func registerRenderer(
        for fieldID: String,
        renderer: @escaping (FormElement, FormModel) -> AnyView
    ) {
        renderers[fieldID] = renderer
    }
    
    /// Removes any custom renderer for the given field ID.
    ///
    /// - Parameter fieldID: The `FormElement.id` to clear.
    public func unregisterRenderer(for fieldID: String) {
        renderers.removeValue(forKey: fieldID)
    }
    
    /// Clears *all* registered custom renderers.
    public func reset() {
        renderers.removeAll()
    }
    
    // MARK: - Lookup
    
    /// Returns the custom renderer for a given field ID, if one exists.
    ///
    /// - Parameter fieldID: The `FormElement.id` to lookup.
    /// - Returns: The registered closure, or `nil` to fall back to the default.
    public func customRenderer(
        for fieldID: String
    ) -> ((FormElement, FormModel) -> AnyView)? {
        renderers[fieldID]
    }
}
