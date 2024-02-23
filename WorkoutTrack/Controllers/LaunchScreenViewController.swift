//
//  TutorialViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/16.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    //MARK: - Properties
    private var image2: UIImage?
    private var imageView2: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "launchScreen", withExtension: "gif")!)
        image2 = UIImage.gifImageWithData(imageData!)
        imageView2 = UIImageView(image: image2)
        imageView2.contentMode = .scaleAspectFit
        let width = view.frame.size.width
        let height = 200.0
        imageView2.frame = CGRect(x: 0,
                                  y: view.frame.size.height / 2.0 - height / 2.0 - 50,
                                  width: width, height: height)
        view.addSubview(imageView2)
        imageView2.animationDuration = image2!.duration
        Log.info("DEBUG: Animation duration \(image2!.duration)")
        imageView2.animationRepeatCount = 1
        imageView2.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + image2!.duration) { [weak self]  in
            Log.info("DEBUG: Stop animation")
            guard let self else { return }
            imageView2.image = nil
            imageView2.image = UIImage(named: "launchLastScreen")
        }
    }
    
    //MARK: - Helpers
    public func getImage() -> UIImage? {
        return image2
    }
    
    public func getImageView() -> UIImageView? {
        return imageView2
    }
}
