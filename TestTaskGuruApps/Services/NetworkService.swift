//
//  NetworkService.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation

class NetworkService {
    
    func fetchOnboardingData(completion: @escaping (Result<OnboardingResponse, Error>) -> Void) {
        guard let url = URL(string: "https://test-ios.universeapps.limited/onboarding") else {
            LogService.log("Invalid URL", type: .error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    LogService.log("No data received", type: .error)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let onboardingResponse = try decoder.decode(OnboardingResponse.self, from: data)
                    completion(.success(onboardingResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
