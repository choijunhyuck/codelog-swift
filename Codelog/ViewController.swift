//
//  ViewController.swift
//  Codelog
//
//  Created by 최준혁 on 11/10/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBAction func blogMakeButtonClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "MakeBlogController") as! UIViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list:[MyStruct] = [MyStruct]()
    
    struct MyStruct
    {
        
        var thumbnail = ""
        var name = ""
        var explanation = ""
        var member_count = ""
        var option1 = ""
        var option2 = ""
        var code = ""
        var owner = ""
        
        init(_ data:NSDictionary)
        {
            
            if let add = data["thumbnail"] as? String
            {
                self.thumbnail = add
            }
            
            if let add = data["name"] as? String
            {
                self.name = add
            }
            
            if let add = data["explanation"] as? String
            {
                self.explanation = add
            }
            
            if let add = data["member_count"] as? String
            {
                self.member_count = add
            }
            
            if let add = data["option1"] as? String
            {
                self.option1 = add
            }
            
            if let add = data["option2"] as? String
            {
                self.option2 = add
            }
            
            if let add = data["code"] as? String
            {
                self.code = add
            }
            
            if let add = data["owner"] as? String
            {
                self.owner = add
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let url = "http://207.148.115.109/codelog/export_blog_joined_all.php?uid=\(UserDefaults.standard.string(forKey: "uid")!)"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
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
            return
        }
        
        
        guard let data_array = json as? NSArray else
        {
            return
        }
        
        for i in 0 ..< data_array.count
        {
            if let data_object = data_array[i] as? NSDictionary
            {
                list.append(MyStruct(data_object))
            }
        }
        
        refresh_now()
        
    }
    
    func refresh_now()
    {
        DispatchQueue.main.async (
            execute:
        {
                self.collectionView.reloadData()
        }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as! BlogCell
        
        cell.layer.cornerRadius = 5
        /*list[indexPath.row].created_at*/
        
        cell.nameView.text = list[indexPath.row].name
        cell.explanationView.text = list[indexPath.row].explanation
        cell.memberView.text = list[indexPath.row].member_count
        cell.codeView.text = list[indexPath.row].code
        
        return cell
    }
    
}
