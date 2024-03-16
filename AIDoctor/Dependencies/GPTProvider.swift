//
//  GPTProvider.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class GPTProvider {

    private var apiKey: String
    private var baseUrl: String
    
    init(apiKey: String, baseUrl: String = "https://api.openai.com/v1/engines/davinci/completions") {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    func prompt(_ string: String) async throws -> String {
        guard let url = URL(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let payload: [String: Codable] = [
            "prompt": string,
            "max_tokens": 100,
            "temperature": 0.7
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let text = result["choices"] as? [[String: Any]],
              let firstChoice = text.first,
              let finalText = firstChoice["text"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return finalText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

