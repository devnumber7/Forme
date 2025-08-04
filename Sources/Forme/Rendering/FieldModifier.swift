//
//  FieldModifier.swift
//  Forme
//
//  Created by Aryan Palit on 8/4/25.
//

import SwiftUI

// MARK: - Core Protocol
/// A type that can modify the rendered view of a form field.
///
public protocol FieldModifier {
    /// Returns a new view that wraps or transforms `content`.
    ///
    /// - Parameter content: The field’s default view.
    /// - Returns: A modified view, type-erased to `AnyView`.
    @MainActor func modify<V: View>(_ content: V) -> AnyView
}

// MARK: - Type-Erased Wrapper
/// Allows storing heterogeneous modifiers in an array.
public struct AnyFieldModifier: FieldModifier {
    private let _modify: (AnyView) -> AnyView
    
   @MainActor public init<M: FieldModifier>(_ modifier: M) {
        self._modify = { content in
            // Call the concrete modifier and erase result.
            modifier.modify(content).eraseToAnyView()
        }
    }
    
    public func modify<V: View>(_ content: V) -> AnyView {
        _modify(content.eraseToAnyView())
    }
}

// MARK: - Example Concrete Modifiers

/// Adds uniform padding around the field.
public struct PaddingModifier: FieldModifier {
    private let insets: EdgeInsets
    public init(_ insets: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)) {
        self.insets = insets
    }
    public func modify<V: View>(_ content: V) -> AnyView {
        AnyView(content.padding(insets))
    }
}

/// Wraps the field in a rounded rectangle border.
public struct BorderModifier: FieldModifier {
    private let color: Color
    private let cornerRadius: CGFloat
    public init(color: Color = .gray, cornerRadius: CGFloat = 8) {
        self.color = color
        self.cornerRadius = cornerRadius
    }
    public func modify<V: View>(_ content: V) -> AnyView {
        AnyView(
            content
                .padding(4)
                .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(color))
        )
    }
}

// Convenience: erase AnyView
private extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
