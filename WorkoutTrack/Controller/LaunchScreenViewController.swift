//
//  TutorialViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/16.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "launchScreen", withExtension: "gif")!)
        let launchGif = UIImage.gifImageWithData(imageData!)
        let imageView2 = UIImageView(image: launchGif)
        imageView2.contentMode = .scaleAspectFit
        let width = view.frame.size.width
        let height = 200.0
        imageView2.frame = CGRect(x: 0,
                                  y: view.frame.size.height / 2.0 - height / 2.0 - 50,
                                  width: width, height: height)
        view.addSubview(imageView2)
        imageView2.animationDuration = launchGif!.duration
        print("DEBUG: Animation duration \(launchGif!.duration)")
        imageView2.animationRepeatCount = 1
        imageView2.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + launchGif!.duration) {
            print("DEBUG: Stop animation")
            imageView2.image = nil
            imageView2.image = UIImage(named: "launchLastScreen")
        }
    }
    
    //MARK: - Helpers
    
}
