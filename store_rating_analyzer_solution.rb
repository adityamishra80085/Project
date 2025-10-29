# Complete Solution for Store Rating Analyzer
# This is the reference implementation with all methods fully implemented

class InvalidRatingError < StandardError; end
class DuplicateRatingError < StandardError; end

class StoreRatingAnalyzer
  def initialize
    @ratings = []
    @stores = {}
  end

  # Add a new rating to the system
  def add_rating(user_id:, store_id:, store_name:, rating:, created_at:)
    validate_rating(rating)
    
    raise DuplicateRatingError, "User #{user_id} has already rated store #{store_id}" if duplicate_rating?(user_id: user_id, store_id: store_id)
    
    raise ArgumentError, "Store name must be between 1 and 60 characters" if store_name.nil? || store_name.length < 1 || store_name.length > 60
    
    raise ArgumentError, "Invalid timestamp" if created_at.nil? || !created_at.is_a?(Time)
    
    rating_data = {
      user_id: user_id,
      store_id: store_id,
      store_name: store_name,
      rating: rating,
      created_at: created_at
    }
    
    @ratings << rating_data
    @stores[store_id] ||= { name: store_name, ratings: [] }
    @stores[store_id][:ratings] << rating_data
    
    rating_data
  end

  # Calculate the average rating for a specific store
  def average_rating(store_id:)
    store_ratings = get_store_ratings(store_id: store_id)
    return nil if store_ratings.empty?
    
    sum = store_ratings.sum { |r| r[:rating] }
    avg = sum.to_f / store_ratings.length
    avg.round(2)
  end

  # Calculate the median rating for a specific store
  def median_rating(store_id:)
    store_ratings = get_store_ratings(store_id: store_id)
    return nil if store_ratings.empty?
    
    sorted_ratings = store_ratings.map { |r| r[:rating] }.sort
    length = sorted_ratings.length
    
    if length.odd?
      sorted_ratings[length / 2].to_f
    else
      (sorted_ratings[length / 2 - 1] + sorted_ratings[length / 2]) / 2.0
    end
  end

  # Get the distribution of ratings for a specific store
  def rating_distribution(store_id:)
    distribution = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    
    store_ratings = get_store_ratings(store_id: store_id)
    store_ratings.each do |rating_data|
      distribution[rating_data[:rating]] += 1
    end
    
    distribution
  end

  # Get top rated stores sorted by average rating
  def top_rated_stores(limit: 10)
    store_averages = @stores.map do |store_id, store_data|
      avg = average_rating(store_id: store_id)
      {
        store_id: store_id,
        name: store_data[:name],
        avg_rating: avg
      }
    end
    
    # Sort by average rating (descending), then by store_id for consistent ordering
    store_averages.sort_by { |s| [-s[:avg_rating], s[:store_id]] }.first(limit)
  end

  # Find stores with controversial ratings (high variance)
  def controversial_stores(threshold: 1.5)
    controversial = []
    
    @stores.each do |store_id, store_data|
      ratings_values = store_data[:ratings].map { |r| r[:rating] }
      next if ratings_values.length < 2 # Need at least 2 ratings for meaningful std dev
      
      std_dev = calculate_standard_deviation(ratings_values)
      
      if std_dev > threshold
        controversial << {
          store_id: store_id,
          name: store_data[:name],
          std_dev: std_dev.round(2),
          avg_rating: average_rating(store_id: store_id)
        }
      end
    end
    
    controversial.sort_by { |s| -s[:std_dev] }
  end

  # Calculate weighted average with time decay
  def weighted_average(store_id:, decay_days: 30)
    store_ratings = get_store_ratings(store_id: store_id)
    return nil if store_ratings.empty?
    
    current_time = Time.now
    weighted_sum = 0.0
    total_weight = 0.0
    
    store_ratings.each do |rating_data|
      days_old = (current_time - rating_data[:created_at]) / 86400.0 # Convert seconds to days
      weight = Math.exp(-days_old / decay_days)
      
      weighted_sum += rating_data[:rating] * weight
      total_weight += weight
    end
    
    return nil if total_weight.zero?
    
    (weighted_sum / total_weight).round(2)
  end

  # Detect suspicious rating patterns
  def suspicious_ratings
    suspicious = []
    
    # Check for duplicate attempts (this shouldn't happen if add_rating works correctly)
    user_store_combinations = {}
    @ratings.each do |rating|
      key = "#{rating[:user_id]}_#{rating[:store_id]}"
      user_store_combinations[key] ||= 0
      user_store_combinations[key] += 1
    end
    
    user_store_combinations.each do |key, count|
      if count > 1
        user_id, store_id = key.split('_').map(&:to_i)
        suspicious << {
          type: 'duplicate_rating',
          user_id: user_id,
          store_id: store_id,
          count: count
        }
      end
    end
    
    # Check for suspicious patterns: users who only give extreme ratings (all 1s or all 5s)
    user_ratings = {}
    @ratings.each do |rating|
      user_ratings[rating[:user_id]] ||= []
      user_ratings[rating[:user_id]] << rating[:rating]
    end
    
    user_ratings.each do |user_id, ratings|
      next if ratings.length < 3 # Need at least 3 ratings to detect pattern
      
      if ratings.all? { |r| r == 5 }
        suspicious << {
          type: 'all_five_stars',
          user_id: user_id,
          rating_count: ratings.length
        }
      elsif ratings.all? { |r| r == 1 }
        suspicious << {
          type: 'all_one_stars',
          user_id: user_id,
          rating_count: ratings.length
        }
      end
    end
    
    suspicious
  end

  # Get all ratings for a specific store
  def get_store_ratings(store_id:)
    return [] unless @stores[store_id]
    @stores[store_id][:ratings]
  end

  # Get total number of ratings in the system
  def total_ratings
    @ratings.length
  end

  # Get total number of stores in the system
  def total_stores
    @stores.length
  end

  private

  # Helper method to calculate standard deviation
  def calculate_standard_deviation(values)
    return 0.0 if values.empty? || values.length == 1
    
    mean = values.sum.to_f / values.length
    variance = values.sum { |v| (v - mean) ** 2 } / values.length
    Math.sqrt(variance)
  end

  # Helper method to validate rating value
  def validate_rating(rating)
    unless rating.is_a?(Integer) && rating >= 1 && rating <= 5
      raise InvalidRatingError, "Rating must be an integer between 1 and 5, got: #{rating}"
    end
    true
  end

  # Helper method to check for duplicate ratings
  def duplicate_rating?(user_id:, store_id:)
    @ratings.any? { |r| r[:user_id] == user_id && r[:store_id] == store_id }
  end
