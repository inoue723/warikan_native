import Foundation

enum Flavor: String, CaseIterable {
    case development, staging, production

    static let current: Flavor = {
        let value = Bundle.main.infoDictionary?["FlutterFlavor"]
        let flavor = Flavor(rawValue: (value as? String)?.lowercased() ?? "")
        assert(flavor != nil, "invalid flavor value: \(value ?? "")")
        return flavor ?? .development
    }()
}