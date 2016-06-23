//
//  ViewController.swift
//  17_Whats_The_Weather
//
//  Created by Tomomi Tamura on 6/22/16.
//  Copyright © 2016 Tomomi Tamura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        //ちゃんとデータ取得ができた場合の動きを設定
        if let url = attemptedUrl {
            
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
            if let urlContent = data {
                    
                //取得したデータをデコードして読めるものに変換する
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                //欲しいデータが取得できているか確認
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                if websiteArray.count > 1 {
                        
                    //取得したデータを</span>ごとに区切ってarrayにする
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        
                    //一個上のコードがちゃんと働いていればwasSuccesfullをtrueにし結果をlabelに表示
                    if weatherArray.count > 1 {
                            
                        wasSuccessful = true
                        
                        //℃の丸が文字化けしているので修正
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        //response requestを強制終了しresultをlabelに表示
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.resultLabel.text = weatherSummary
                            
                        })
                            
                    }         
                        
                } // end of "if wesiteArray.count"
                    
            } // end of "let urlContent= data"
            
            if wasSuccessful == false {
                
                self.resultLabel.text = "Couldn't find the weather for that city - Please try again!"
                
            }
            
            
        } // end of "let task = "
            
        task.resume()
            
        } // end of "if let url = ..."

        else {
            
            self.resultLabel.text = "Couldn't find the weather for that city - Please try again!"

        } // end of else

        
    } // end of "func findWeather"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error ) -> Void in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                print(webContent)
                
            }
            
        }
        
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
