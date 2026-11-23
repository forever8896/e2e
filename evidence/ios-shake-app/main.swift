import UIKit

/// Counts UIKit motion-shake events on screen and in Documents/shakes.txt.
final class ShakeViewController: UIViewController {
  private let label = UILabel()
  private var shakes = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 44)
    label.textAlignment = .center
    label.accessibilityIdentifier = "shake-count"
    label.frame = view.bounds
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(label)
    render()
  }

  override var canBecomeFirstResponder: Bool { true }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    becomeFirstResponder()
  }

  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    guard motion == .motionShake else { return }
    shakes += 1
    render()
  }

  private func render() {
    label.text = "Shakes: \(shakes)"
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    try? "\(shakes)\n".write(to: documents.appendingPathComponent("shakes.txt"), atomically: true, encoding: .utf8)
  }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = ShakeViewController()
    window.makeKeyAndVisible()
    self.window = window
  }
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool { true }
}
