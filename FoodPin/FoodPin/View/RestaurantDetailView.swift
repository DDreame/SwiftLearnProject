//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by DDreame on 2024/5/7.
//
import SwiftUI
import SwiftData

struct RestaurantDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showReview = false
    
    @State var restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(uiImage:restaurant.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 445)
                    .overlay {
                        VStack {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(restaurant.name)
                                        .font(.custom("Nunito-Regular", size: 35, relativeTo: .largeTitle))
                                        .bold()
                                    Text(restaurant.type)
                                        .font(.system(.headline, design: .rounded))
                                        .padding(.all, 5)
                                        .background(.black)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                                .foregroundStyle(.white)
                            .padding()
                                Spacer()
                                if restaurant.rating != nil {
                                    Image(restaurant.rating!.image)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
                                        .padding()
                                        .font(.system(size: 30))
                                }
                            }
                        }
                    }
                
                Text(restaurant.summary)
                    .padding()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("ADDRESS")
                            .font(.system(.headline, design: .rounded))
                        
                        Text(restaurant.location)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("PHONE")
                            .font(.system(.headline, design: .rounded))
                        
                        Text(restaurant.phone)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                NavigationLink(
                    destination:
                        MapView(location: restaurant.location)
                            .toolbarBackground(.hidden, for: .navigationBar)
                            .edgesIgnoringSafeArea(.all)
                            
                ) {
                    MapView(location: restaurant.location, interactionMode: [])
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                Button {
                    self.showReview.toggle()
                } label: {
                    Text("Rate it")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .tint(Color("NavigationBarTitle"))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 25))
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 20)
                 
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.left"))")
                }
            }
            ToolbarItem(placement: .confirmationAction){
                Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 25))
                    .padding()
                    .foregroundStyle(restaurant.isFavorite ? .yellow : .white)// 保持顶部的 padding
                    .onTapGesture {
                        self.restaurant.isFavorite.toggle()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topTrailing)
            }
        }
        
        .ignoresSafeArea()
        .overlay(
            self.showReview ?
            ZStack{
                ReviewView(restaurant: restaurant, isDisplayed: $showReview)
            }
            : nil
        )
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: UIImage(named: "cafedeadend")!, isFavorite: true))
        
        //    .toolbarBackground(.hidden, for: .navigationBar)
    }
    .tint(.white)
}
