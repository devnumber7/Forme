//
//  PickerField.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//


public struct PickerField : FormField{
    public var key: String
    
    public var label: String
    
    public let placeholder: String
    
    public let defaultValue: String
    
    public init(key: String, label: String, placeholder: String, defaultValue: String) {
        self.key = key
        self.label = label
        self.placeholder = placeholder
        self.defaultValue = defaultValue
    }
    
    
    public func intoFormElement() -> FormElement {
        <#code#>
    }
    
    
}
