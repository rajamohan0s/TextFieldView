//
//  TextField.swift
//  FloatingTextField
//
//  Created by Rajamohan S, Freelance Software Engineer on 08/12/22.
//  Copyright (c) 2022 Rajamohan S. All rights reserved.
//
//	Website: https://rajamohan0s.github.io/
//

import UIKit

final class TextField: UITextField {

    private let padding = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 5)

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
