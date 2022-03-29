/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
            FirebaseAnalytics.Analytics.logEvent(AnalyticsEventPurchase, parameters: [
              AnalyticsParameterPaymentType: Self.paymentTypes[paymentType],
              AnalyticsParameterPrice: totalPrice,
              AnalyticsParameterSuccess: "1",
              AnalyticsParameterCurrency: "USD"
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
