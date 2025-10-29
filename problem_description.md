# Store Rating Calculator

## Problem Description

You are building a rating aggregation system for stores. Given a list of ratings from different users for multiple stores, you need to implement a system that can:

1. Calculate the average rating for each store
2. Find the top N stores by rating
3. Filter stores by minimum rating threshold
4. Handle edge cases like stores with no ratings

## Difficulty Level
**Medium**

## Requirements

Implement a `StoreRatingCalculator` class with the following methods:

### 1. `calculate_average(store_id, ratings)`
- **Input**: 
  - `store_id` (Integer): The store identifier
  - `ratings` (Array of Hashes): Array of rating objects with keys `:store_id`, `:user_id`, `:rating`
- **Output**: Float (rounded to 2 decimal places) or `nil` if no ratings exist
- **Description**: Calculate the average rating for a specific store

### 2. `top_stores(ratings, n)`
- **Input**: 
  - `ratings` (Array of Hashes): Array of rating objects
  - `n` (Integer): Number of top stores to return
- **Output**: Array of Hashes with keys `:store_id` and `:average_rating`
- **Description**: Return the top N stores sorted by average rating (descending)

### 3. `filter_by_threshold(ratings, threshold)`
- **Input**: 
  - `ratings` (Array of Hashes): Array of rating objects
  - `threshold` (Float): Minimum rating threshold
- **Output**: Array of store IDs that meet or exceed the threshold
- **Description**: Return store IDs with average rating >= threshold

### 4. `rating_distribution(store_id, ratings)`
- **Input**: 
  - `store_id` (Integer): The store identifier
  - `ratings` (Array of Hashes): Array of rating objects
- **Output**: Hash with keys 1-5 representing rating counts
- **Description**: Return the distribution of ratings (1-5 stars) for a store

## Constraints
- Ratings are integers between 1 and 5 (inclusive)
- Store IDs and User IDs are positive integers
- Handle empty arrays gracefully
- Round averages to 2 decimal places

## Example

```ruby
calculator = StoreRatingCalculator.new

ratings = [
  { store_id: 1, user_id: 101, rating: 5 },
  { store_id: 1, user_id: 102, rating: 4 },
  { store_id: 2, user_id: 101, rating: 3 },
  { store_id: 2, user_id: 103, rating: 5 },
  { store_id: 3, user_id: 104, rating: 5 }
]

calculator.calculate_average(1, ratings)
# => 4.5

calculator.top_stores(ratings, 2)
# => [{ store_id: 3, average_rating: 5.0 }, { store_id: 1, average_rating: 4.5 }]

calculator.filter_by_threshold(ratings, 4.5)
# => [3, 1]

calculator.rating_distribution(1, ratings)
# => { 1 => 0, 2 => 0, 3 => 0, 4 => 1, 5 => 1 }
```

## Quality Criteria
- **Code Quality**: Clean, readable, and follows Ruby conventions
- **Edge Cases**: Handles empty inputs, missing data, and invalid inputs
- **Performance**: Efficient algorithms (avoid unnecessary iterations)
- **Testing**: Comprehensive unit tests covering all scenarios
