//
//  FormBuilder.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

///A result builder to enable {} syntax



@resultBuilder
public struct FormBuilder{
    public static func buildBlock(_ components : FormElement...) -> [FormElement]{
        components
    }
}


