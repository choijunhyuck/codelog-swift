//
//  BlogController.swift
//  Codelog
//
//  Created by 최준혁 on 21/11/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class BlogController:UIViewController{
    
    let preferences = UserDefaults.standard
    
    var thumbnail = ""
    var name = ""
    var explanation = ""
    var member_count = ""
    var option1 = ""
    var option2 = ""
    var code = ""
    var owner = ""
    
    @IBOutlet weak var blogNameView: UILabel!
    
    
    @IBAction func blogSettingButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func blogBackButtonClicked(_ sender: Any) {
        
    }
    
    @IBOutlet weak var WriteButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.blogWriteButtonClicked))
        self.WriteButton.addGestureRecognizer(gesture)
        
    }
    
    @objc func blogWriteButtonClicked(sender : UITapGestureRecognizer) {
        
    }
    
    
}
