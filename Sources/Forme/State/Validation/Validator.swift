//
//  Validator.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

import Foundation

/// Types of built-in validations you can apply.
public enum ValidationType {
    case email
    case numeric
    case integer
    case decimal
    // add more as needed
}

/// An individual rule in a `Validator`, with any associated parameters.
public enum RuleType {
    case required(message: String)
    case minLength(Int, message: String)
    case maxLength(Int, message: String)
    case type(ValidationType, message: String)
    case pattern(String, message: String)
    case custom((Any) -> String?)
}

/// A chainable validator that runs each `RuleType` in sequence.
public final class Validator: FieldValidator {
    private var rules: [RuleType] = []

    public init() {}

    /// Adds a “must not be empty” rule.
    @discardableResult
    public func required(_ message: String) -> Self {
        rules.append(.required(message: message))
        return self
    }

    /// Adds a minimum-length rule for strings.
    @discardableResult
    public func minLength(_ length: Int, _ message: String) -> Self {
        rules.append(.minLength(length, message: message))
        return self
    }

    /// Adds a maximum-length rule for strings.
    @discardableResult
    public func maxLength(_ length: Int, _ message: String) -> Self {
        rules.append(.maxLength(length, message: message))
        return self
    }

    /// Adds a type check (email, numeric, etc.).
    @discardableResult
    public func type(_ type: ValidationType, _ message: String) -> Self {
        rules.append(.type(type, message: message))
        return self
    }

    /// Adds a regex-pattern rule.
    @discardableResult
    public func pattern(_ regex: String, _ message: String) -> Self {
        rules.append(.pattern(regex, message: message))
        return self
    }

    /// Adds a fully custom validation closure.
    @discardableResult
    public func custom(_ closure: @escaping (Any) -> String?) -> Self {
        rules.append(.custom(closure))
        return self
    }

    /// Runs through all rules in order, returning the first error string, or `nil` if all pass.
    public func validate(_ value: Any) -> String? {
        for rule in rules {
            switch rule {
            case .required(let message):
                let str = (value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if str.isEmpty { return message }

            case .minLength(let min, let message):
                guard let str = value as? String else { return message }
                if str.count < min { return message }

            case .maxLength(let max, let message):
                guard let str = value as? String else { return message }
                if str.count > max { return message }

            case .type(let type, let message):
                guard let str = value as? String else { return message }
                let ok: Bool
                switch type {
                case .email:
                    let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
                    ok = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: str)
                case .numeric:
                    ok = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: str))
                case .integer:
                    ok = Int(str) != nil
                case .decimal:
                    ok = Double(str) != nil
                }
                if !ok { return message }

            case .pattern(let regex, let message):
                guard let str = value as? String,
                      let re = try? NSRegularExpression(pattern: regex)
                else { return message }
                let range = NSRange(str.startIndex..<str.endIndex, in: str)
                if re.firstMatch(in: str, options: [], range: range) == nil {
                    return message
                }

            case .custom(let closure):
                if let err = closure(value) {
                    return err
                }
            }
        }
        return nil
    }
}
