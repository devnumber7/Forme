//
//  FieldSerialization.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

public protocol FieldSerializable {
    /// Turn a raw field value into something you can send (String, Bool, Int, etc).
    /// Return nil if the field should be omitted entirely.
    func serialize(_ value: Any) -> Any?
}
