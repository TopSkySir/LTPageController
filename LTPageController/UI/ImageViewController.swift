//
//  ImageViewController.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/16.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imageView = UIImageView()
    var button = UIButton()
    var isButton: Bool = false {
        didSet {
            imageView.isHidden = isButton
            button.isHidden = !isButton
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.gray.cgColor

        button.setTitle("点击", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.frame = view.bounds
        view.addSubview(button)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
