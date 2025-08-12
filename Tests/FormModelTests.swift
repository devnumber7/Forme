//
//  FormModelTests.swift
//  Forme
//
//  Created by Aryan Palit on 8/12/25.
//

import XCTest
@testable import Forme

@MainActor final class FormModelTests: XCTestCase {
    var sut: FormModel!
    
    override func setUp() {
        super.setUp()
        sut = FormModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(sut.values.isEmpty)
        XCTAssertTrue(sut.touched.isEmpty)
    }
    
    @MainActor func testSetValue() {
        // Given
        let key = "testField"
        let value = "testValue"
        
        // When
        sut.setValue(value, for: key)
        
        // Then
        XCTAssertEqual(sut.value(for: key) as? String, value)
    }
    
    func testMarkTouched() {
        // Given
        let key = "testField"
        
        // When
        sut.markTouched(for: key)
        
        // Then
        XCTAssertTrue(sut.isTouched(key))
    }
    
    func testValidation() {
        // Given
        let key = "requiredField"
        let validator = NonEmptyValidator()
        
        sut.registerField(
            key: key,
            schema: FieldSchema(
                key: key,
                defaultValue: "",
                validator: [validator]
            )
        )
        
        // When
        sut.setValue("", for: key)
        
        // Then
        XCTAssertFalse(sut.isValid())
        XCTAssertNotNil(sut.error(for: key))
        
        // When
        sut.setValue("valid", for: key)
        
        // Then
        XCTAssertTrue(sut.isValid())
        XCTAssertNil(sut.error(for: key))
    }
}

final class FormSchemaTests: XCTestCase {
    func testSchemaBuilding() {
        // Given
        let schema = FormSchema {
            TextFieldField(key: "name", label: "Name")
            ToggleField(key: "active", label: "Active")
        }
        
        // Then
        XCTAssertEqual(schema.fields.count, 2)
        XCTAssertEqual(schema.fieldIDs, ["name", "active"])
    }
    
    func testEmptySchema() {
        // Given
        let schema = FormSchema { }
        
        // Then
        XCTAssertTrue(schema.fields.isEmpty)
        XCTAssertTrue(schema.fieldIDs.isEmpty)
    }
}
