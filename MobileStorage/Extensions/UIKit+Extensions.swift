//
//  UIKit+Extensions.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, secondaryButtonTitle: String?, completion: (() -> ())?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        if let completion = completion,
            let secondaryButtonTitle = secondaryButtonTitle
        {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: secondaryButtonTitle, style: .default, handler: { _ in
                completion()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIViewController {
    func presentActionAlert(title: String,
                      message: String,
                      secondaryAction: UIAlertAction) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(secondaryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentInfoAlert(title: String, message: String, completion: @escaping () -> () = {}) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: completion)
    }
}

extension UIView {
    
    func pin(to uiView: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: uiView.topAnchor),
            self.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            self.leftAnchor.constraint(equalTo: uiView.leftAnchor),
            self.rightAnchor.constraint(equalTo: uiView.rightAnchor)
        ])
    }
    
    func pin(to uiView: UIView, axis: [Axis]) {
        for axis in axis {
            pin(to: uiView, axis: axis)
        }
    }
    
    func pin(to uiView: UIView, axis: Axis) {
        switch axis {
        case .left(let padding):
            self.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: padding).isActive = true
        case .right(let padding):
            self.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -padding).isActive = true
        case .top(let padding):
            self.topAnchor.constraint(equalTo: uiView.topAnchor, constant: padding).isActive = true
        case .bottom(let padding):
            self.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -padding).isActive = true
        case .vertical(let padding):
            pinVertical(to: uiView, padding: padding)
        case .horizontal(let padding):
            pinHorizontal(to: uiView, padding: padding)
        case .all(let padding):
            pinAll(to: uiView, padding: padding)
        }
    }
    
    private func pinAll(to uiView: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: padding),
            self.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -padding),
            self.topAnchor.constraint(equalTo: uiView.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func pinVertical(to uiView: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: uiView.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func pinHorizontal(to uiView: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: padding),
            self.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -padding)
        ])
    }
}

extension UIView {
    
    enum Axis {
        case left(CGFloat)
        case right(CGFloat)
        case top(CGFloat)
        case bottom(CGFloat)
        case vertical(CGFloat)
        case horizontal(CGFloat)
        case all(CGFloat)
    }
}
