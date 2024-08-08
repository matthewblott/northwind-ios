import Strada

extension BridgeComponent {
  nonisolated static var allTypes: [BridgeComponent.Type] {
    [
      ButtonComponent.self,
      FormComponent.self,
    ]
  }
}