end

# Example usage demonstration
if __FILE__ == $PROGRAM_NAME
  analyzer = StoreRatingAnalyzer.new
  
  # Add sample ratings
  analyzer.add_rating(user_id: 1, store_id: 1, store_name: "Coffee Paradise", rating: 5, created_at: Time.now - 86400)
  analyzer.add_rating(user_id: 2, store_id: 1, store_name: "Coffee Paradise", rating: 4, created_at: Time.now - 43200)
  analyzer.add_rating(user_id: 3, store_id: 1, store_name: "Coffee Paradise", rating: 5, created_at: Time.now)
  
  analyzer.add_rating(user_id: 4, store_id: 2, store_name: "Pizza Heaven", rating: 3, created_at: Time.now - 172800)
  analyzer.add_rating(user_id: 5, store_id: 2, store_name: "Pizza Heaven", rating: 5, created_at: Time.now - 86400)
  analyzer.add_rating(user_id: 6, store_id: 2, store_name: "Pizza Heaven", rating: 1, created_at: Time.now)
  
  # Display results
  puts "=== Store Rating Analytics ==="
  puts "\nTotal Ratings: #{analyzer.total_ratings}"
  puts "Total Stores: #{analyzer.total_stores}"
  
  puts "\n--- Coffee Paradise (Store 1) ---"
  puts "Average Rating: #{analyzer.average_rating(store_id: 1)}"
  puts "Median Rating: #{analyzer.median_rating(store_id: 1)}"
  puts "Weighted Average: #{analyzer.weighted_average(store_id: 1, decay_days: 30)}"
  puts "Distribution: #{analyzer.rating_distribution(store_id: 1)}"
  
  puts "\n--- Pizza Heaven (Store 2) ---"
  puts "Average Rating: #{analyzer.average_rating(store_id: 2)}"
  puts "Median Rating: #{analyzer.median_rating(store_id: 2)}"
  puts "Distribution: #{analyzer.rating_distribution(store_id: 2)}"
  
  puts "\n--- Top Rated Stores ---"
  analyzer.top_rated_stores(limit: 5).each do |store|
    puts "#{store[:name]} (ID: #{store[:store_id]}): #{store[:avg_rating]} stars"
  end
  
  puts "\n--- Controversial Stores ---"
  controversial = analyzer.controversial_stores
  if controversial.empty?
    puts "No controversial stores found"
  else
    controversial.each do |store|
      puts "#{store[:name]} (ID: #{store[:store_id]}): Std Dev = #{store[:std_dev]}"
    end
  end
  
  puts "\n--- Suspicious Ratings ---"
  suspicious = analyzer.suspicious_ratings
  if suspicious.empty?
    puts "No suspicious patterns detected"
  else
    suspicious.each do |pattern|
      puts "Type: #{pattern[:type]}, Details: #{pattern}"
    end
  end
end
