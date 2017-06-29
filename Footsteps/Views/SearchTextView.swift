//
//  SearchTextView.swift
//  Footsteps
//
//  Created by John Gibb on 6/19/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

class SearchTextView: UIView, UITextFieldDelegate {
    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fillWith(textField, insets: Style.resultInsets)
        textField.delegate = self
        backgroundColor = .white
    }

    struct Props {
        let didUpdateText: ((String) -> Void)?
        let didFocus: ((Void) -> Void)?
    }

    var props: Props? {
        didSet { update() }
    }

    let textField = UITextField()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        props?.didFocus?()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        props?.didUpdateText?(newText)
        return true
    }

    func update() { }
}
