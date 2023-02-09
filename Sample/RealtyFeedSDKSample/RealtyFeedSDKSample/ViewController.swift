//
//  ViewController.swift
//  RealtyFeedSDKSample
//
//  Created by MR on 1/21/23.
//

import UIKit
import RealtyFeedSDK

class ViewController: UIViewController {
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var btnReLoad: UIButton!
    @IBOutlet weak var sg: UISegmentedControl!
    @IBOutlet weak var tfAPIKey: UITextField!
    
    @IBOutlet weak var tfRapidAPIKey: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    

    var dateStart = Date()

    fileprivate func fetchList() {
        guard let apiKey = tfAPIKey.text, let rapidApiKey = tfRapidAPIKey.text else {
            return
        }
        saveKey(apiKey, rapidApiKey)
        RealtyFeedSDK.initial(apiKey, rapidApiKey)

        self.showLoading()
        dateStart = Date()
        RealtyFeedSDK.API.instance.getListings(top: 200, receiver: { data, error in
            let dateString = self.calcDatesDiff()
            self.hideLoading()
            guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
                self.tvResult.text = "Failed in \(dateString) seconds. \n\nFailed to load listings!"
                return
            }
            self.tvResult.text = "Done in \(dateString) seconds \n\n\(res)"
        })
    }
    
    fileprivate func fetchProperty() {
        guard let apiKey = tfAPIKey.text, let rapidApiKey = tfRapidAPIKey.text else {
            return
        }
        saveKey(apiKey, rapidApiKey)
        RealtyFeedSDK.initial(apiKey, rapidApiKey)
        
        self.showLoading()
        dateStart = Date()
        RealtyFeedSDK.API.instance.getProperty("P_5dba1fb94aa4055b9f29691f", receiver: { data, error in
            let dateString = self.calcDatesDiff()
            self.hideLoading()
            guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
                self.tvResult.text = "Failed in \(dateString) seconds. \n\nFailed to load property!"
                return
            }
            self.tvResult.text = "Done in \(dateString) seconds \n\n\(res)"
        })
    }
    
    fileprivate func calcDatesDiff()-> Double{
        let dateDiff = Date().timeIntervalSince(self.dateStart)
        let dateString = Double(round(1000 * dateDiff) / 1000)
        return dateString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sgDidChange(self)
        reloadKeys()
    }


    @IBAction func btnReLoadDidTap(_ sender: Any) {
        if sg.selectedSegmentIndex == 0 {
            fetchList()
        } else {
            fetchProperty()
        }
    }
    
    @IBAction func sgDidChange(_ sender: Any) {
        if sg.selectedSegmentIndex == 0 {
            tvResult.text = """
RealtyFeedSDK.API.instance.getListings(top: 5, receiver: { data, error in
        self.hideLoading()
        guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
            self.tvResult.text = "{self.TAG}: Failed to load listings!"
            return
        }
        self.tvResult.text = "{self.TAG}: Done! \n\n{res})"
    })
"""
        } else {
            tvResult.text = """
RealtyFeedSDK.API.instance.getProperty("P_5dba1fb94aa4055b9f29691f", receiver: { data, error in
            self.hideLoading()
            guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
                self.tvResult.text = "{self.TAG}: Failed to load property!"
                return
            }
            self.tvResult.text = "{self.TAG}: Done! \n\n{res}"
        })
"""
        }
        tvResult.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func showLoading() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        btnReLoad.isEnabled = false
        btnReLoad.setTitle("Loading", for: .normal)
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        btnReLoad.isEnabled = true
        btnReLoad.setTitle("Fetch Data", for: .normal)
    }

    func saveKey(_ xAPIKey: String,_ rapidAPIKey: String){
        let defaults = UserDefaults.standard
        defaults.set(xAPIKey, forKey: "X-API-KEY")
        defaults.set(rapidAPIKey, forKey: "RAPID-API-KEY")
        defaults.synchronize()
    }
    
    func reloadKeys(){
        let defaults = UserDefaults.standard
        tfAPIKey.text = defaults.string(forKey: "X-API-KEY")
        tfRapidAPIKey.text = defaults.string(forKey: "RAPID-API-KEY")
    }
}

