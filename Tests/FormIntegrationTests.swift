//
//  FormIntegrationTests.swift
//  Forme
//
//  Created by Aryan Palit on 8/12/25.
//

import XCTest
import Forme

final class FormIntegrationTests: XCTestCase {
    var model: FormModel!
    var schema: FormSchema!
    
    override func setUp() {
        super.setUp()
        model = FormModel()
        schema = FormSchema {
            TextFieldField(
                key: "name",
                label: "Name",
                validators: [NonEmptyValidator()]
            )
            ToggleField(
                key: "active",
                label: "Active"
            )
        }
    }
    
    override func tearDown() {
        model = nil
        schema = nil
        super.tearDown()
    }
    
    @MainActor func testFormValidation() {
        // Given
        let view = FormView(model: model, schema: schema)
        
        // When
        model.setValue("", for: "name")
        model.markTouched(for: "name")
        
        // Then
        XCTAssertFalse(model.isValid())
        
        // When
        model.setValue("John", for: "name")
        
        // Then
        XCTAssertTrue(model.isValid())
    }
    
    @MainActor func testFormSubmission() {
        // Given
        model.setValue("John", for: "name")
        model.setValue(true, for: "active")
        
        // When
        model.validateAll()
        
        // Then
        XCTAssertTrue(model.isValid())
        XCTAssertEqual(model.value(for: "name") as? String, "John")
        XCTAssertEqual(model.value(for: "active") as? Bool, true)
    }
}
