//
//  MobileDetailsTextField.swift
//  MobileStorage
//
//  Created by Slik on 27.09.2022.
//

import UIKit

final class MobileDetailsTextField: UIView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let footerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray
        return label
    }()
    
    var onTextChanged: (String) -> () = { _ in }
    
    var isEnabled: Bool = true {
        didSet {
            textField.isUserInteractionEnabled = isEnabled
            textField.textColor = isEnabled ? .label : .systemGray
            titleLabel.isEnabled = isEnabled
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupTextField()
        arrangeInStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(placeholder: String?,
                   text: String?,
                   title: String?,
                   footer: String?,
                   onTextChanged: @escaping (String) -> () = { _ in })
    {
        textField.placeholder = placeholder
        textField.text = text
        titleLabel.text = title
        footerLabel.text = footer
        self.onTextChanged = onTextChanged
    }
    
    private func setupTextField() {
        
        textField.addTarget(self,
                            action: #selector(onTextFieldValueChanged),
                            for: .editingChanged)
    }
    
    @objc private func onTextFieldValueChanged() {
        
        onTextChanged(textField.text ?? "")
    }
    
    private func arrangeInStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, footerLabel])
        
        stackView.axis = .vertical
        stackView.spacing = LayoutGuideConstants.objectContentInset
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.pin(to: self)
    }
}
