import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    var appleEventURLString: String = ""

    override func applicationDidFinishLaunching(_ notification: Notification) {
        let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "app.channel.shared.data", binaryMessenger: controller.engine.binaryMessenger)

        methodChannel.setMethodCallHandler {
            (_ call: FlutterMethodCall, _ result: FlutterResult) in
            if call.method == "getLoginCode" {
                result(self.appleEventURLString)
                self.appleEventURLString = ""
            }
        }
    }

    override func applicationWillFinishLaunching(_ aNotification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleAppleEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    @objc func handleAppleEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
//        NSString *path = [[[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSAlert *alert = [[NSAlert alloc] init];
//        [alert setMessageText:[NSString stringWithFormat:@"app receive custom url click:%@", path]];
//        [alert addButtonWithTitle:@"OK"];
//        [alert runModal];
        guard let appleEventDescription = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) else {
            return
        }
        guard let appleEventURLString = appleEventDescription.stringValue else {
            return
        }
        print("Receive url string \(appleEventURLString)")
        self.appleEventURLString = appleEventURLString
    }

    //  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      let absoluteString = url.absoluteURL.absoluteString
//      let urlComponents = NSURLComponents(string: absoluteString)
//      let queryItems = urlComponents?.queryItems
//      for item in queryItems! {
//          paramsMap[item.name] = item.value
//      }
//      return true
    //  }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
