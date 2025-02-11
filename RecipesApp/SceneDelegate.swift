//
//  SceneDelegate.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private enum Constants {
        static let signInNavigationControllerIdentifier = "SignInNavigationController"
        static let feedTabBarControllerIdentifier = "FeedTabBarController"
        static let storyboardIdentifier = "Main"
    }

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("signIn"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.signIn()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("signOut"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.signOut()
        }
        
        // Check if a current user exists
        if User.current != nil {
            signIn()
        }
    }
    
    func signIn() {
        let storyboard = UIStoryboard(name: Constants.storyboardIdentifier, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: Constants.feedTabBarControllerIdentifier)
    }
    
   func signOut() {
        
        // This will also remove the session from the Keychain, log out of linked services and all future calls to current will return nil.
        User.logout { [weak self] result in

            switch result {
            case .success:

                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: Constants.storyboardIdentifier, bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: Constants.signInNavigationControllerIdentifier)
                    self?.window?.rootViewController = viewController
                }
            case .failure(let error):
                print("❌ Log out error: \(error)")
            }
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// private funcs? check names enums n stuff
