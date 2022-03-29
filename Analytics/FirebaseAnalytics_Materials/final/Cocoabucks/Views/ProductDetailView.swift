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

struct ProductDetailView: View {
  var product: Product
  let screen = UIScreen.main.bounds

  @EnvironmentObject var order: Order

  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Image(product.image)
        .resizable()
        .scaledToFit()
        .frame(width: screen.width, height: 300, alignment: .center)
        .clipped()
        .background(Color("rw-green"))
      HStack {
        Text("\(product.calories) Cals")
          .padding()
        Divider()
        Text("$\(product.price, specifier: "%.2f")")
          .fontWeight(.semibold)
          .padding()
      }
      .frame(width: screen.width, height: 30, alignment: .center)

      Text(product.description)
        .font(.body)
        .foregroundColor(.secondary)
        .padding()

      Divider()

      Button(action: {
        order.add(product: product)
      }, label: {
        Text("Add to cart")
        Image(systemName: "cart")
      })
      .font(.title3)
      .padding()
      .foregroundColor(Color("rw-green"))
      Spacer()
    }
    .navigationBarTitle(Text(product.name), displayMode: .inline)
    .onAppear {
      FirebaseAnalytics.Analytics.logEvent("detail_screen_viewed", parameters: [
        AnalyticsParameterScreenName: "product_detail_view",
        "product_name": product.name
      ])
    }
  }
}

struct ProductDetailView_Previews: PreviewProvider {
  static let order = Order()
  static var previews: some View {
    NavigationView {
      ProductDetailView(product: Product.example).environmentObject(order)
    }
  }
}
