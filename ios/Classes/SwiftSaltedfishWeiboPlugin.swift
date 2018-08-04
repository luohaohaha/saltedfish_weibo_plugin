import Flutter
import UIKit
    
public class SwiftSaltedfishWeiboPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "saltedfish_weibo_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftSaltedfishWeiboPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
