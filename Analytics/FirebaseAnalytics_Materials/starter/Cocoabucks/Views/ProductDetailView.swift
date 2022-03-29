
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
      // TODO 2 - Custom Events
      FirebaseAnalytics
        .Analytics
        .logEvent(
          // Custom Event Name
          "detail_screen_viewed",
          parameters: [
            AnalyticsParameterScreenName : "product_detail_view",
            // Add one custom parameter(product_name)
            "product_name" :product.name
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
