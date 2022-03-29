
import SwiftUI
import Firebase

struct CheckoutView: View {
  static let paymentTypes = ["Cash", "Credit Card", "Cocoabucks Points"]
  static let tipAmounts = [10, 15, 20, 0]
  
  @EnvironmentObject var order: Order
  @Environment(\.presentationMode) var presentationMode
  
  var totalPrice: Double {
    let total = Double(order.total)
    let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
    return total + tipValue
  }
  
  @State private var paymentType = 0
  @State private var showLoyaltyCardDetails = false
  @State private var loyaltyCardNumber = ""
  @State private var tipAmount = 1
  @State private var showAlert = false
  
  var body: some View {
    Form {
      Section {
        Picker("Choose your payment option", selection: $paymentType) {
          ForEach(0 ..< Self.paymentTypes.count) {
            Text(Self.paymentTypes[$0])
          }
        }
        Toggle(isOn: $showLoyaltyCardDetails.animation()) {
          Text("Add loyalty card")
        }
        if showLoyaltyCardDetails {
          TextField("Enter loyalty card number", text: $loyaltyCardNumber)
        }
        
        Section(header: Text("Add a tip?")) {
          Picker("Percentage:", selection: $tipAmount) {
            ForEach(0 ..< Self.tipAmounts.count) {
              Text("\(Self.tipAmounts[$0])%")
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        Section(header: Text("TOTAL: $\(totalPrice, specifier: "%.2f")").font(.largeTitle)) {
          Button(action: {
            showAlert.toggle()
            presentationMode.wrappedValue.dismiss()
            // TODO 1 - Predifined Events From Firebase
            /// Log all type of events 
            FirebaseAnalytics
              .Analytics
              .logEvent(
                AnalyticsEventPurchase,
                parameters: [
                  // Predifined Event name
                  AnalyticsParameterPaymentType : Self.paymentTypes[paymentType],
                  // Parameter name
                  AnalyticsParameterPrice : totalPrice,
                  AnalyticsParameterSuccess : "1",
                  AnalyticsParameterCurrency : "USD"
                ])
            order.products.removeAll()
          }, label: {
            Text("Confirm Order")
          })
        }
      }
    }
    .accentColor(Color("rw-green"))
    .navigationBarTitle(Text("Order"), displayMode: .inline)
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text("Order confirmed"),
        message: Text("Your order has been placed!"),
        dismissButton: .default(Text("OK")))
    }
  }
}

struct CheckoutView_Previews: PreviewProvider {
  static let order = Order()
  static var previews: some View {
    CheckoutView()
      .environmentObject(order)
  }
}
