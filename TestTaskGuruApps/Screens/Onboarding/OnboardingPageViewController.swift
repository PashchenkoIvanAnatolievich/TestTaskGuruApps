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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let answersTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
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
        
        answersTableView.dataSource = self
        answersTableView.delegate = self
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addSubview(questionLabel)
        view.addSubview(answersTableView)
        
        answersTableView.register(OnboardPageTableViewCell.self, forCellReuseIdentifier: OnboardPageTableViewCell.reuseIdentifier)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        answersTableView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(20))
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardPageTableViewCell.reuseIdentifier, for: indexPath) as? OnboardPageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: pageData.answers[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnswer = pageData.answers[indexPath.row]
        delegate?.didSelectAnswer(selectedAnswer)
    }
}
