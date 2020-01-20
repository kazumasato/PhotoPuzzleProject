//
//  puzzle.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2020/01/07.
//  Copyright © 2020 佐藤一馬. All rights reserved.
//

import Foundation

class Puzzle: Codable {
    var title: String
    var solvedImages: [String]
    var unsolvedImages: [String]
    
    init(title: String, solvedImages: [String]) {
        self.title = title
        self.solvedImages = solvedImages
        self.unsolvedImages = self.solvedImages.shuffled()
    }
    
}
