//
//  MobileListTableViewCell.swift
//  MobileStorage
//
//  Created by Slik on 24.09.2022.
//

import UIKit

final class MobileListTableViewCell: UITableViewCell {

    static let reuseId = "MobileListTableViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        arrangeInStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subtitle: String) {

        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func arrangeInStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = LayoutGuideConstants.objectContentInset

        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.pin(to: self, axis: .all(LayoutGuideConstants.groupedContentInset))
    }
}
