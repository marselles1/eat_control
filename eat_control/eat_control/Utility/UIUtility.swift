//
//  UIUtility.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

public class UIUtility {

    static func showPageViewController(vc: UIViewController, identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let secondVC = storyboard.instantiateViewController(identifier: identifier)
            vc.show(secondVC, sender: self)
        } else {
            // Fallback on earlier versions
            let secondVC = storyboard.instantiateViewController(withIdentifier: identifier)
            vc.show(secondVC, sender: self)
        }
    }
    
    static func showAddEventViewController(vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            if let secondVC = storyboard.instantiateViewController(identifier: Constants.addEventViewController) as? TabBarViewController {
                vc.show(secondVC, sender: self)
            }
        } else {
            // Fallback on earlier versions
            if let secondVC = storyboard.instantiateViewController(withIdentifier: Constants.addEventViewController) as? TabBarViewController {
                vc.show(secondVC, sender: self)
            }
        }
    }
    
    static func presentViewController(vc: UIViewController, identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let secondVC = storyboard.instantiateViewController(identifier: identifier)
            secondVC.modalPresentationStyle = .fullScreen
            secondVC.modalTransitionStyle = .flipHorizontal
            vc.present(secondVC, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let secondVC = storyboard.instantiateViewController(withIdentifier: identifier)
            secondVC.modalPresentationStyle = .fullScreen
            secondVC.modalTransitionStyle = .flipHorizontal
            vc.present(secondVC, animated: true, completion: nil)
        }
    }
    
    static func presentMainViewController(vc: UIViewController, cachedData: CachedModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            if let secondVC = storyboard.instantiateViewController(identifier: "main_vc") as? TabBarViewController {
                secondVC.modalPresentationStyle = .fullScreen
                secondVC.modalTransitionStyle = .flipHorizontal
                secondVC.cachedData = cachedData
                vc.present(secondVC, animated: true, completion: nil)
            }
        } else {
            // Fallback on earlier versions
            if let secondVC = storyboard.instantiateViewController(withIdentifier: "main_vc") as? TabBarViewController {
                secondVC.modalPresentationStyle = .fullScreen
                secondVC.modalTransitionStyle = .flipHorizontal
                secondVC.cachedData = cachedData
                vc.present(secondVC, animated: true, completion: nil)
            }
        }
    }

}
