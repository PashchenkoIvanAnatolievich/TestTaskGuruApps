//
//  OnboardingPageViewController.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit
import SnapKit

protocol OnboardingPageDelegate: AnyObject {
    func didSelectAnswer(_ answer: String)
}

class OnboardingPageViewController: UIViewController {
    
    private let pageData: OnboardingScreen
    private weak var delegate: OnboardingPageDelegate?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let answersTableView = UITableView()
    
    // MARK: - Initializer
    
    init(pageData: OnboardingScreen, delegate: OnboardingPageDelegate) {
        self.pageData = pageData
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(questionLabel)
        view.addSubview(answersTableView)
        
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerCell")
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        answersTableView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureContent() {
        questionLabel.text = pageData.question
    }
}

// MARK: - UITableViewDataSource & Delegate
extension OnboardingPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        cell.textLabel?.text = pageData.answers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnswer = pageData.answers[indexPath.row]
        delegate?.didSelectAnswer(selectedAnswer)
    }
}
