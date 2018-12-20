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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
//        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.gray.cgColor
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
