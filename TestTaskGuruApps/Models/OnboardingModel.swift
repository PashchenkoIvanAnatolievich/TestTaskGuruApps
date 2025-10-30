//
//  OnboardingModel.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation

struct OnboardingResponse: Codable {
    let items: [OnboardingScreen]
}

struct OnboardingScreen: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
