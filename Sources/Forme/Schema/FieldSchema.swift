//
//  FieldSchema.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

public struct FieldSchema : FieldValidator{
    
    var key: String
    var defaultValue: Any
    var validator: [Validator]
    
    public func validate(_ value: Any) -> String?{
        
    }
    
    
    
    func serialize(_ value: ?) -> Any{
        
    }
    
    
}
