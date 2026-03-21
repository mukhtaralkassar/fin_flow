
/// Defines the main type of the transaction.
enum TransactionType {
  income,   // Money added to balance
  expense,  // Money spent
  debt,     // Money borrowed from someone (adds to balance, but is a liability)
  lent,     // Money given to someone (reduces balance, but is an asset)
}

/// Defines the category of an expense transaction for the swipe feature.
enum ExpenseCategory {
  none,           // For income, debt, and lent (not applicable)
  uncategorized,  // Needs to be swiped
  need,           // Swiped right
  want,           // Swiped left
}