# solution_code.rb
# This is the complete solution implementation

class StoreRatingCalculator
  # Calculate the average rating for a specific store
  # @param store_id [Integer] The store identifier
  # @param ratings [Array<Hash>] Array of rating objects with keys :store_id, :user_id, :rating
  # @return [Float, nil] Average rating rounded to 2 decimal places, or nil if no ratings
  def calculate_average(store_id, ratings)
    return nil if ratings.nil? || ratings.empty?

    store_ratings = ratings.select { |r| r[:store_id] == store_id }
    return nil if store_ratings.empty?

    sum = store_ratings.sum { |r| r[:rating] }
    average = sum.to_f / store_ratings.size
    average.round(2)
  end

  # Get the top N stores by average rating
  # @param ratings [Array<Hash>] Array of rating objects
  # @param n [Integer] Number of top stores to return
  # @return [Array<Hash>] Array of hashes with :store_id and :average_rating keys, sorted descending
  def top_stores(ratings, n)
    return [] if ratings.nil? || ratings.empty? || n <= 0

    # Group ratings by store_id
    store_averages = calculate_all_averages(ratings)

    # Sort by average rating (descending) and take top N
    store_averages
      .sort_by { |store| -store[:average_rating] }
      .take(n)
  end

  # Filter stores that meet or exceed a rating threshold
  # @param ratings [Array<Hash>] Array of rating objects
  # @param threshold [Float] Minimum rating threshold
  # @return [Array<Integer>] Array of store IDs that meet the threshold
  def filter_by_threshold(ratings, threshold)
    return [] if ratings.nil? || ratings.empty?

    store_averages = calculate_all_averages(ratings)

    store_averages
      .select { |store| store[:average_rating] >= threshold }
      .map { |store| store[:store_id] }
      .sort
  end

  # Get the distribution of ratings (1-5 stars) for a specific store
  # @param store_id [Integer] The store identifier
  # @param ratings [Array<Hash>] Array of rating objects
  # @return [Hash] Hash with keys 1-5 representing count of each rating
  def rating_distribution(store_id, ratings)
    distribution = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    
    return distribution if ratings.nil? || ratings.empty?

    store_ratings = ratings.select { |r| r[:store_id] == store_id }

    store_ratings.each do |rating|
      rating_value = rating[:rating]
      distribution[rating_value] += 1 if rating_value.between?(1, 5)
    end

    distribution
  end

  private

  # Helper method to calculate averages for all stores
  # @param ratings [Array<Hash>] Array of rating objects
  # @return [Array<Hash>] Array of hashes with :store_id and :average_rating
  def calculate_all_averages(ratings)
    # Group ratings by store_id
    grouped = ratings.group_by { |r| r[:store_id] }

    # Calculate average for each store
    grouped.map do |store_id, store_ratings|
      sum = store_ratings.sum { |r| r[:rating] }
      average = (sum.to_f / store_ratings.size).round(2)
      { store_id: store_id, average_rating: average }
    end
  end
end
