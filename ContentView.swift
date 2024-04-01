//
//  ContentView.swift
//  To-Do Application
//
//  Created by Sasi Hemanth Siripurapu on 2024-03-31.

import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    var task: String
    var completed: Bool = false
}

struct TodoListView: View {
    @State private var newTodo = ""
    @State private var todos = [TodoItem]()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Image("bg4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            
            VStack {
                Text("To-Do List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text("Added items:")
                    .font(.headline)
                    .padding(.top, 20)
                
                List {
                    ForEach(todos) { todo in
                        HStack {
                            Button(action: {
                                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                                    todos[index].completed.toggle()
                                }
                            }) {
                                Image(systemName: todo.completed ? "checkmark.square" : "square")
                            }
                            .foregroundColor(.black)
                            
                            Text(todo.task)
                                .strikethrough(todo.completed)
                            
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                TextField("Enter a new to-do item", text: $newTodo)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 20) {
                    Button("Add") {
                        guard !newTodo.isEmpty else {
                            showAlert(message: "Please enter a to-do item.")
                            return
                        }
                        
                        todos.insert(TodoItem(task: newTodo), at: 0)
                        newTodo = ""
                        showAlert(message: "To-do item added successfully.")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Clear Completed") {
                        todos.removeAll(where: { $0.completed })
                        showAlert(message: "Completed to-do items cleared.")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("To-Do List"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        showAlert(message: "To-do item removed successfully.")
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct ContentView: View {
    var body: some View {
        TodoListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
