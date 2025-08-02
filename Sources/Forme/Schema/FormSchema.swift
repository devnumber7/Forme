//
//  FormSchema.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

/// Holds the list of fields


public struct FormSchema{
    public let fields : [FormElement]
    
    public var fieldIDs: [String]{
        fields.map(\.id)
    }
    
    public init(@FormBuilder _ content: () -> [FormElement]) {
        self.fields = content()
    }
    
    
}
