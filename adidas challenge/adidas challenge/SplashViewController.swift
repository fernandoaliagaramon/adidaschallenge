//
//  SplashViewController.swift
//  adidas challenge
//
//  Created by Fernando Aliaga on 10/8/17.
//  Copyright © 2017 Fernando Aliaga. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var Imagen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(SplashViewController.showMain), with: nil, afterDelay: 5)
        // Do any additional setup after loading the view.
    }
    
    @objc func showMain(){
        performSegue(withIdentifier: "main", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
