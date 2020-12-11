//
//  FileManager.swift
//  TutorialApp
//
//  Created by Ravi Vooda on 12/5/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation

class TFileManager: FileManager {
    let tpath = "/User/rvooda/temp"
    lazy var turl = {
        return URL(fileURLWithPath: self.tpath)
    }()
    var fm = FileManager.default
    
    func store(name:String, data:NSData) -> Bool {
        do {
            try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: turl, create: false)
        } catch {
            print("\(error)")
            return false
        }
        
        return true
    }
}
