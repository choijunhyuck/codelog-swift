//
//  SplashController.swift
//  Codelog
//
//  Created by 최준혁 on 14/10/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

class SplashController:UIViewController{
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DELAY 3SECONDS
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.checkUid()
            
        }
        
    }
    
    func checkUid() {
        
        //CHECK UID EXIST
        if(self.preferences.string(forKey: "uid") != nil){
            //CHECK HAS JOINED BLOG
            
            checkJoinedBlog()
        }else{
            self.preferences.set(
                UIDevice.current.identifierForVendor?.uuidString, forKey: "uid")
            //GO TO INITIAL
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func checkJoinedBlog(){
        
        let url = "http://207.148.115.109/codelog/check_initial.php?uid="
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
            //have no blog
            print("have no blog")
            return
        }
        
        
        guard let data_array = json as? NSArray else
        {
            return
        }
        
        if(data_array.count > 0){
            //testing
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
            present(vc, animated: true, completion: nil)
            print("splash - case  : 1")
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
            present(vc, animated: true, completion: nil)
            print("splash - case  : 2")
        }
        
    }
    
    /*
     
     func checkInternet(flag:Bool, completionHandler:@escaping (_ internet:Bool) -> Void)
     {
     UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
     let url = NSURL(string: "http://www.google.com/")
     let request = NSMutableURLRequest(url: url! as URL)
     
     request.httpMethod = "HEAD"
     request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
     request.timeoutInterval = 10.0
     
     NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue.main, completionHandler:
     {(response: URLResponse!, data: Data!, error: Error!) -> Void in
     UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
     let rsp = response as! HTTPURLResponse?
     
     completionHandler(rsp?.statusCode == 200)
     })
     }
     
     func yourMethod()
     {
     self.checkInternet(flag: false, completionHandler:
     {(internet:Bool) -> Void in
     
     if (internet)
     {
     // "Internet" aka Google URL reachable
     }
     else
     {
     // No "Internet" aka Google URL un-reachable
     }
     })
     }
     
     */
    
}
