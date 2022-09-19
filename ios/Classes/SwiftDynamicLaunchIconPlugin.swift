import Flutter
import UIKit

// channels
private let CHANNEL_NAME = "dynamic_icon"
// events
private let GET_DYNAMIC_ICONS_AVAILABLE_STATE = "getDynamicIconsAvailableState"
private let GET_AVAILABLE_DYNAMIC_ICONS = "getAvailableDynamicIcons"
private let GET_ACTIVE_DYNAMIC_ICON = "getActiveDynamicIcon"
private let SET_ACTIVE_DYNAMIC_ICON = "setActiveDynamicIcon"
// constants
private let ICON_ID = "id"
private let ICON_NAME = "name"
private let ICON_PREVIEW = "iconPreview"
private let PRIMARY_ICON_ID = "primary"
private let PRIMARY_ICON_DEFAULT_NAME = "Primary"
private let PRIMARY_ICON_NAME = "PrimaryIconName"

public class SwiftDynamicLaunchIconPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftDynamicIconPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case GET_DYNAMIC_ICONS_AVAILABLE_STATE: result(getDynamicIconAvailableState())
        case GET_ACTIVE_DYNAMIC_ICON: result(getActiveDynamicIcon())
        case GET_AVAILABLE_DYNAMIC_ICONS: result(getAvailableDynamicIcons())
        case SET_ACTIVE_DYNAMIC_ICON:
            setActiveIcon(id: (call.arguments as! String))
            result(nil)
        default:
            result("Method not found")
        }
    }
    
    private func getDynamicIconAvailableState() -> Bool {
        if #available(iOS 10.3, *) {
            return UIApplication.shared.supportsAlternateIcons
        } else {
            return false
        }
    }
    
    private func getActiveDynamicIcon() -> String {
        if #available(iOS 10.3, *)  {
            return UIApplication.shared.alternateIconName ?? PRIMARY_ICON_ID
        } else {
            return PRIMARY_ICON_ID
        }
    }
    
    private func getMainConfig() -> [String: Any?]? {
        var config: [String: Any]?
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                
            }
        }
        return config
    }
    
    private func getPrimaryIconInfo(config: [String: Any?]?) -> [String: Any?] {
        let bundleIcons = config?["CFBundleIcons"] as? [String: Any]
        let primaryIcon = bundleIcons?["CFBundlePrimaryIcon"] as? [String: Any]
        let iconFiles = primaryIcon?["CFBundleIconFiles"] as? [String]
        let imageData = iconFiles?.first != nil ? UIImage(named: iconFiles!.last!)?.pngData() : nil
        let iconPreview = imageData != nil ? [UInt8](imageData!) : nil
        return [
            ICON_ID : PRIMARY_ICON_ID,
            ICON_NAME : bundleIcons?[PRIMARY_ICON_NAME] ?? PRIMARY_ICON_DEFAULT_NAME,
            ICON_PREVIEW : iconPreview
        ]
    }
    
    private func getAvailableDynamicIcons() -> Array<[String: Any?]>? {
        if #available(iOS 10.3, *)  {
            let config = getMainConfig()
            let bundleIcons = config?["CFBundleIcons"] as? [String: Any?]
            let alternativeIcons = bundleIcons?["CFBundleAlternateIcons"] as? [String: Any?]
            
            var icons = alternativeIcons?.map { (key: String, value: Any?) -> [String: Any?] in
                let name = (value as? [String: Any?])?["DynamicIconDisplayName"] ?? key
                let imageData = UIImage(named: key)?.pngData()
                let iconPreview = imageData != nil ? [UInt8](imageData!) : nil
                return [
                    ICON_ID : key,
                    ICON_NAME : name,
                    ICON_PREVIEW: iconPreview
                ]
            }
            icons?.insert(getPrimaryIconInfo(config: config), at: 0)
            return icons
        } else {
            return nil
        }
    }
    
    private func setActiveIcon(id: String) {
        if #available(iOS 10.3, *) {
            if (id == PRIMARY_ICON_ID) {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName(id)
            }
        }
    }
}
