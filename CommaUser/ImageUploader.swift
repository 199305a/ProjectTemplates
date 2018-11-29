//
//  ImageUploader.swift
//  CommaUser
//
//  Created by Marco Sun on 16/8/18.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageUploader: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    typealias PickerClosure = (UIImage, String) -> ()
    let imagePicker = LFImagePickerController()
    let sheet = LFActionSheet.init(message: nil, cancelTitle: nil, itemTitles: [Text.Camera, Text.PhotoLibray])
    lazy var disposeBag = DisposeBag()
    var image: UIImage?
    var obtainImage: ImageClosure?
    weak var vc: UIViewController!
    
    init(vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    func showPicker() {
        sheet.show()
        sheet.action = { [unowned self] index in
            let imagePicker = LFImagePickerController()
            imagePicker.delegate = self
            switch index {
            case 0:
                imagePicker.cemeraHandle({ /**< 手机拍照 */
                    self.vc.present(imagePicker, animated: true, completion: nil)
                }, limitHandle: {
                    LFAlertView.showPhotoAuthInfo(Text.Camera)
                })
            case 1:
                imagePicker.libaryHandle({ /**< 手机相册 */
                    self.vc.present(imagePicker, animated: true, completion: nil)
                }, limitHandle: {
                    LFAlertView.showPhotoAuthInfo(Text.PhotoLibray)
                })
            default:
                break
            }
        }
    }
    
    /**
     上传图片
     */
    func commitPhoto(_ image: UIImage, imagePicker: UIImagePickerController?,success: PickerClosure?, error: ErrorClosure? = nil, failed: FailedClosure? = nil) {
        self.image = image
        AliyunOSSManager.shared.uploadImage(image, success: { (file) in
            success?(image, file)
        }) { (code, msg) in
            error?(code, msg)
        }
        
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    
    // 获得图片
    func obtainImage(_ image: UIImage, imagePicker: UIImagePickerController) {
        self.image = image
        self.obtainImage?(image)
        imagePicker.dismiss(animated: true, completion: nil)
    }
        
    // MARK: - image picker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.obtainImage(image, imagePicker: picker)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.vc.dismiss(animated: true, completion: nil)
    }
    
}
