//
//  TextFieldFieldTests.swift
//  Forme
//
//  Created by Aryan Palit on 8/12/25.
//

import Forme
import XCTest


final class TextFieldFieldTests: XCTestCase {
    func testTextFieldCreation() {
        // Given
        let key = "name"
        let label = "Name"
        let placeholder = "Enter name"
        let defaultValue = "John"
        let validators = [NonEmptyValidator()]
        
        // When
        let field = TextFieldField(
            key: key,
            label: label,
            placeholder: placeholder,
            defaultValue: defaultValue,
            validators: validators
        )
        
        // Then
        XCTAssertEqual(field.key, key)
        XCTAssertEqual(field.label, label)
        XCTAssertEqual(field.placeholder, placeholder)
        XCTAssertEqual(field.defaultValue, defaultValue)
        XCTAssertEqual(field.validators.count, validators.count)
    }
    
    @MainActor func testTextFieldElement() {
        // Given
        let field = TextFieldField(key: "test", label: "Test")
        
        // When
        let element = field.intoFormElement()
        
        // Then
        XCTAssertEqual(element.id, "test")
    }
}

final class PickerFieldTests: XCTestCase {
    func testPickerCreation() {
        // Given
        let options = ["Option 1", "Option 2"]
        
        // When
        let field = PickerField(
            key: "picker",
            label: "Select",
            options: options
        )
        
        // Then
        XCTAssertEqual(field.options, options)
        XCTAssertEqual(field.defaultValue, "")
    }
}

final class ToggleFieldTests: XCTestCase {
    func testToggleCreation() {
        // Given
        let field = ToggleField(
            key: "toggle",
            label: "Enable",
            defaultValue: true
        )
        
        // Then
        XCTAssertEqual(field.defaultValue, true)
    }
}
