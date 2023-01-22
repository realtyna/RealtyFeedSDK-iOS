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

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    

    let TAG = "RealtyFeed-Sample"
    fileprivate func fetchList() {
        self.showLoading()
        RealtyFeedSDK.API.instance.getListings(top: 5, receiver: { data, error in
            self.hideLoading()
            guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
                self.tvResult.text = "\(self.TAG): Failed to load listings!"
                return
            }
            self.tvResult.text = "\(self.TAG): Done! \n\n\(res)"
        })
    }
    fileprivate func fetchProperty() {
        self.showLoading()
        RealtyFeedSDK.API.instance.getProperty("P_5dba1fb94aa4055b9f29691f", receiver: { data, error in
            self.hideLoading()
            guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
                self.tvResult.text = "\(self.TAG): Failed to load property!"
                return
            }
            self.tvResult.text = "\(self.TAG): Done! \n\n\(res)"
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sgDidChange(self)
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

}

