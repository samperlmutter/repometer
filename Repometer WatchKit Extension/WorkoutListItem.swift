//
//  WorkoutComponent.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/6/23.
//

import SwiftUI

struct WorkoutListItem: View {
    let workout: Workout
    @State private var navigateToDetail = false
    @State private var navigateToCounter = false

    var body: some View {
        RoundedRectangle(cornerRadius: 17, style: .continuous)
            .fill(Color("blueTertiaryColor"))
            .frame(height: 90)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .overlay(alignment: .center) {
                HStack {
                    VStack(alignment: .leading) {
                        Button(action: { navigateToDetail = true }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .foregroundStyle(Color("bluePrimaryColor"), Color("blueSecondaryColor"))
                                .font(.system(size: 24))
                        }
                        .padding(.top, 12)
                        .buttonStyle(.plain)
                        Spacer()
                        Text(workout.name)
                            .font(.system(size: 13).bold())
                            .foregroundStyle(.white)
                        Text("\(workout.numSets) sets of \(workout.numReps)")
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                            .padding(.bottom, 12)
                    }
                    .padding(.leading, 12)
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .foregroundStyle(Color("bluePrimaryColor"), Color("blueSecondaryColor"))
                        .font(.system(size: 50))
                    .padding(.trailing, 12)
                }
            }
            .onTapGesture {
                navigateToCounter = true
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                WorkoutDetailView(workout: workout)
            }
            .navigationDestination(isPresented: $navigateToCounter) {
                WorkoutTabView(workout: workout)
            }
    }
}

struct WorkoutComponent_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout.example()
        workout.name = "anterior pelvic tilt"
        return WorkoutListItem(workout: workout)
            .previewLayout(.sizeThatFits)
    }
}

