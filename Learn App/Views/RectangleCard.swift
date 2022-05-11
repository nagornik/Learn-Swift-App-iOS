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
            .cornerRadius(10)
            .shadow(radius: 5)
        
        
        
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
