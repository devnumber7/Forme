//
//  FieldSerialization.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

public protocol FieldSerialization{
    
    func serialize(_ value: Any) -> Any?
}
