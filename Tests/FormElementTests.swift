//
//  FormElementTests.swift
//  Forme
//
//  Created by Aryan Palit on 8/12/25.
//


import XCTest
@testable import Forme
import SwiftUICore


final class FormElementTests: XCTestCase {
    func testElementEquality() {
        // Given
        let element1 = FormElement(id: "test") { _ in AnyView(EmptyView()) }
        let element2 = FormElement(id: "test") { _ in AnyView(EmptyView()) }
        let element3 = FormElement(id: "different") { _ in AnyView(EmptyView()) }
        
        // Then
        XCTAssertEqual(element1, element2)
        XCTAssertNotEqual(element1, element3)
    }
    
    @MainActor func testRenderView() {
        // Given
        let model = FormModel()
        let testText = "Test View"
        let element = FormElement(id: "test") { _ in
            AnyView(Text(testText))
        }
        
        // When
        let view = element.renderView(model: model)
        
        // Then
        // Note: View testing in SwiftUI requires ViewInspector or similar library
        // This is a placeholder for actual view testing
        XCTAssertNotNil(view)
    }
}
