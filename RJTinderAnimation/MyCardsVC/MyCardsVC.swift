//
//  MyCardsVC.swift
//  HellowLit_v2
//
//  Created by Rakesh Jyoti on 12/6/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit

class MyCardsVC: UIViewController {

    @IBOutlet weak var cardManager: CardStackManagere!
    
    
    //MARK: -
    
    class func initWithXib() -> MyCardsVC
    {
        let name = String(describing: self)
        let vc = MyCardsVC.init(nibName: name, bundle: Bundle.main)
        
        return vc
    }
    
    //MARK: -

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cardManager.addCardsInView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
