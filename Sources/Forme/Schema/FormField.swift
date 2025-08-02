//
//  FormField.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

/// A protocol for all fields (like TextField, Toggle)


public protocol FormField{
    var key : String { get }
    var label : String { get }
    
    func intoFormElement() -> FormElement
    
}
