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

struct ProductListView: View {
  let products: [Product] = Bundle.main.decode("products.json")
  @EnvironmentObject var order: Order
  @State var showOrderView = false
  @State var showAnalyticsQuestionnaire = false

  var body: some View {
    NavigationView {
      List {
        ForEach(products) { product in
          NavigationLink(
            destination: ProductDetailView(product: product)) {
            ProductView(product: product)
          }
        }
      }
      .navigationBarTitle("Cocoabucks")
      .navigationBarItems(
        leading: Button(action: {
          showAnalyticsQuestionnaire.toggle()
        }, label: {
          Image(systemName: "nose.fill").accentColor(Color("rw-green"))
        }),
        trailing: Button(action: {
          showOrderView.toggle()
        }, label: {
          Image(systemName: "cart.fill").accentColor(Color("rw-green"))
        })
      )
      .sheet(isPresented: $showOrderView) {
        NavigationView {
          CartView()
            .environmentObject(order)
        }
      }
      .alert(isPresented: $showAnalyticsQuestionnaire) {
        Alert(
          title: Text("Are you a cat or a dog person?"),
          message: Text("Your answer is collected anonymously."),
          primaryButton: .default(Text("Cat Person")) {
            FirebaseAnalytics.Analytics.setUserProperty(
              "cat_person",
              forName: "dog_or_cat_person")
          },
            secondaryButton: .default(Text("Dog Person")) {
              FirebaseAnalytics.Analytics.setUserProperty(
                "dog_person",
                forName: "dog_or_cat_person")
              }
        )
      }
    }
  }
}

struct ProductListView_Previews: PreviewProvider {
  static var previews: some View {
    ProductListView()
  }
}
