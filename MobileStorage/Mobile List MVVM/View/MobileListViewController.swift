//
//  MobileListViewController.swift
//  MobileStorage
//
//  Created by Slik on 21.09.2022.
//

import UIKit

final class MobileListViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var tableView: UITableView = UITableView()
    
    let noResultsPlugLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "No mobiles found"
        label.textColor = .systemGray3
        return label
    }()
    
    private var viewModel: MobileListViewModelProtocol = MobileListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        setupSearchBar()
        setupTableView()
        setupAddMobileBarButton()
        updateNoResultsPlugLabelVisability()
    }
}
//MARK: - Setup UI
extension MobileListViewController {
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noResultsPlugLabel)
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "IMEI"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.inputAccessoryView = keyboardToolbar()
        navigationItem.titleView = searchBar
    }
    
    private func keyboardToolbar() -> UIToolbar {
        let bar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(keyboardToolbarDoneButtonTapped))
        bar.items = [doneButton]
        bar.sizeToFit()
        return bar
    }
    
    @objc private func keyboardToolbarDoneButtonTapped() {
        view.hideKeyboard()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MobileListTableViewCell.self, forCellReuseIdentifier: MobileListTableViewCell.reuseId)
    }
    
    private func setupAddMobileBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addMobileBarButtonTapped))
    }
    
    @objc private func addMobileBarButtonTapped() {
        viewModel.add()
    }
    
    private func updateNoResultsPlugLabelVisability() {
        noResultsPlugLabel.isHidden = !viewModel.representedData.isEmpty
    }
}
//MARK: - Layout
extension MobileListViewController {
    
    private func setupConstraints() {
        setupTableViewConstraints()
        setupNoResultsPlugLabelConstraints()
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pin(to: view)
    }
    
    private func setupNoResultsPlugLabelConstraints() {
        noResultsPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultsPlugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsPlugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
//MARK: - Control events
extension MobileListViewController {
    
    
}
//MARK: - SearchBar
extension MobileListViewController : UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.search(text: textSearched)
    }
}
//MARK: - Table view data source
extension MobileListViewController : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.representedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MobileListTableViewCell.reuseId, for: indexPath) as? MobileListTableViewCell else {
            return .init()
        }
        
        cell.configure(title: viewModel.representedData[indexPath.row].model,
                       subtitle: viewModel.representedData[indexPath.row].imei)
        
        return cell
    }
}
//MARK: - Table view delegate
extension MobileListViewController : UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.select(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.remove(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
}
//MARK: - ViewModel
extension MobileListViewController : ViewModelListener {
    
    typealias ViewModel = MobileListViewModelProtocol
    
    func set(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func listenViewModel() {
        listenDataUpdated()
        listenDataDeleted()
        listenErrorReceived()
        viewModel.fetch()
    }
    
    private func listenDataUpdated() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateNoResultsPlugLabelVisability()
        }
    }
    
    private func listenDataDeleted() {
        viewModel.onDelete = { [weak self] in
            guard let self = self else { return }
            self.updateNoResultsPlugLabelVisability()
        }
    }
    
    private func listenErrorReceived() {
        viewModel.onError = {  [weak self] error in
            self?.presentInfoAlert(title: error.title, message: error.description)
        }
    }
}
