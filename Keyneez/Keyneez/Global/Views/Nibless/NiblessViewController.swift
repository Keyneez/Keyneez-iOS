//
//  NiblessViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

class NiblessViewController: UIViewController {
    
    // MARK: - Methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable,
                message: "We do not support Storyboard"
    )
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable,
                message: "We do not support Storyboard"
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("We do not support Storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
