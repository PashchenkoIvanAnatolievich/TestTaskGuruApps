//
//  ViewController.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class OnboardingViewController: UIViewController {

    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Elements
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private var pageViewControllers: [UIViewController] = []
    
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(continueButton)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(pageViewController.view.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
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
                self?.continueButton.isEnabled = isEnabled
                self?.continueButton.alpha = isEnabled ? 1.0 : 0.5
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
        pageViewController.setViewControllers([targetPage], direction: .forward, animated: true)
    }
}

// MARK: - OnboardingPageDelegate
extension OnboardingViewController: OnboardingPageDelegate {
    func didSelectAnswer(_ answer: String) {
        viewModel.didSelectAnswer(answer)
    }
}

