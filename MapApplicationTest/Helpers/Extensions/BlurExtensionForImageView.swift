//
//  blurExtensionForUIImage.swift
//  MapApplicationTest
//
//  Created by Alexander on 20.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

extension UIImageView {
  
  func blurImage() {
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(blurEffectView)
  }
}
