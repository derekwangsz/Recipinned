//
//  ListTest.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-05-15.
//

import SwiftUI

struct ListTest: View {
    var body: some View {
        List {
            Text("Hello")
            Text("Hola")
            Text("你好")
            Text("Bonjour")
        }
        .listStyle(.inset)
    }
}

struct ListTest_Previews: PreviewProvider {
    static var previews: some View {
        ListTest()
    }
}
