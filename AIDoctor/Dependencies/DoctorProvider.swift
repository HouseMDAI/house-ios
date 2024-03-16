//
//  DoctorService.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

enum DoctorResponse {
    case questions(Questionary)
    case answer(String)
    
    init(from string: String) throws {
        if let data = string.data(using: .utf8) {
            if string.contains("\"questions\":") {
                let decoded = try JSONDecoder().decode(Questionary.self, from: data)
                self = .questions(decoded)
            } else if string.contains("\"text\":") {
                let decoded = try JSONDecoder().decode(Answer.self, from: data)
                self = .answer(decoded.text)
            } else {
                throw NSError(domain: "DoctorResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown response format"])
            }
        } else {
            throw NSError(domain: "DoctorResponseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid string encoding"])
        }
    }
}

class DoctorProvider {
    func sendMessage(message: String) async throws -> DoctorResponse {
        let promptProvider = PromptsProvider()
        let profile = OnboardingProvider().filledOnboarding!
        let gpt = GPTProvider(apiKey: "", baseUrl: "")
        
        let prompt = promptProvider.homeRole
        + promptProvider.profile(profile: profile)
        + promptProvider.message(message: message)
        
        let responseString = try await gpt.prompt(prompt)
        return try! DoctorResponse(from: responseString)
    }
    
    func sendAnswers(message: String, answers: FilledQuestionary) async throws -> DoctorResponse {
        let promptProvider = PromptsProvider()
        let profile = OnboardingProvider().filledOnboarding!
        let gpt = GPTProvider(apiKey: "", baseUrl: "")
        
        let prompt = promptProvider.homeRole
        + promptProvider.profile(profile: profile)
        + promptProvider.message(message: message)
        + promptProvider.answers(filled: answers)
        
        let responseString = try await gpt.prompt(prompt)
        return try! DoctorResponse(from: responseString)
    }
}
