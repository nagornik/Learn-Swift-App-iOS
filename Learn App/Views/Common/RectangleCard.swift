//
//  RectangleCard.swift
//  Learn App
//
//  Created by Anton Nagornyi on 11.05.2022.
//

import SwiftUI

struct RectangleCard: View {
    
    var color = Color.white
    
    var body: some View {
        
        
        
        Rectangle()
//            .frame(height: 46)
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//            .shadow(radius: 5)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
        
        
        
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
