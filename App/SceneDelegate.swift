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
    UINavigationBar.configureWithOpaqueBackground()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    visit()
  }
    
  private func visit() {
    let url = URL(string: "http://localhost:3000")
    let controller = WebViewController()
    controller.visitableURL = url
    session.visit(controller, action: .advance)
    navigationController.pushViewController(controller, animated: true)
  }

}

extension SceneDelegate: SessionDelegate {
  func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
    let controller = WebViewController()
    controller.visitableURL = proposal.url
    session.visit(controller, options: proposal.options)
    navigationController.pushViewController(controller, animated: true)

  }
    
  func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
    print("didFailRequestForVisitable: \(error)")
  }
    
  func sessionWebViewProcessDidTerminate(_ session: Session) {
    session.reload()
  }
}

