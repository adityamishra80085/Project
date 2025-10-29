# unit_tests.rb
# Comprehensive unit tests for StoreRatingCalculator

require 'minitest/autorun'
require_relative 'solution_code'

class StoreRatingCalculatorTest < Minitest::Test
  def setup
    @calculator = StoreRatingCalculator.new
    @sample_ratings = [
      { store_id: 1, user_id: 101, rating: 5 },
      { store_id: 1, user_id: 102, rating: 4 },
      { store_id: 1, user_id: 103, rating: 5 },
      { store_id: 2, user_id: 101, rating: 3 },
      { store_id: 2, user_id: 103, rating: 5 },
      { store_id: 2, user_id: 104, rating: 4 },
      { store_id: 3, user_id: 104, rating: 5 },
      { store_id: 3, user_id: 105, rating: 5 },
      { store_id: 4, user_id: 106, rating: 2 },
      { store_id: 4, user_id: 107, rating: 3 }
    ]
  end

  # Tests for calculate_average method
  def test_calculate_average_with_valid_store
    result = @calculator.calculate_average(1, @sample_ratings)
    assert_equal 4.67, result
  end

  def test_calculate_average_with_single_rating
    result = @calculator.calculate_average(3, @sample_ratings)
    assert_equal 5.0, result
  end

  def test_calculate_average_with_nonexistent_store
    result = @calculator.calculate_average(999, @sample_ratings)
    assert_nil result
  end

  def test_calculate_average_with_empty_ratings
    result = @calculator.calculate_average(1, [])
    assert_nil result
  end

  def test_calculate_average_with_nil_ratings
    result = @calculator.calculate_average(1, nil)
    assert_nil result
  end

  def test_calculate_average_rounds_to_two_decimals
    ratings = [
      { store_id: 5, user_id: 1, rating: 4 },
      { store_id: 5, user_id: 2, rating: 5 },
      { store_id: 5, user_id: 3, rating: 3 }
    ]
    result = @calculator.calculate_average(5, ratings)
    assert_equal 4.0, result
  end

  # Tests for top_stores method
  def test_top_stores_returns_correct_number
    result = @calculator.top_stores(@sample_ratings, 2)
    assert_equal 2, result.length
  end

  def test_top_stores_sorted_descending
    result = @calculator.top_stores(@sample_ratings, 3)
    assert_equal 3, result[0][:store_id]
    assert_equal 5.0, result[0][:average_rating]
    assert_equal 1, result[1][:store_id]
    assert_equal 4.67, result[1][:average_rating]
  end

  def test_top_stores_with_n_greater_than_available
    result = @calculator.top_stores(@sample_ratings, 100)
    assert_equal 4, result.length
  end

  def test_top_stores_with_empty_ratings
    result = @calculator.top_stores([], 5)
    assert_equal [], result
  end

  def test_top_stores_with_nil_ratings
    result = @calculator.top_stores(nil, 5)
    assert_equal [], result
  end

  def test_top_stores_with_zero_n
    result = @calculator.top_stores(@sample_ratings, 0)
    assert_equal [], result
  end

  def test_top_stores_with_negative_n
    result = @calculator.top_stores(@sample_ratings, -1)
    assert_equal [], result
  end

  def test_top_stores_structure
    result = @calculator.top_stores(@sample_ratings, 1)
    assert_instance_of Array, result
    assert_instance_of Hash, result[0]
    assert result[0].key?(:store_id)
    assert result[0].key?(:average_rating)
  end

  # Tests for filter_by_threshold method
  def test_filter_by_threshold_returns_matching_stores
    result = @calculator.filter_by_threshold(@sample_ratings, 4.5)
    assert_equal [1, 3], result
  end

  def test_filter_by_threshold_with_exact_match
    result = @calculator.filter_by_threshold(@sample_ratings, 4.0)
    assert_equal [1, 2, 3], result
  end

  def test_filter_by_threshold_with_high_threshold
    result = @calculator.filter_by_threshold(@sample_ratings, 5.0)
    assert_equal [3], result
  end

  def test_filter_by_threshold_with_low_threshold
    result = @calculator.filter_by_threshold(@sample_ratings, 1.0)
    assert_equal [1, 2, 3, 4], result
  end

  def test_filter_by_threshold_no_matches
    result = @calculator.filter_by_threshold(@sample_ratings, 6.0)
    assert_equal [], result
  end

  def test_filter_by_threshold_with_empty_ratings
    result = @calculator.filter_by_threshold([], 3.0)
    assert_equal [], result
  end

  def test_filter_by_threshold_with_nil_ratings
    result = @calculator.filter_by_threshold(nil, 3.0)
    assert_equal [], result
  end

  def test_filter_by_threshold_returns_sorted_ids
    result = @calculator.filter_by_threshold(@sample_ratings, 2.0)
    assert_equal result.sort, result
  end

  # Tests for rating_distribution method
  def test_rating_distribution_with_valid_store
    result = @calculator.rating_distribution(1, @sample_ratings)
    expected = { 1 => 0, 2 => 0, 3 => 0, 4 => 1, 5 => 2 }
    assert_equal expected, result
  end

  def test_rating_distribution_with_all_ratings
    result = @calculator.rating_distribution(2, @sample_ratings)
    expected = { 1 => 0, 2 => 0, 3 => 1, 4 => 1, 5 => 1 }
    assert_equal expected, result
  end

  def test_rating_distribution_with_nonexistent_store
    result = @calculator.rating_distribution(999, @sample_ratings)
    expected = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    assert_equal expected, result
  end

  def test_rating_distribution_with_empty_ratings
    result = @calculator.rating_distribution(1, [])
    expected = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    assert_equal expected, result
  end

  def test_rating_distribution_with_nil_ratings
    result = @calculator.rating_distribution(1, nil)
    expected = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    assert_equal expected, result
  end

  def test_rating_distribution_has_all_keys
    result = @calculator.rating_distribution(1, @sample_ratings)
    assert_equal [1, 2, 3, 4, 5], result.keys.sort
  end

  def test_rating_distribution_with_single_rating_type
    ratings = [
      { store_id: 10, user_id: 1, rating: 5 },
      { store_id: 10, user_id: 2, rating: 5 },
      { store_id: 10, user_id: 3, rating: 5 }
    ]
    result = @calculator.rating_distribution(10, ratings)
    expected = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 3 }
    assert_equal expected, result
  end

  # Integration tests
  def test_integration_complete_workflow
    ratings = [
      { store_id: 100, user_id: 1, rating: 5 },
      { store_id: 100, user_id: 2, rating: 4 },
      { store_id: 200, user_id: 3, rating: 3 },
      { store_id: 200, user_id: 4, rating: 2 }
    ]

    # Calculate average
    avg_100 = @calculator.calculate_average(100, ratings)
    assert_equal 4.5, avg_100

    # Get top stores
    top = @calculator.top_stores(ratings, 1)
    assert_equal 100, top[0][:store_id]

    # Filter by threshold
    filtered = @calculator.filter_by_threshold(ratings, 4.0)
    assert_equal [100], filtered

    # Get distribution
    dist = @calculator.rating_distribution(100, ratings)
    assert_equal 1, dist[4]
    assert_equal 1, dist[5]
  end

  def test_edge_case_single_store_single_rating
    ratings = [{ store_id: 1, user_id: 1, rating: 3 }]
    
    avg = @calculator.calculate_average(1, ratings)
    assert_equal 3.0, avg

    top = @calculator.top_stores(ratings, 1)
    assert_equal 1, top.length
    assert_equal 3.0, top[0][:average_rating]

    filtered = @calculator.filter_by_threshold(ratings, 3.0)
    assert_equal [1], filtered

    dist = @calculator.rating_distribution(1, ratings)
    assert_equal 1, dist[3]
  end

  def test_performance_with_large_dataset
    large_ratings = []
    1000.times do |i|
      large_ratings << { store_id: i % 100, user_id: i, rating: (i % 5) + 1 }
    end

    result = @calculator.top_stores(large_ratings, 10)
    assert_equal 10, result.length
    
    filtered = @calculator.filter_by_threshold(large_ratings, 3.0)
    assert_instance_of Array, filtered
  end
end
