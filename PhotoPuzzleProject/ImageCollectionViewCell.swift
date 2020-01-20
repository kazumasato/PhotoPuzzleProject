//
//  ImageCollectionViewCell.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2020/01/07.
//  Copyright © 2020 佐藤一馬. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var puzzleImage: UIView!

    override func awakeFromNib() {
        self.frame = puzzleImage.frame
    }
}

