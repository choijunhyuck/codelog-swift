//
//  InitialController.swift
//  Codelog
//
//  Created by 최준혁 on 14/10/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class InitialController:UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeField: UITextField!

    /*
    var list:[MyStruct] = [MyStruct]()
    
    struct MyStruct
    {
        var blog_thumbnail = ""
        var blog_name = ""
        var blog_explanation = ""
        var blog_member_count = ""
        var blog_option1 = ""
        var blog_option2 = ""
        var blog_code = ""
        var blog_owner = ""
        
        init(_ data:NSDictionary)
        {
            
            if let add = data["thumbnail"] as? String
            {
                self.blog_thumbnail = add
            }
            if let add = data["name"] as? String
            {
                self.blog_name = add
            }
            if let add = data["explanation"] as? String
            {
                self.blog_explanation = add
            }
            if let add = data["member_count"] as? String
            {
                self.blog_member_count = add
            }
            if let add = data["option1"] as? String
            {
                self.blog_option1 = add
            }
            if let add = data["option2"] as? String
            {
                self.blog_option2 = add
            }
            if let add = data["code"] as? String
            {
                self.blog_code = add
            }
            if let add = data["owner"] as? String
            {
                self.blog_owner = add
            }
            
        }
        
    }
    */
    
    @IBAction func blogMakeClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "MakeBlogController") as! UIViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //max text setting
        codeField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        codeField.delegate = self

        //text watcher
        codeField.addTarget(self, action: #selector(InitialController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if(textField.text?.count == 6){
            findBlog()
        }

    }

    //max text setting
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }

        let substringToReplace = textFieldText[rangeOfTextToReplace]

        let count = textFieldText.count - substringToReplace.count + string.count

        return count <= 6

    }

    func findBlog(){

        let url = "http://207.148.115.109/codelog/export_blog.php?code="+codeField.text!

        get_data(url)

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
            //have no blog
            print("have no blog")
            return
        }

        guard let data_array = json as? NSDictionary else
        {
            return
        }

        let data = data_array.object(forKey: "blog") as! NSDictionary

        let thumbnail = data.object(forKey: "thumbnail") as! String
        let name = data.object(forKey: "name") as! String
        let explanation = data.object(forKey: "explanation") as! String
        let member_count = String(data.object(forKey: "member_count") as! String)
        let option1 = String(data.object(forKey: "option1") as! String)
        let option2 = String(data.object(forKey: "option2") as! String)
        let code = data.object(forKey: "code") as! String
        let owner = data.object(forKey: "owner") as! String
        
        DispatchQueue.main.async {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BlogPreviewController") as! BlogPreviewController
            
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

}
