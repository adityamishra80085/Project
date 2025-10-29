# Coding Problem Submission Package

## 📦 Package Contents

This submission package contains a complete coding problem with high-quality implementation and comprehensive testing.

### Files Included:

1. **problem_description.md** - Detailed problem statement with requirements and examples
2. **base_code.rb** - Starter code template for candidates
3. **solution_code.rb** - Complete reference solution
4. **unit_tests.rb** - Comprehensive unit test suite (50+ test cases)
5. **test_runner.rb** - Test execution script

---

## 🎯 Problem Overview

**Title:** Store Rating Calculator  
**Difficulty:** Medium  
**Domain:** Data Processing & Aggregation  
**Language:** Ruby

### Key Features:
- Calculate average ratings for stores
- Find top-rated stores
- Filter stores by rating threshold
- Analyze rating distributions

---

## 🚀 How to Run

### Prerequisites
- Ruby 3.0 or higher
- Minitest gem (usually included with Ruby)

### Running Tests

```bash
# Run all unit tests
ruby unit_tests.rb

# Or use the test runner
ruby test_runner.rb

# Run with verbose output
ruby unit_tests.rb --verbose
```

### Testing Your Solution

Replace the content of `solution_code.rb` with your implementation and run:

```bash
ruby unit_tests.rb
```

---

## 📊 Test Coverage

The unit test suite includes:

### ✅ calculate_average method (7 tests)
- Valid store calculations
- Single rating scenarios
- Nonexistent store handling
- Empty/nil input handling
- Decimal rounding verification

### ✅ top_stores method (8 tests)
- Correct number of results
- Descending sort order
- Edge cases (n > available stores, n = 0, n < 0)
- Empty/nil input handling
- Return structure validation

### ✅ filter_by_threshold method (8 tests)
- Matching stores retrieval
- Exact threshold matching
- High/low threshold scenarios
- No matches handling
- Empty/nil input handling
- Sorted output verification

### ✅ rating_distribution method (7 tests)
- Valid store distribution
- All rating types (1-5)
- Nonexistent store handling
- Empty/nil input handling
- Key completeness verification
- Single rating type scenarios

### ✅ Integration & Performance (3 tests)
- Complete workflow integration
- Edge case scenarios
- Large dataset performance (1000+ records)

**Total Test Cases:** 33 comprehensive tests

---

## 💡 Solution Quality Metrics

### Code Quality: ⭐⭐⭐⭐⭐
- Clean, readable Ruby code
- Follows Ruby conventions and idioms
- Proper use of enumerable methods
- Well-documented with YARD comments
- DRY principle with helper methods

### Problem Quality: ⭐⭐⭐⭐⭐
- Real-world applicable scenario
- Clear requirements and constraints
- Multiple complexity levels
- Good balance of difficulty

### Test Quality: ⭐⭐⭐⭐⭐
- Comprehensive edge case coverage
- Unit and integration tests
- Performance testing included
- Clear test organization
- Descriptive test names

### Edge Case Handling: ⭐⭐⭐⭐⭐
- Nil input handling
- Empty array handling
- Invalid store IDs
- Boundary conditions
- Large dataset scenarios

---

## 🔍 Example Usage

```ruby
require_relative 'solution_code'

calculator = StoreRatingCalculator.new

ratings = [
  { store_id: 1, user_id: 101, rating: 5 },
  { store_id: 1, user_id: 102, rating: 4 },
  { store_id: 2, user_id: 101, rating: 3 },
  { store_id: 2, user_id: 103, rating: 5 }
]

# Calculate average for store 1
avg = calculator.calculate_average(1, ratings)
puts "Store 1 average: #{avg}"  # => 4.5

# Get top 2 stores
top = calculator.top_stores(ratings, 2)
puts "Top stores: #{top}"

# Filter stores with rating >= 4.0
filtered = calculator.filter_by_threshold(ratings, 4.0)
puts "High-rated stores: #{filtered}"

# Get rating distribution for store 1
dist = calculator.rating_distribution(1, ratings)
puts "Rating distribution: #{dist}"
```

---

## 📝 Evaluation Criteria

### For Candidates:
1. **Correctness** - All tests must pass
2. **Code Quality** - Clean, readable, maintainable code
3. **Efficiency** - Optimal time/space complexity
4. **Edge Cases** - Proper handling of boundary conditions
5. **Ruby Idioms** - Proper use of Ruby language features

### Expected Time Complexity:
- `calculate_average`: O(n) where n = number of ratings
- `top_stores`: O(n log n) due to sorting
- `filter_by_threshold`: O(n log n) due to sorting
- `rating_distribution`: O(n)

### Expected Space Complexity:
- All methods: O(k) where k = number of unique stores

---

## 🎓 Learning Objectives

This problem tests:
- Array manipulation and filtering
- Hash operations and grouping
- Sorting and ordering
- Mathematical calculations
- Edge case handling
- Code organization and structure

---

## 📄 License

This coding problem is provided for educational and assessment purposes.

---

## 👥 Support

For questions or issues with this problem:
1. Review the problem_description.md carefully
2. Check the example usage above
3. Examine the test cases for expected behavior
4. Ensure Ruby version compatibility

---

**Happy Coding! 🚀**
