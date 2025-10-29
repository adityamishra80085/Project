# Base Code Template for Store Rating Analyzer
# Students should implement the methods marked with TODO

class InvalidRatingError < StandardError; end
class DuplicateRatingError < StandardError; end

class StoreRatingAnalyzer
  def initialize
    @ratings = []
    @stores = {}
  end

  # Add a new rating to the system
  # @param user_id [Integer] The ID of the user submitting the rating
  # @param store_id [Integer] The ID of the store being rated
  # @param store_name [String] The name of the store
  # @param rating [Integer] The rating value (1-5)
  # @param created_at [Time] The timestamp when the rating was created
  # @raise [InvalidRatingError] if rating is not between 1 and 5
  # @raise [DuplicateRatingError] if user already rated this store
  def add_rating(user_id:, store_id:, store_name:, rating:, created_at:)
    # TODO: Implement validation and add rating to the system
    # - Validate rating is between 1 and 5
    # - Check for duplicate ratings (same user_id and store_id)
    # - Store the rating data
    # - Update store information
  end

  # Calculate the average rating for a specific store
  # @param store_id [Integer] The ID of the store
  # @return [Float, nil] The average rating rounded to 2 decimal places, or nil if no ratings
  def average_rating(store_id:)
    # TODO: Implement average calculation
    # - Return nil if no ratings exist for the store
    # - Calculate mean of all ratings
    # - Round to 2 decimal places
  end

  # Calculate the median rating for a specific store
  # @param store_id [Integer] The ID of the store
  # @return [Float, nil] The median rating, or nil if no ratings
  def median_rating(store_id:)
    # TODO: Implement median calculation
    # - Return nil if no ratings exist
    # - Sort ratings and find middle value
    # - For even number of ratings, return average of two middle values
  end

  # Get the distribution of ratings for a specific store
  # @param store_id [Integer] The ID of the store
  # @return [Hash] A hash with keys 1-5 and counts as values
  def rating_distribution(store_id:)
    # TODO: Implement rating distribution
    # - Return hash with all ratings 1-5 as keys
    # - Count occurrences of each rating
    # - Include 0 for ratings that don't exist
  end

  # Get top rated stores sorted by average rating
  # @param limit [Integer] Maximum number of stores to return
  # @return [Array<Hash>] Array of hashes with store_id, name, and avg_rating
  def top_rated_stores(limit: 10)
    # TODO: Implement top rated stores
    # - Calculate average for each store
    # - Sort by average rating (descending)
    # - Return top N stores with their details
    # - Handle ties appropriately
  end

  # Find stores with controversial ratings (high variance)
  # @param threshold [Float] Standard deviation threshold (default: 1.5)
  # @return [Array<Hash>] Array of stores with high rating variance
  def controversial_stores(threshold: 1.5)
    # TODO: Implement controversial store detection
    # - Calculate standard deviation for each store
    # - Return stores where std dev > threshold
    # - Include store details and std dev value
  end

  # Calculate weighted average with time decay
  # @param store_id [Integer] The ID of the store
  # @param decay_days [Integer] Number of days for full decay (default: 30)
  # @return [Float, nil] Weighted average rating, or nil if no ratings
  def weighted_average(store_id:, decay_days: 30)
    # TODO: Implement weighted average with time decay
    # - Recent ratings should have more weight
    # - Use exponential decay based on age
    # - Formula: weight = e^(-days_old / decay_days)
  end

  # Detect suspicious rating patterns
  # @return [Array<Hash>] Array of suspicious patterns found
  def suspicious_ratings
    # TODO: Implement suspicious pattern detection
    # - Detect duplicate ratings (same user, same store)
    # - Detect unusual patterns (e.g., all 5-star or all 1-star from new users)
    # - Return details about suspicious activities
  end

  # Get all ratings for a specific store
  # @param store_id [Integer] The ID of the store
  # @return [Array<Hash>] Array of rating hashes
  def get_store_ratings(store_id:)
    # TODO: Implement getter for store ratings
    # - Return all ratings for the specified store
    # - Return empty array if store has no ratings
  end

  # Get total number of ratings in the system
  # @return [Integer] Total count of ratings
  def total_ratings
    # TODO: Implement total ratings count
  end

  # Get total number of stores in the system
  # @return [Integer] Total count of stores
  def total_stores
    # TODO: Implement total stores count
  end

  private

  # Helper method to calculate standard deviation
  # @param values [Array<Numeric>] Array of numeric values
  # @return [Float] Standard deviation
  def calculate_standard_deviation(values)
    # TODO: Implement standard deviation calculation
    # - Return 0 if values is empty or has only one element
    # - Calculate using the formula: sqrt(sum((x - mean)^2) / n)
  end

  # Helper method to validate rating value
  # @param rating [Integer] The rating to validate
  # @return [Boolean] true if valid
  # @raise [InvalidRatingError] if invalid
  def validate_rating(rating)
    # TODO: Implement rating validation
    # - Check if rating is between 1 and 5
    # - Raise InvalidRatingError if not valid
  end

  # Helper method to check for duplicate ratings
  # @param user_id [Integer] The user ID
  # @param store_id [Integer] The store ID
  # @return [Boolean] true if duplicate exists
  def duplicate_rating?(user_id:, store_id:)
    # TODO: Implement duplicate check
    # - Check if user has already rated this store
  end
end
