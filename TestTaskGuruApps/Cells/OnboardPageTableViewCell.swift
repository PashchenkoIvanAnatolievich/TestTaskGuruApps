//
//  OnboardPageTableViewCell.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

class OnboardPageTableViewCell: UITableViewCell {
    
    private let titleView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    
    static let reuseIdentifier = "OnboardPageTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            titleView.backgroundColor = UIColor(named: "cellGreen")
            titleLabel.textColor = .white
        } else {
            titleView.backgroundColor = .white
            titleLabel.textColor = .black
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupTitleView()
        setupTitleLabel()
    }
    
    private func setupTitleView() {
        addSubview(titleView)
        
        selectionStyle = .none
        
        titleView.layer.cornerRadius = 16
        
        titleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(AdaptiveService.getAdaptiveHeight(6))
            make.height.equalTo(AdaptiveService.getAdaptiveHeight(52))
        }
    }
    
    private func setupTitleLabel() {
        titleView.addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(16))
            make.top.bottom.equalToSuperview().inset(AdaptiveService.getAdaptiveHeight(16))
        }
    }
    
    func setupCell(with text: String) {
        setupUI()
        
        titleLabel.text = text
    }

}
