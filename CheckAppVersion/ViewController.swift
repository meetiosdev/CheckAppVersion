//
//  ViewController.swift
//  CheckAppVersion
//
//  Created by Swarajmeet Singh on 27/06/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppVersion.checkForUpdate(forceUpdate: true)
    }


}

