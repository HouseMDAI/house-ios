//
//  FormItem.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

extension View {
    func formItem() -> some View {
        padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

#Preview {
    VStack {
        TextField("Some text here", text: .constant("Some Lorem Here"))
            .formItem()
    }
}
