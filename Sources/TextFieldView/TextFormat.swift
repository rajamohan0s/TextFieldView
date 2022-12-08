//
//  TextFormat.swift
//  FloatingTextField
//
//  Created by Rajamohan S, Freelance Software Engineer on 08/12/22.
//  Copyright (c) 2022 Rajamohan S. All rights reserved.
//
//	Website: https://rajamohan0s.github.io/
//

import UIKit

public enum TextFormat: String{
    
    case email = "Email"
    case password = "Password"
    case ingore
   
    public var keyboardType: UIKeyboardType {
        
        switch self {
        case .email:
            return .emailAddress
        case .password:
            return .asciiCapable
        case .ingore:
            return .default
        }
    }
    
    public var isSecureTextEntry: Bool { self == .password }
     
    
    public var hasAutocorrection: Bool {
        
        switch self {
        case .email, .password:
            return false
            
        default:
            return true
        }
    }
    
    public var autoCapitalizationType: UITextAutocapitalizationType {
        
        switch self {
            
        case .email, .password:
            return .none
            
        default:
            return .words
        }
    }
    
    private func validationError(for option: ValidationError) -> ErrorValue {
        
        switch option {
        case .empty:
            return .custom("\(self.rawValue) cannot be empty")
            
        case .week:
          
            if self == .password {
                
                return .custom("Passwords require at least 1 uppercase, 1 lowercase and 1 number.")
            }
            
            return .custom("this is a Week \(self.rawValue.lowercased())")
            
        case .invalid:
            return .custom("this is a Invalid \(self.rawValue.lowercased())")
        }
        
    }
     
    func validate(option: ValidationOption, text: String?) throws {
         
        let trimmed: String? = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let text: String  = trimmed == "" ? nil : trimmed else {
            
            if option == .optional {

                return
            }
            
            if self != .ingore {
           
                throw self.validationError(for: .empty)
            }
            
            return
        }
         
        switch self {
        case .email:
            
            if !self.validateEmail(email: text) {
                
                throw self.validationError(for: .invalid)
            }
            
        case .password:
                
            guard text.count > 5 && text.contains(cases: .uppercase, .lowercase, .number) else {
                
                throw self.validationError(for: .week)
            }
            
        default: break
        }
    }
    
    
    /*
    func validate(_ text: String, replacement string: String, range: Range) -> ValidationError? {
         
    }
    */
    
    func validateEmail(email string: String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)

    }
     
    // MARK: Validation Option
    public enum ValidationOption: Int {
        
        case strict
        case optional
    }
    
    // MARK: Validation Error
    public enum ValidationError {
        
        case empty
        case week
        case invalid
    }
    
    // MARK: Error
    private enum ErrorValue: LocalizedError {
        
        case custom(_ string: String)
        
        var errorDescription: String? {
            
            switch self {
            case .custom(let value):
                
                return value
            }
        }
    }
}

fileprivate extension String {
    
    func contains(cases: Case...) -> Bool {
        
        for value in cases {
            
            if !value.pass(self) {
             
                return false
            }
        }
        
        return true
    }
}

fileprivate enum Case: CaseIterable {
    
    case uppercase
    case lowercase
    case number
    
    func pass(_ string: String) -> Bool {
        
        switch self {
        case .uppercase:
            return string.contains(where: { $0.isUppercase })
            
        case .lowercase:
            return string.contains(where: { $0.isLowercase })
            
        case .number:
            return string.contains(where: { $0.isNumber })
        }
    }
}


