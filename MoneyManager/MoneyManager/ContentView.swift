//
//  ContentView.swift
//  MoneyManager
//
//  Created by Bruch, Beth on 4/10/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ExpenseItem: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
}

struct ContentView: View {
    @State private var expenses = [ExpenseItem]()
    @State private var loans = [ExpenseItem]()
    @State private var creditCardPayments = [ExpenseItem]()
    @State private var incomeAmount = ""
    @State private var newIncomeAmount = ""
    @State private var newExpenseName = ""
    @State private var newExpenseAmount = ""
    @State private var newLoanName = ""
    @State private var newLoanAmount = ""
    @State private var newPaymentName = ""
    @State private var newPaymentAmount = ""
    @State private var backgroundColorHex = "#E5F0F4" // Default background color
        @State private var buttonColorHex = "#38779A" // Default button color
        @State private var textFieldBorderColorHex = "#DFDFDF" // Default text field border color
    @State private var textFieldFillColorHex = "#F7FBFB" // Default text field fill color
    @State private var textColorHex = "#07151D" // Default text color
    
    var totalAmount: Double {
        let totalExpenses = expenses.reduce(0) { $0 + $1.amount }
        let totalLoans = loans.reduce(0) { $0 + $1.amount }
        let totalCreditCardPayments = creditCardPayments.reduce(0) { $0 + $1.amount }
        return totalExpenses + totalLoans + totalCreditCardPayments
    }
    
    var remainingIncome: Double {
        guard let income = Double(incomeAmount) else { return 0 }
        return income - totalAmount
        
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("Monthly Money Manager")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: textColorHex))
                    .padding(.bottom, 5) // Adjust as needed
                    .padding(.top, 10)
                
                    Text("Easily track your monthly expenses, loans, and credit card payments. Press 'Submit' to record your income and 'Add' to input new transactions. Stay on top of your finances effortlessly!")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: textColorHex))
                        .padding(.bottom, 10) // Adjust as needed
                        .padding(.top, 5)
                        .padding([.leading, .trailing], 15)
                        .frame(maxWidth: .infinity, alignment: .leading) // left align
                
                    
                
                HStack {
                    TextField("Enter Income", text: $newIncomeAmount)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                    Button(action: submitIncome) {
                        Text("Submit")
                            .foregroundColor(Color(hex: buttonColorHex))
                    }
                    .padding()
                }
                
                Spacer()
                
                Text("Home Expenses")
                    .font(.title3)
                    .foregroundColor(Color(hex: textColorHex))
                
                ForEach(expenses) { expense in
                    Text("\(expense.name): $\(String(format: "%.2f", expense.amount))")
                        .font(.headline)
                        .foregroundColor(Color(hex: textColorHex))
                }
                
                HStack {
                    TextField("Expense Name", text: $newExpenseName)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Amount", text: $newExpenseAmount)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Button(action: addExpense) {
                        Text("Add")
                            .foregroundColor(Color(hex: buttonColorHex))
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Loans")
                    .font(.title3)
                    .foregroundColor(Color(hex: textColorHex))
                
                ForEach(loans) { loan in
                    Text("\(loan.name): $\(String(format: "%.2f", loan.amount))")
                        .font(.headline)
                        .foregroundColor(Color(hex: textColorHex))
                }
                
                HStack {
                    TextField("Loan Name", text: $newLoanName)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Amount", text: $newLoanAmount)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Button(action: addLoan) {
                        Text("Add")
                            .foregroundColor(Color(hex: buttonColorHex))
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Credit Card Payments")
                    .font(.title3)
                    .foregroundColor(Color(hex: textColorHex))
                
                ForEach(creditCardPayments) { payment in
                    Text("\(payment.name): $\(String(format: "%.2f", payment.amount))")
                        .font(.headline)
                        .foregroundColor(Color(hex: textColorHex))
                }
                
                HStack {
                    TextField("Payment Name", text: $newPaymentName)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Amount", text: $newPaymentAmount)
                        .foregroundColor(Color(hex: textColorHex))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    Button(action: addPayment) {
                        Text("Add")
                            .foregroundColor(Color(hex: buttonColorHex))
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Total: $\(String(format: "%.2f", totalAmount))")
                    .font(.title2)
                    .foregroundColor(Color(hex: textColorHex))
                
                Text("Remaining Income: $\(String(format: "%.2f", remainingIncome))")
                    .font(.title2)
                    .foregroundColor(Color(hex: textColorHex))
                
                Spacer()
            }
           // .navigationBarTitle("Money Management")
            .background(Color(hex: backgroundColorHex))
          // .multilineTextAlignment(.center)
            
        }
    }
    
    func submitIncome() {
        incomeAmount = newIncomeAmount
    }
    
    func addExpense() {
        guard let amount = Double(newExpenseAmount) else { return }
        expenses.append(ExpenseItem(name: newExpenseName, amount: amount))
        newExpenseName = ""
        newExpenseAmount = ""
    }
    
    func addLoan() {
        guard let amount = Double(newLoanAmount) else { return }
        loans.append(ExpenseItem(name: newLoanName, amount: amount))
        newLoanName = ""
        newLoanAmount = ""
    }
    
    func addPayment() {
        guard let amount = Double(newPaymentAmount) else { return }
        creditCardPayments.append(ExpenseItem(name: newPaymentName, amount: amount))
        newPaymentName = ""
        newPaymentAmount = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
