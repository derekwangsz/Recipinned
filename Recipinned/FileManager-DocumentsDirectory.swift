//
//  FileManager-DocumentsDirectory.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
