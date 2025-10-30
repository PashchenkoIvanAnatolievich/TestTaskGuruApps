import UIKit
import RxSwift
import RxCocoa
import SnapKit

class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    private var pageViewControllers: [UIViewController] = []
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    private let titleLabel = UILabel()
    private let continueButton = UIButton(type: .system)
    
    // MARK: - Initializer
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "customBg")
        
        setupTitleLabel()
        setupPageViewController()
        setupContinueButton()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.text = "Let’s setup App for you"
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
            make.top.equalToSuperview().inset(AdaptiveService.getAdaptiveHeight(104))
        }
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(32))
            make.leading.trailing.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
        }
    }
    
    private func setupContinueButton() {
        view.addSubview(continueButton)
        
        continueButton.layer.cornerRadius = 28
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        continueButton.setTitle("Continue", for: .normal)
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(pageViewController.view.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(92))
            make.left.right.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(AdaptiveService.getAdaptiveHeight(48))
            make.height.equalTo(AdaptiveService.getAdaptiveHeight(56))
        }
    }
    
    private func updateContinueButton(isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        
        if isEnabled {
            continueButton.backgroundColor = .black
            continueButton.setTitleColor(.white, for: .normal)
            
            continueButton.layer.shadowOpacity = 0
            
        } else {
            continueButton.backgroundColor = .white
            continueButton.setTitleColor(UIColor(named: "disableGrayText"), for: .disabled)
            
            continueButton.layer.shadowColor = UIColor(named: "continueBtnShadow")?.cgColor
            continueButton.layer.shadowOffset = CGSize(width: 0, height: -4)
            continueButton.layer.shadowRadius = 18.0
            continueButton.layer.shadowOpacity = 0.25
            
            continueButton.layer.masksToBounds = false
        }
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.onboardingPages
            .drive(onNext: { [weak self] pages in
                self?.setupPages(with: pages)
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToPage
            .drive(onNext: { [weak self] index in
                self?.navigateToPage(at: index)
            })
            .disposed(by: disposeBag)
        
        viewModel.isContinueButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.updateContinueButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
         
        continueButton.rx.tap
            .bind(onNext: viewModel.continueButtonTapped)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func setupPages(with pages: [OnboardingScreen]) {
        pageViewControllers = pages.map { pageData in
            return OnboardingPageViewController(pageData: pageData, delegate: self)
        }
        
        if let firstPage = pageViewControllers.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func navigateToPage(at index: Int) {
        guard index < pageViewControllers.count else { return }
        let targetPage = pageViewControllers[index]
        pageViewController.setViewControllers([targetPage], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - OnboardingPageDelegate
extension OnboardingViewController: OnboardingPageDelegate {
    func didSelectAnswer(_ answer: String) {
        viewModel.didSelectAnswer(answer)
    }
}
