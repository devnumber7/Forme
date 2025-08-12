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
/// Conforming types receive the field’s default SwiftUI view and return a new
/// view that wraps or transforms it. Modifiers are intended to be composable
/// and side‑effect free, making them safe to store and reapply across renders.
///
/// ### Example
/// ```swift
/// struct ShadowModifier: FieldModifier {
///     @MainActor func modify<V: View>(_ content: V) -> AnyView {
///         AnyView(content.shadow(radius: 8))
///     }
/// }
///
/// let mods: [AnyFieldModifier] = [
///     AnyFieldModifier(PaddingModifier()),
///     AnyFieldModifier(BorderModifier(color: .blue, cornerRadius: 10)),
///     AnyFieldModifier(ShadowModifier())
/// ]
/// ```
public protocol FieldModifier {
    /// Returns a new view that wraps or transforms `content`.
    ///
    /// - Parameter content: The field’s default view to be wrapped or transformed.
    /// - Returns: The modified view, type‑erased to `AnyView`.
    ///
    /// - Important: Implementations should be pure (no side effects) and fast,
    ///   because they will be called during SwiftUI’s view updates.
    @MainActor func modify<V: View>(_ content: V) -> AnyView
}

// MARK: - Type-Erased Wrapper
/// A type‑erased wrapper for any `FieldModifier`.
///
/// Use `AnyFieldModifier` to store heterogeneous modifiers in collections,
/// pass modifiers across API boundaries, or expose them from public APIs
/// without leaking concrete types.
///
/// ### Example
/// ```swift
/// let modifiers: [AnyFieldModifier] = [
///   AnyFieldModifier(PaddingModifier()),
///   AnyFieldModifier(BorderModifier(color: .secondary, cornerRadius: 12))
/// ]
/// ```
public struct AnyFieldModifier: FieldModifier {
    private let _modify: (AnyView) -> AnyView
    
    /// Wraps a concrete `FieldModifier` in a type‑erased container.
    ///
    /// - Parameter modifier: The concrete modifier to erase.
    @MainActor public init<M: FieldModifier>(_ modifier: M) {
        self._modify = { content in
            // Call the concrete modifier and erase result.
            modifier.modify(content).eraseToAnyView()
        }
    }
    
    /// Applies the wrapped modifier to `content`.
    ///
    /// - Parameter content: The view to modify.
    /// - Returns: The modified view as `AnyView`.
    public func modify<V: View>(_ content: V) -> AnyView {
        _modify(content.eraseToAnyView())
    }
}

// MARK: - Example Concrete Modifiers
/// Adds uniform padding around the field’s view.
///
/// Use this modifier to add space around a field without changing layout
/// elsewhere. The default insets are 8 points on each edge.
public struct PaddingModifier: FieldModifier {
    private let insets: EdgeInsets
    /// Creates a padding modifier.
    ///
    /// - Parameter insets: The edge insets to apply. Defaults to 8 points on all sides.
    public init(_ insets: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)) {
        self.insets = insets
    }
    /// Wraps `content` in the specified padding.
    ///
    /// - Parameter content: The view to pad.
    /// - Returns: A padded view as `AnyView`.
    public func modify<V: View>(_ content: V) -> AnyView {
        AnyView(content.padding(insets))
    }
}

/// Wraps the field in a rounded rectangle stroke.
///
/// Adds optional padding and a rounded rectangle border to visually separate
/// the field from surrounding content.
public struct BorderModifier: FieldModifier {
    private let color: Color
    private let cornerRadius: CGFloat
    /// Creates a border modifier.
    ///
    /// - Parameters:
    ///   - color: The stroke color. Defaults to `.gray`.
    ///   - cornerRadius: The corner radius for the rounded rectangle. Defaults to `8`.
    public init(color: Color = .gray, cornerRadius: CGFloat = 8) {
        self.color = color
        self.cornerRadius = cornerRadius
    }
    /// Wraps `content` in a rounded rectangle stroke.
    ///
    /// - Parameter content: The view to surround with a border.
    /// - Returns: A bordered view as `AnyView`.
    public func modify<V: View>(_ content: V) -> AnyView {
        AnyView(
            content
                .padding(4)
                .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(color))
        )
    }
}

/// Convenience helper for type‑erasing any `View` to `AnyView`.
///
/// This keeps call sites concise where `AnyView` is required.
private extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
