//
//  FieldSchema.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

public struct FieldSchema : FieldValidator, FieldSerializable{
    
    
  
    
    var key: String
    var defaultValue: Any
    var validator: [Validator]
    
    
    /// Runs each validator in order, returning the first non‐nil error message.
    public func validate(_ value: Any) -> String? {
        for rule in validator {
            if let error = rule.validate(value) {
                return error
            }
        }
        return nil
    }
    
    
    /// By default, just returns the value unchanged.
       public func serialize(_ value: Any) -> Any? {
           return value
       }
    
    

    
    
}
