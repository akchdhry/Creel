//
//  StatRowView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import SwiftUI

struct StatRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
