//
//  AddBlogController.swift
//  Codelog
//
//  Created by 최준혁 on 25/11/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class MakeBlogController:UIViewController {
    
    var OPTION1_CONTROLLER = true
    var OPTION2_CONTROLLER = true
    var option1 = 1
    var option2 = 1
    
    var preferences = UserDefaults.standard
    
    var code : String = ""
    
    @IBAction func BackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var thumbnailButton: UIView!
    
    @IBOutlet weak var thumbnailView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var explanationField: UITextView!
    
    @IBOutlet weak var codeView: UILabel!
    
    @IBOutlet weak var option1Layout: UIButton!
    
    @IBOutlet weak var option2Layout: UIButton!
    
    @IBOutlet weak var emptyAlert: UILabel!
    
    @IBAction func option1Clicked(_ sender: Any) {
        
        if(OPTION1_CONTROLLER){
            option1Layout.backgroundColor = UIColor(red: 201/255, green: 73/255, blue: 73/255, alpha: 1.0)
            OPTION1_CONTROLLER = false
            option1 = 0
        }else{
            option1Layout.backgroundColor = UIColor(red: 78/255, green: 153/255, blue: 57/255, alpha: 1.0)
            OPTION1_CONTROLLER = true
            option1 = 1
        }
        
    }
    
    @IBAction func option2Clicked(_ sender: Any) {
        
        if(OPTION2_CONTROLLER){
            option2Layout.backgroundColor = UIColor(red: 201/255, green: 73/255, blue: 73/255, alpha: 1.0)
            OPTION2_CONTROLLER = false
            option2 = 0
        }else{
            option2Layout.backgroundColor = UIColor(red: 78/255, green: 153/255, blue: 57/255, alpha: 1.0)
            OPTION2_CONTROLLER = true
            option2 = 1
        }
        
    }
    
    @IBAction func makeClicked(_ sender: Any) {
        
        if(nameField.text != "" && explanationField.text != ""){
        makeBlog()
            emptyAlert.isHidden = true
        }else{
            emptyAlert.isHidden = false
            emptyAlert.shake()
        }
        
    }
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCapacity(uid: UserDefaults.standard.string(forKey: "uid")!)
     
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.imageTapped(sender:)))
        self.thumbnailButton.addGestureRecognizer(gesture)
        
        code = randomString(length: 6)
        codeView.text = code
        
        layoutSetting()
        
    }
    
    func checkCapacity(uid:String){
        
        let link = "http://207.148.115.109/codelog/check_capacity.php?uid="+uid
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
            //have no blog
            print("accept1")
            return
        }
        
        
        guard let data_array = json as? NSArray else
        {
            return
        }
        
        if(data_array.count > 2){
            self.dismiss(animated: true, completion: nil)
            print("can't")
        }else{
            print("accept2")
        }
        
    }
    
    func layoutSetting(){
        
        explanationField.layer.cornerRadius = 5
        
    }
    
    @objc func imageTapped(sender : UITapGestureRecognizer)
    {
        let tappedImage = sender.view as! UIView
        
        let alert = UIAlertController(title: "사진 선택", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "갤러리", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "기본 이미지", style: .default, handler: { _ in
            //기본이미지 함수넣기!
            
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: { _ in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func makeBlog(){
        //need testing
        
        var thumbnail = code+".png"
        
        let uid = self.preferences.string(forKey: "uid")
        
        let url = URL(string: "http://207.148.115.109/codelog/make_blog_ios.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let uploadString = "thumbnail=\(thumbnail)&name=\(nameField.text!)&explanation=\(explanationField.text!)&member_count=1&option1=\(String(option1))&option2=\(String(option2))&code=\(code)&owner=\(uid!)"
    
        request.httpBody = uploadString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            
            if(responseString != "server_error"){
                //start match up
                print("blog maked")
                //go to matching screen
            }else{
                //uploaded que
                print("server error")
                //go to waiting matching screen
            }
            
        }
        task.resume()
        
        /*
        let url = "http://207.148.115.109/codelog/thumbnail/"+code+".png"+"&name="+nameField.text+"&explanation="+explanationField.text+"&member_count=1"+"&option1="+String(option1)+"&option2="+String(option2)+"&code="+code+"&owner="
 
        let link = url + uid
        
        get_data(link)
         */
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKMLNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
