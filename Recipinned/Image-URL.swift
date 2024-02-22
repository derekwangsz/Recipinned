//
//  Image-URL.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-29.
//

import Foundation
import SwiftUI

extension Image {
    
    func data(url:URL) async -> Self {
        
        if let data = try? Data(contentsOf: url) {
            
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
    
}
