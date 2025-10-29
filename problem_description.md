# Problem: Store Rating Calculator with Advanced Analytics

## Difficulty Level
**Medium** (Requires understanding of Ruby classes, data structures, algorithms, and edge case handling)

## Problem Statement

You are building an analytics system for a store rating platform. The system needs to calculate various statistics about store ratings, handle edge cases gracefully, and provide insights for business intelligence.

Implement a `StoreRatingAnalyzer` class that processes rating data and provides the following functionality:

### Requirements

1. **Calculate Average Rating** - Compute the mean rating for a store
2. **Calculate Median Rating** - Find the middle value in the rating distribution
3. **Calculate Rating Distribution** - Return a hash showing count of each rating (1-5)
4. **Find Top Rated Stores** - Return stores sorted by average rating (descending)
5. **Identify Controversial Stores** - Find stores with high variance in ratings (standard deviation > 1.5)
6. **Calculate Weighted Rating** - Apply time-based weighting (recent ratings count more)
7. **Detect Suspicious Patterns** - Identify potential fake ratings (same user rating multiple times, unusual patterns)

### Input Specifications

- Ratings are integers between 1 and 5 (inclusive)
- Each rating has: `user_id`, `store_id`, `rating`, `created_at` (timestamp)
- Store names are strings (1-60 characters)
- Handle empty datasets gracefully

### Output Specifications

- Average ratings should be rounded to 2 decimal places
- Return `nil` or appropriate default values for empty datasets
- Raise custom exceptions for invalid inputs
- All methods should be efficient (consider O(n) complexity where possible)

### Edge Cases to Handle

1. Empty rating lists
2. Single rating
3. All ratings are the same
4. Invalid rating values (< 1 or > 5)
5. Duplicate ratings from same user for same store
6. Missing or nil timestamps
7. Invalid store or user IDs

## Constraints

- 1 ≤ number of ratings ≤ 10,000
- 1 ≤ rating value ≤ 5
- Store names: 1-60 characters
- Timestamps: valid Ruby Time objects
- User IDs and Store IDs: positive integers

## Example

```ruby
analyzer = StoreRatingAnalyzer.new

# Add ratings
analyzer.add_rating(user_id: 1, store_id: 1, store_name: "Coffee Shop", rating: 5, created_at: Time.now - 86400)
analyzer.add_rating(user_id: 2, store_id: 1, store_name: "Coffee Shop", rating: 4, created_at: Time.now - 43200)
analyzer.add_rating(user_id: 3, store_id: 1, store_name: "Coffee Shop", rating: 5, created_at: Time.now)

# Calculate statistics
analyzer.average_rating(store_id: 1) # => 4.67
analyzer.median_rating(store_id: 1) # => 5.0
analyzer.rating_distribution(store_id: 1) # => {1=>0, 2=>0, 3=>0, 4=>1, 5=>2}
analyzer.top_rated_stores(limit: 5) # => [{store_id: 1, name: "Coffee Shop", avg_rating: 4.67}]
analyzer.controversial_stores # => []
analyzer.weighted_average(store_id: 1, decay_days: 30) # => 4.75 (recent ratings weighted more)
analyzer.suspicious_ratings # => []
```

## Evaluation Criteria

### Problem Description Quality (Weight: 25%)
- ✅ Clear and comprehensive problem statement
- ✅ Well-defined input/output specifications
- ✅ Realistic business context
- ✅ Multiple complexity levels (basic to advanced methods)

### Solution Quality (Weight: 40%)
- ✅ Clean, readable, and idiomatic Ruby code
- ✅ Proper error handling and validation
- ✅ Efficient algorithms (appropriate time/space complexity)
- ✅ Good separation of concerns
- ✅ Follows Ruby best practices and conventions
- ✅ Comprehensive edge case handling

### Unit Test Quality (Weight: 35%)
- ✅ Comprehensive test coverage (>90%)
- ✅ Tests for all edge cases
- ✅ Clear test descriptions
- ✅ Proper use of test fixtures and setup
- ✅ Tests for both success and failure scenarios
- ✅ Performance tests for large datasets

## Bonus Challenges

1. Implement caching for expensive calculations
2. Add support for weighted ratings based on user reputation
3. Implement trend analysis (rating changes over time)
4. Add support for filtering by date ranges
