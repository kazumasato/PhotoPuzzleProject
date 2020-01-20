//
//  NextViewController.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2020/01/14.
//  Copyright © 2020 佐藤一馬. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
//MainVCから取ってきた画像を入れる変数
    var selectedImage: UIImage!
    
    @IBOutlet weak var puzzleView: UIView!
    let DIVISOR = CGFloat(4)
    let BTN_START = 0 //スタート
    
    var _piece = [UIImageView]() //ピース画像(2)
    var _data = [Int]()          //ピース配置情報(2)
    var _shuffle: Int = 0        //シャッフル
    var _startButton: UIButton!  //スタートボタン
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var image = UIImage(named: "selectedImage")
        
        
        var image = selectedImage!.resized(toWidth: 400)
               
               createPuzzle(image: image!, divisor: DIVISOR)
        
    }
    

    @IBAction func didClickStartButton(_ sender: UIButton) {
        if sender.tag == BTN_START {
//                    //シャッフルの実行(8)
//                          _shuffle = 20
//                          while _shuffle > 0 {
//                              if movePiece(tx: Int(arc4random_uniform(4)), ty: Int(arc4random_uniform(4))) {_shuffle -= 1}
//                          }
//                          for i in 0..<16 {
//                              let dx: CGFloat = 30+75*CGFloat(i%4)
//                              let dy: CGFloat = 180+75*CGFloat(i/4)
//                              _piece[_data[i]].frame =
//                                  CGRect(x: dx, y: dy, width: 75, height: 75)

                    _piece[15].alpha = 0

                      }
    }
    

    func makePieces(image: UIImage, divisor: CGFloat) -> [UIImage] {
        
        let pieceWidth = (image.size.width) / divisor
        let pieceHeight = (image.size.height) / divisor
        
        var pieces: [UIImage] = []
        
        for i in 0..<Int(divisor) {
            
            for j in 0..<Int(divisor) {
                let piece = image.cropToRect(rect: CGRect(x: CGFloat(i) * pieceWidth, y: CGFloat(j) * pieceHeight, width: pieceWidth, height: pieceHeight))
                
                pieces.append(piece!)
            }
        }
        
        return pieces
        
    }
    func createPuzzle(image: UIImage, divisor: CGFloat) {
        var pieces = makePieces(image: image, divisor: divisor)
        pieces.shuffle()
        let maxCount = Int(divisor) * Int(divisor)
        
        let pieceWidth = (image.size.width) / divisor
        let pieceHeight = (image.size.height) / divisor
        
        for i in 0..<maxCount {
            var piece = pieces[i]
            let x = i / Int(divisor)
            let y = i % Int(divisor)
            
            let imageView = UIImageView(image: piece)
            imageView.frame = CGRect(x: CGFloat(x) * pieceWidth, y: CGFloat(y) * pieceHeight, width: pieceWidth, height: pieceHeight)
            puzzleView.addSubview(imageView)
        }
    }
    //タッチ開始時に呼ばれる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if _startButton.alpha != 0 {
                return
            }
            //タッチ位置からピースの列番号と行番号を求める(3)
            let pos = touches.first!.location(in: puzzleView)
            if 30 < pos.x && pos.x < 330 && 180 < pos.y && pos.y < 480 {
                let tx = Int((pos.x-30)/75)
                let ty = Int((pos.y-180)/75)
                movePiece(tx: tx, ty: ty)
            }
        }

        func movePiece(tx: Int, ty: Int) -> Bool {
            //空きマスの行番号と列番号を求める(4)
            var fx = 0
            var fy = 0
            for i in 0..<16 {
                if _data[i] == 15 {
                    fx = i%4
                    fy = Int(i/4)
                    break
                }
            }
            if (fx == tx && fy == ty) || (fx != tx && fy != ty) {
                return false
            }
            
            //ピースを上にスライド(5)
            if fx == tx && fy < ty {
                for i in fy..<ty {
                    _data[fx+i*4] = _data[fx+i*4+4]
                }
                _data[tx+ty*4] = 15
            }
                //ピースを下にスライド(5)
            else if fx == tx && fy > ty {
                for i in stride(from:fy,to: ty, by: -1) {
                    _data[fx+i*4] = _data[fx+i*4-4]
                }
                _data[tx+ty*4] = 15
            }
                //ピースを左にスライド(5)
            else if fy == ty && fx < tx {
                for i in fx..<tx {
                    _data[i+fy*4] = _data[i+fy*4+1]
                }
                _data[tx+ty*4] = 15
            }
                //ピースを右にスライド(5)
            else if fy == ty && fx > tx {
                for i in stride(from:fx,to: tx, by: -1) {
                    _data[i+fy*4]=_data[i+fy*4-1]
                }
                _data[tx+ty*4] = 15
            }
             var clearCheck = 0
             for i in 0..<16 {
                 let dx: CGFloat = 30+75*CGFloat(i%4)
                 let dy: CGFloat = 180+75*CGFloat(i/4)
                 
                 //ピースの移動アニメ
                 if _data[i] != 15 {
                     UIView.beginAnimations("anime0", context: nil)
                     UIView.setAnimationDuration(0.3)
                     _piece[_data[i]].frame = CGRect(x: dx, y: dy, width: 75, height: 75)
                     UIView.commitAnimations()
                 } else {
                     _piece[_data[i]].frame = CGRect(x: dx, y: dy, width: 75, height: 75)
                 }
                 
                 //クリアチェック
                 if _data[i] == i {clearCheck += 1}
             }

            
            return true
        }
}
