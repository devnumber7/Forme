//
//  FieldValidator.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

public protocol FieldValidator{
    func validate(_ value: Any) -> String?
}
