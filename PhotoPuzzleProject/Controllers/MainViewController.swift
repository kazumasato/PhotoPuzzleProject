//
//  MainViewController.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2019/12/20.
//  Copyright © 2019 佐藤一馬. All rights reserved.
//

import UIKit
//import ViewController.h


class MainViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func didClickstartCamera(_ sender: UIButton) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera

               if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                   let picker = UIImagePickerController()
                   picker.sourceType = sourceType
                   picker.delegate = self
                   self.present(picker, animated: true)
               }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func didClickAlbumButton(_ sender: Any) {
        changeImage()
    }
    func changeImage() {
        //アルバムを指定
        //SourceType.camera：カメラを指定
        //SourceType.photoLibrary：アルバムを指定
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        //アルバムを立ち上げる
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            //アルバム画面を開く
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
        
    //アルバム画面で写真を選択した時
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imageにアルバムで選択した画像が格納される
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //ImageViewに表示
            self.imageView.image = image
//            //画像のサイズ変更
//            let image = image.resized(toWidth: 400)
            //アルバム画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func didClickNext(_ sender: Any) {
        performSegue(withIdentifier: "toNext", sender: nil)

    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? NextViewController {
    //            let image = [UIImagePickerController.InfoKey.originalImage] as? UIImage
                vc.selectedImage = imageView.image
            }
        }

}
