import UIKit
import Turbo
import WebKit
import Strada

class SceneDelegate: UIResponder, UIWindowSceneDelegate, BridgeDestination {
  var window: UIWindow?
  private let navigationController = UINavigationController()
  let viewController = WebViewController()
  private lazy var session: Session = {
    let webView = WKWebView(frame: .zero, configuration: .appConfiguration)
    Bridge.initialize(webView)
    let session = Session(webView: webView)
    session.delegate = self
    return session
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
      
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    navigationController.pushViewController(viewController, animated: true)
    visit(url: URL(string: "http://localhost:45678")!)
  }

  private func visit(url: URL) {
    viewController.visitableURL = url
    session.visit(viewController, action: .advance)
  }
    
}

extension SceneDelegate: SessionDelegate {
  func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
    visit(url: proposal.url)
  }
    
  func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
    print("didFailRequestForVisitable: \(error)")
  }
    
  func sessionWebViewProcessDidTerminate(_ session: Session) {
    session.reload()
  }
}

