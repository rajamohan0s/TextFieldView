//
//  TextFieldView.swift
//  TextFieldView
//
//  Created by Rajamohan S, Freelance Software Engineer on 08/12/22.
//  Copyright (c) 2022 Rajamohan S. All rights reserved.
//
//	Website: https://rajamohan0s.github.io/
//

import UIKit

// MARK: TextFieldViewDelegate

public protocol TextFieldViewDelegate: AnyObject {
    
    func textFieldViewDidEndEditing(_ textFieldView: TextFieldView)
    
    func textFieldView(_ textFieldView: TextFieldView, didValidated isValid: Bool)
}

// MARK: TextFieldView

open class TextFieldView: UIView, UITextFieldDelegate {
     
    public weak var delegate: TextFieldViewDelegate?
     
    private(set) public var isValid: Bool = false
    
    public var text: String? {
        
        set {
            
            self.textField.text = newValue
        }
        
        get {
            
            return self.textField.text?.nullable
        }
    }
    
    @IBInspectable
    open var textFormat: String {
        
        set {
            
            let format: TextFormat = .init(rawValue: newValue)!
            
            self.textField.keyboardType = format.keyboardType
            self.textField.isSecureTextEntry = format.isSecureTextEntry
            self.textField.autocorrectionType = format.hasAutocorrection ? .yes : .no
            self.textField.autocapitalizationType = format.autoCapitalizationType

            self._textFormat = format
        }
        
        get {
            
            return self._textFormat.rawValue
        }
    }
    
    @IBInspectable
    open var validationOption: Int {
        
        set {
            
            self._validationOption = .init(rawValue: newValue)!
        }
        
        get {
            
            return self._validationOption.rawValue
        }
    }
    
    @IBInspectable
    open var placeHolder: String? {
        
        set {
            
            self.textField.placeholder = newValue
        }
        
        get {
            
            return self.textField.placeholder
        }
    }
    
    @IBInspectable
    open var title: String? {
        
        set {
            
            self.labelTitle.text = newValue
        }
        
        get {
            
            return self.labelTitle.text
        }
    }
    
    public private(set) lazy var labelTitle: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.backgroundColor = .white
        label.textColor = .black
        label.text = self.textFormat
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16 + self.padding.left),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.padding.top),
            label.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        return label
    }()
    
    public private(set) lazy var textField: UITextField = {
       
        let textField = TextField()
        textField.font = .systemFont(ofSize: 14)
        textField.borderStyle = .none
        
        textField.layer.borderColor = #colorLiteral(red: 0.8905171752, green: 0.8905171752, blue: 0.8905171752, alpha: 1)
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 4.0
        
        textField.delegate = self
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
        
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.padding.left),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.padding.right),
            textField.topAnchor.constraint(equalTo: self.labelTitle.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48)
         ])
        
        self.constrainFieldBottomAnchor = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -self.padding.bottom)
        self.constrainFieldBottomAnchor.isActive = true
        
        return textField
    }()
    
    public private(set) var labelError: UILabel = {
       
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private var constrainFieldBottomAnchor: NSLayoutConstraint!
    
    private var _textFormat: TextFormat = .ingore
    private var _validationOption: TextFormat.ValidationOption = .optional
      
    func show(error message: String) {
        
        self.labelError.text = message
        
        if self.labelError.superview == nil {
            
            self.removeConstraint(self.constrainFieldBottomAnchor)
            self.addSubview(self.labelError)
            self.labelError.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
            
                self.labelError.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.padding.left),
                self.labelError.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.padding.right),
                self.labelError.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.padding.bottom)
            ])
            
            self.constrainFieldBottomAnchor = .init(item: self.labelError, attribute: .top, relatedBy: .equal, toItem: self.textField.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 8)
            self.constrainFieldBottomAnchor.isActive = true
        }
    }
    
    func removeError() {
        
        self.labelError.removeFromSuperview()
        self.removeConstraint(self.constrainFieldBottomAnchor)
        self.constrainFieldBottomAnchor = NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -self.padding.bottom)
        self.constrainFieldBottomAnchor.isActive = true
    }
    
    open func becomeFirstResponder() {
        
        self.textField.becomeFirstResponder()
    }
    
    open func resignFirstResponder() {
        
        self.textField.resignFirstResponder()
    }
   
    open func validate(_ string: String?) {
        
        do {
        
            try self._textFormat.validate(option: self._validationOption, text: string)
            self.isValid = true
            self.removeError()
            self.delegate?.textFieldView(self, didValidated: true)

        } catch {
            
            self.isValid = false
            self.show(error: error.localizedDescription)
            self.delegate?.textFieldView(self, didValidated: false)
            
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: UITextField Delegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         
        if self.isValid {
            
            textField.resignFirstResponder()
        }
        
        self.delegate?.textFieldViewDidEndEditing(self)

        return true
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        
        if let range =  Range<String.Index>.init(range, in: text){
         
            let newString = text.replacingCharacters(in: range, with: string)
            self.validate(newString)
            
        } else {
             
            fatalError("Development Error")
        }
        
        return true
    }
}
 
fileprivate extension String {
    
    var trimmed: String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    var nullable: String? {
        
        let trimmed = self.trimmed
        return trimmed.isEmpty ? nil : trimmed
    }
}
