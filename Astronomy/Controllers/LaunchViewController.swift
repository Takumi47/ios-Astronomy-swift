//
//  LaunchViewController.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()        
    }
    
    // MARK: - Selector
    
    @IBAction func onRequestButtonTapped() {
        performSegue(withIdentifier: .list)
    }
    
    // MARK: - Private Implementation
    
    private func initUI() {
        requestButton.isHidden = true
        spinner.startAnimating()
        ImportOperations().importJSONFileIfNeeded { [weak self] isLoaded in
            self?.spinner.stopAnimating()
            self?.requestButton.isHidden = false
            self?.requestButton.isEnabled = isLoaded
        }
    }
}

// MARK: - Navigation

extension LaunchViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case list
    }
}
