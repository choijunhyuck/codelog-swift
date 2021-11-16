//
//  BlogPreviewController.swift
//  Codelog
//
//  Created by 최준혁 on 06/11/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class BlogPreviewController:UIViewController{
    
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var blogThumbnail: UIImageView!
    
    @IBOutlet weak var blogName: UILabel!
    
    @IBOutlet weak var blogExplanation: UILabel!
    
    @IBOutlet weak var blogMember: UILabel!
    
    @IBOutlet weak var blogCode: UILabel!
    
    @IBOutlet weak var blogLayout: UIView!
    
    @IBOutlet weak var blogAddLayout: UIButton!
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blogAddButtonClicked(_ sender: Any) {
        joinBlog()
    }
    
    var thumbnail = ""
    var name = ""
    var explanation = ""
    var member_count = ""
    var option1 = ""
    var option2 = ""
    var code = ""
    var owner = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: thumbnail)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        blogThumbnail.image = UIImage(data: data!)
        
        blogName.text = name
        blogExplanation.text = explanation
        blogMember.text = member_count+" MEMBERS"
        blogCode.text = code

        layoutSetting()
        
    }
    
    func layoutSetting(){
        
        blogLayout.layer.cornerRadius = 15
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.blogDetails))
        self.blogLayout.addGestureRecognizer(gesture)
        
    }
    
    @objc func blogDetails(sender : UITapGestureRecognizer) {
        
        checkJoinedBlog()
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    

    func checkJoinedBlog(){
        
        let url = "http://207.148.115.109/codelog/export_blog_joined.php?code="+code+"&uid="
        let uid = self.preferences.string(forKey: "uid")
        let link = url+uid!
        
        get_data(link)
        
    }
    
    func get_data(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            self.extract_data(data)
            
        })
        
        task.resume()
    }
    
    func extract_data(_ data:Data?)
    {
        let json:Any?
        
        if(data == nil)
        {
            return
        }
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data!, options: [])
        }
            
        catch
        {
            return
        }
        
        guard let data_array = json as? NSDictionary else
        {
            DispatchQueue.main.async {
                self.blogAddLayout.shake()
            }
            return
        }
        
        let data = data_array.object(forKey: "blog") as! NSDictionary
        
        let serverThumbnail = data.object(forKey: "thumbnail") as! String
        
        if(serverThumbnail != ""){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BlogController") as! BlogController
            
            vc.thumbnail = thumbnail
            vc.name = name
            vc.explanation = explanation
            vc.member_count = member_count
            vc.option1 = option1
            vc.option2 = option2
            vc.code = code
            vc.owner = owner
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func joinBlog(){
        
    }
    
}
