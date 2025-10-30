//
//  OnboardingViewModel.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel {
    
    // MARK: - Output
    let onboardingPages: Driver<[OnboardingScreen]>
    let navigateToPage: Driver<Int>
    let isContinueButtonEnabled: Driver<Bool>
    var onboardingDidFinish: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    
    private let pagesRelay = BehaviorRelay<[OnboardingScreen]>(value: [])
    private let currentPageIndexRelay = BehaviorRelay<Int>(value: 0)
    private let selectedAnswerRelay = BehaviorRelay<String?>(value: nil)
    
    private let networkService: NetworkService
    
    // MARK: - Initializer
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        self.onboardingPages = pagesRelay.asDriver()
        self.navigateToPage = currentPageIndexRelay.asDriver()
        
        self.isContinueButtonEnabled = selectedAnswerRelay
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        fetchOnboardingPages()
    }
    
    // MARK: - Input
    
    func didSelectAnswer(_ answer: String) {
        selectedAnswerRelay.accept(answer)
    }
    
    func continueButtonTapped() {
        let currentIndex = currentPageIndexRelay.value
        let totalPages = pagesRelay.value.count
        
        guard totalPages > 0 else { return }
        
        if currentIndex < totalPages - 1 {
            
            let nextIndex = currentIndex + 1
            currentPageIndexRelay.accept(nextIndex)
            
            selectedAnswerRelay.accept(nil)
            
        } else {
            
            LogService.log("ViewModel: Онбординг завершен. Отправляю сигнал координатору.")
            onboardingDidFinish?()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchOnboardingPages() {
        networkService.fetchOnboardingData { [weak self] result in
            switch result {
            case .success(let response):
                self?.pagesRelay.accept(response.items)
            case .failure(let error):
                LogService.log("Failed to fetch onboarding data: \(error)", type: .error)
                self?.pagesRelay.accept([])
            }
        }
    }
}
