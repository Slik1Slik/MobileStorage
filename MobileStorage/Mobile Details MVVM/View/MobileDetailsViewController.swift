//
//  MobileDetailsViewController.swift
//  MobileStorage
//
//  Created by Slik on 27.09.2022.
//

import UIKit

final class MobileDetailsViewController: UIViewController {
    
    let modelTextField: MobileDetailsTextField = MobileDetailsTextField(frame: .zero)
    let imeiTextField: MobileDetailsTextField = MobileDetailsTextField(frame: .zero)
    
    private var viewModel: MobileDetailsViewModelInput & MobileDetailsViewModelOutput = MobileDetailsViewModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = .white
        
        arrangeInStackView()
        
        setupPrimaryButton()
        setupSecondaryButton()
        
        addTapGestureToHideKeyboard()
        
        navigationItem.title = "Details"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Setting up UI
extension MobileDetailsViewController {
    
    private func arrangeInStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [modelTextField, imeiTextField])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = LayoutGuideConstants.groupedContentInset
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.pin(to: view, axis: .horizontal(LayoutGuideConstants.padding))
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,
                                       constant: LayoutGuideConstants.padding).isActive = true
    }
    
    private func setupPrimaryButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(primaryButtonTapped))
    }
    
    @objc private func primaryButtonTapped() {
        
        viewModel.save()
    }
    
    private func setupSecondaryButton() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(secondaryButtonTapped))
    }
    
    @objc private func secondaryButtonTapped() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTap() {
        view.hideKeyboard()
    }
}
//MARK: - Listen ViewModel
extension MobileDetailsViewController : ViewModelListener {
    
    func set(_ viewModel: MobileDetailsViewModelInput & MobileDetailsViewModelOutput) {
        
        self.viewModel = viewModel
    }
    
    func listenViewModel() {
        viewModel.delegate = self
        bindTextInput()
        listenErrorReceived()
        listenSuccessReceived()
    }
    
    private func bindTextInput() {
        
        modelTextField.configure(placeholder: viewModel.modelPlaceholder,
                                 text: viewModel.model,
                                 title: viewModel.modelTitle,
                                 footer: viewModel.modelFooter) { [weak self] text in
            
            self?.viewModel.model = text
        }
        
        imeiTextField.configure(placeholder: viewModel.imeiPlaceholder,
                                text: viewModel.imei,
                                title: viewModel.imeiTitle,
                                footer: viewModel.imeiFooter) { [weak self] text in
            
            self?.viewModel.imei = text
        }
    }
    
    private func listenErrorReceived() {
        
        viewModel.onError = { [weak self] error in
            
            self?.presentInfoAlert(title: error.title, message: error.description)
        }
    }
    
    private func listenSuccessReceived() {
        
        viewModel.onSuccess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
//MARK: - ViewModel Delegate
extension MobileDetailsViewController : MobileDetailsViewModelDelegate {
    
    func viewModel(canSave: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = canSave
    }
}
