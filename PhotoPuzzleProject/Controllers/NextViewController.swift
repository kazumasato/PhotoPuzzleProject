//
//  ViewController.swift
//  sampleProject
//
//  Created by 佐藤一馬 on 2020/01/21.
//  Copyright © 2020 佐藤一馬. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    //MainVCから取ってきた画像を入れる変数
    var selectedImage: UIImage!


    let BTN_START = 0 //スタート
    let SCREEN = UIScreen.main.bounds.size //画面サイズ
    let DIVISOR = CGFloat(4)


    //変数
    var _gameView: UIView!       //ゲームビュー
    var _titleLabel: UILabel!    //タイトルラベル
    var _piece = [UIImageView]() //ピース画像(2)
    var _data = [Int]()          //ピース配置情報(2)
    var _shuffle: Int = 0        //シャッフル
    var _startButton: UIButton!  //スタートボタン


    //====================
    //UI
    //====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = selectedImage!//.resized(toWidth: 400)
               
        createPuzzle(image: image, divisor: DIVISOR)

        //ゲーム画面のXY座標とスケールの指定(1)
        let vx: CGFloat = (SCREEN.width-360)/2
        let vy: CGFloat = (SCREEN.height-640)/2
        let scale = SCREEN.width/360
        _gameView = UIView()
        _gameView.frame = CGRect(x: vx, y: vy, width: 360, height: 640)
        _gameView.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.view.addSubview(_gameView)

        //背景の生成
        let bg = makeImageView(frame: CGRect(x: 0, y: 0, width: 360, height: 640),
                               image: UIImage(named: "background.image")!)
        _gameView.addSubview(bg)

        //絵の背景の生成
        let picturebg = makeImageView(frame: CGRect(x: 29, y: 179, width: 302, height: 302),
                                      image: image)
        _gameView.addSubview(picturebg)

        //タイトルラベルの生成
        _titleLabel = makeLabel(frame: CGRect(x: 0, y: 90, width: 360, height: 70),
                                text: "15 Puzzle", font: UIFont.systemFont(ofSize: 48))
        _gameView.addSubview(_titleLabel)

        //絵のビットマップの取得
        let picture = image
        let piece = makePieces(image: image, divisor: DIVISOR)
        for i in 0..<16 {
            _piece.append(makePieceImageView(frame: CGRect(
                x: CGFloat(30+(i%4)*75),
                y: CGFloat(180+Int(i/4)*75),
                width: 75, height: 75),
                index: i, picture: picture, piece: piece[i]))
            _data.append(i)
            _gameView.addSubview(_piece[i])
        }

        //スタートボタンの生成
        _startButton = makeButton(frame: CGRect(x: 124, y: 455, width: 114, height: 114),
                                  image: UIImage(named: "Button.logo")!, tag: BTN_START)
        _gameView.addSubview(_startButton)
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
        }
    }
    //ラベルの生成
    func makeLabel(frame: CGRect, text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.text = text
        label.font = font
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }

    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }

    //ピースイメージビューの生成
    func makePieceImageView(frame: CGRect, index: Int,
                            picture: UIImage, piece: UIImage) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        picture.draw(
            in: CGRect(x: CGFloat(-75*(index%4)),
                       y: CGFloat(-75*Int(index/4)),
                       width: 300, height: 300))
        piece.draw(in: CGRect(x: 0, y: 0, width: 75, height: 75))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return makeImageView(frame: frame, image: image)
    }

    //イメージボタンの生成
    func makeButton(frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.setImage(image, for: UIControl.State.normal)
        button.tag = tag
        button.addTarget(self, action: #selector(onClick(sender:)),
                         for: UIControl.Event.touchUpInside)
        return button
    }

    //====================
    //タッチイベント
    //====================
    //ボタンクリック時に呼ばれる
    @objc func onClick(sender: UIButton) {
        if sender.tag == BTN_START {
            //シャッフルの実行(8)
            _shuffle = 20
            while _shuffle > 0 {
                if movePiece(tx: rand(num: 4), ty: rand(num: 4)) {_shuffle -= 1}
            }
            for i in 0..<16 {
                let dx: CGFloat = 30+75*CGFloat(i%4)
                let dy: CGFloat = 180+75*CGFloat(i/4)
                _piece[_data[i]].frame =
                    CGRect(x: dx, y: dy, width: 75, height: 75)
            }

            //ゲーム開始
            _titleLabel.text = "15 Puzzle"
            _piece[15].alpha = 0
            _startButton.alpha = 0
        }
    }

    //タッチ開始時に呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _startButton.alpha != 0 {
            return
        }
        //タッチ位置からピースの列番号と行番号を求める(3)
        let pos = touches.first!.location(in: _gameView)
        if 30 < pos.x && pos.x < 330 && 180 < pos.y && pos.y < 480 {
            let tx = Int((pos.x-30)/75)
            let ty = Int((pos.y-180)/75)
            movePiece(tx: tx, ty: ty)
        }
    }

    //ピースの移動
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
            for i in stride(from: fy, to: ty, by: -1) {
                //エラー発生
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
            for i in stride(from: fx, to: tx, by: -1) {
                //エラー発生
                _data[i+fy*4]=_data[i+fy*4-1]
            }
            _data[tx+ty*4] = 15
        }

        //シャッフル時はピースの移動アニメとクリアチェックは行わない
        if _shuffle > 0 {
            return true
        }

        //ピースの移動アニメとクリアチェック(6)
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
        //ゲームのクリア判定(7)
        if clearCheck == 16 {
            _titleLabel.text = "Clear!"
            _startButton.alpha = 100

            //ピースの出現アニメ
            UIView.beginAnimations("anime1", context: nil)
            UIView.setAnimationDuration(0.6)
            _piece[15].alpha = 100
            UIView.commitAnimations()
        }
        return true
    }









    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func rand(num: UInt32) -> Int {
        return Int(arc4random()%num)
    }


}
