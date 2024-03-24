//
//  ProfileView.swift
//  HouseMDAI
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

struct ProfileView: View {
    
    var profile: FilledQuestionary
    var profileSorted: [(question: String, answer: String)] {
        profile.filledQuestions
            .sorted { $0.key < $1.key }
            .map { (question: $0.key, answer: $0.value) }
    }
    
    var body: some View {
        List(profileSorted, id: \.question) { item in
            VStack {
                Text(item.question)
                    .font(.title3)
                Text(item.answer)
                    .formItem()
            }
            .padding()
        }
    }
}
