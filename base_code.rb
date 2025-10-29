# base_code.rb
# This is the starter code provided to candidates

class StoreRatingCalculator
  # Calculate the average rating for a specific store
  # @param store_id [Integer] The store identifier
  # @param ratings [Array<Hash>] Array of rating objects with keys :store_id, :user_id, :rating
  # @return [Float, nil] Average rating rounded to 2 decimal places, or nil if no ratings
  def calculate_average(store_id, ratings)
    # TODO: Implement this method
    raise NotImplementedError, "Method 'calculate_average' not implemented"
  end

  # Get the top N stores by average rating
  # @param ratings [Array<Hash>] Array of rating objects
  # @param n [Integer] Number of top stores to return
  # @return [Array<Hash>] Array of hashes with :store_id and :average_rating keys, sorted descending
  def top_stores(ratings, n)
    # TODO: Implement this method
    raise NotImplementedError, "Method 'top_stores' not implemented"
  end

  # Filter stores that meet or exceed a rating threshold
  # @param ratings [Array<Hash>] Array of rating objects
  # @param threshold [Float] Minimum rating threshold
  # @return [Array<Integer>] Array of store IDs that meet the threshold
  def filter_by_threshold(ratings, threshold)
    # TODO: Implement this method
    raise NotImplementedError, "Method 'filter_by_threshold' not implemented"
  end

  # Get the distribution of ratings (1-5 stars) for a specific store
  # @param store_id [Integer] The store identifier
  # @param ratings [Array<Hash>] Array of rating objects
  # @return [Hash] Hash with keys 1-5 representing count of each rating
  def rating_distribution(store_id, ratings)
    # TODO: Implement this method
    raise NotImplementedError, "Method 'rating_distribution' not implemented"
  end
end
