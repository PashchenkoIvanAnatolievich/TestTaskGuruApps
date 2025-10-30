//
//  OnboardingViewModel.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation

class OnboardingViewModel {
    var didFinishOnboarding: (() -> Void)?
    
    func finishButtonTapped() {
        // Какая-то логика
        print("ViewModel: Кнопка 'Готово' нажата, сообщаю координатору.")
        // Вызываем замыкание, чтобы передать управление координатору
        didFinishOnboarding?()
    }
}
