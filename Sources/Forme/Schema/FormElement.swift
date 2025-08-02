//
//  FormElement.swift
//  Forme
//
//  Created by Aryan Palit on 8/1/25.
//

import SwiftUICore

public struct FormElement: Identifiable{
    public let id : String
    public let render : (FormModel) -> AnyView
    
    
    public init(id: String, render: @escaping (FormModel) -> AnyView ){
        self.id = id
        self.render = render
    }
    
    public func renderView(model: FormModel) -> AnyView{
        render(model)
    }
}


extension FormElement: Equatable{
    public static func == (lhs: FormElement, rhs: FormElement) -> Bool{
        lhs.id == rhs.id
    }
}
