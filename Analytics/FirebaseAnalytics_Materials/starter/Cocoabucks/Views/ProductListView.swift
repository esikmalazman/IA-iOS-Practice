// Firebase Undefined symbols for architecture x86_64
//https://stackoverflow.com/questions/42292090/firebase-undefined-symbols-for-architecture-x86-64
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
          // TODO 3 - Custom User Properties
            FirebaseAnalytics
              .Analytics
              .setUserProperty(
                "cat_person",
                forName: "dog_or_cat_person")
          },
            secondaryButton: .default(Text("Dog Person")) {
              // TODO 4 - Custom User Properties
              FirebaseAnalytics
                .Analytics
                .setUserProperty(
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
