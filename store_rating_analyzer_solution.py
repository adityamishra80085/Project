"""
Complete Solution for Store Rating Analyzer
This is the reference implementation with all methods fully implemented
"""

from datetime import datetime
from typing import List, Dict, Optional, Any
import math


class InvalidRatingError(Exception):
    """Raised when rating value is invalid"""
    pass


class DuplicateRatingError(Exception):
    """Raised when user tries to rate the same store twice"""
    pass


class StoreRatingAnalyzer:
    def __init__(self):
        self.ratings: List[Dict[str, Any]] = []
        self.stores: Dict[int, Dict[str, Any]] = {}

    def add_rating(
        self,
        user_id: int,
        store_id: int,
        store_name: str,
        rating: int,
        created_at: datetime
    ) -> Dict[str, Any]:
        """Add a new rating to the system"""
        self._validate_rating(rating)
        
        if self._duplicate_rating(user_id, store_id):
            raise DuplicateRatingError(
                f"User {user_id} has already rated store {store_id}"
            )
        
        if not store_name or len(store_name) < 1 or len(store_name) > 60:
            raise ValueError("Store name must be between 1 and 60 characters")
        
        if not created_at or not isinstance(created_at, datetime):
            raise ValueError("Invalid timestamp")
        
        rating_data = {
            'user_id': user_id,
            'store_id': store_id,
            'store_name': store_name,
            'rating': rating,
            'created_at': created_at
        }
        
        self.ratings.append(rating_data)
        
        if store_id not in self.stores:
            self.stores[store_id] = {'name': store_name, 'ratings': []}
        
        self.stores[store_id]['ratings'].append(rating_data)
        
        return rating_data

    def average_rating(self, store_id: int) -> Optional[float]:
        """Calculate the average rating for a specific store"""
        store_ratings = self.get_store_ratings(store_id)
        if not store_ratings:
            return None
        
        total = sum(r['rating'] for r in store_ratings)
        avg = total / len(store_ratings)
        return round(avg, 2)

    def median_rating(self, store_id: int) -> Optional[float]:
        """Calculate the median rating for a specific store"""
        store_ratings = self.get_store_ratings(store_id)
        if not store_ratings:
            return None
        
        sorted_ratings = sorted([r['rating'] for r in store_ratings])
        length = len(sorted_ratings)
        
        if length % 2 == 1:
            return float(sorted_ratings[length // 2])
        else:
            mid1 = sorted_ratings[length // 2 - 1]
            mid2 = sorted_ratings[length // 2]
            return (mid1 + mid2) / 2.0

    def rating_distribution(self, store_id: int) -> Dict[int, int]:
        """Get the distribution of ratings for a specific store"""
        distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
        
        store_ratings = self.get_store_ratings(store_id)
        for rating_data in store_ratings:
            distribution[rating_data['rating']] += 1
        
        return distribution

    def top_rated_stores(self, limit: int = 10) -> List[Dict[str, Any]]:
        """Get top rated stores sorted by average rating"""
        store_averages = []
        
        for store_id, store_data in self.stores.items():
            avg = self.average_rating(store_id)
            store_averages.append({
                'store_id': store_id,
                'name': store_data['name'],
                'avg_rating': avg
            })
        
        # Sort by average rating (descending), then by store_id for consistent ordering
        store_averages.sort(key=lambda s: (-s['avg_rating'], s['store_id']))
        return store_averages[:limit]

    def controversial_stores(self, threshold: float = 1.5) -> List[Dict[str, Any]]:
        """Find stores with controversial ratings (high variance)"""
        controversial = []
        
        for store_id, store_data in self.stores.items():
            ratings_values = [r['rating'] for r in store_data['ratings']]
            
            # Need at least 2 ratings for meaningful std dev
            if len(ratings_values) < 2:
                continue
            
            std_dev = self._calculate_standard_deviation(ratings_values)
            
            if std_dev > threshold:
                controversial.append({
                    'store_id': store_id,
                    'name': store_data['name'],
                    'std_dev': round(std_dev, 2),
                    'avg_rating': self.average_rating(store_id)
                })
        
        controversial.sort(key=lambda s: -s['std_dev'])
        return controversial

    def weighted_average(
        self,
        store_id: int,
        decay_days: int = 30
    ) -> Optional[float]:
        """Calculate weighted average with time decay"""
        store_ratings = self.get_store_ratings(store_id)
        if not store_ratings:
            return None
        
        current_time = datetime.now()
        weighted_sum = 0.0
        total_weight = 0.0
        
        for rating_data in store_ratings:
            days_old = (current_time - rating_data['created_at']).total_seconds() / 86400.0
            weight = math.exp(-days_old / decay_days)
            
            weighted_sum += rating_data['rating'] * weight
            total_weight += weight
        
        if total_weight == 0:
            return None
        
        return round(weighted_sum / total_weight, 2)

    def suspicious_ratings(self) -> List[Dict[str, Any]]:
        """Detect suspicious rating patterns"""
        suspicious = []
        
        # Check for duplicate attempts
        user_store_combinations = {}
        for rating in self.ratings:
            key = f"{rating['user_id']}_{rating['store_id']}"
            user_store_combinations[key] = user_store_combinations.get(key, 0) + 1
        
        for key, count in user_store_combinations.items():
            if count > 1:
                user_id, store_id = map(int, key.split('_'))
                suspicious.append({
                    'type': 'duplicate_rating',
                    'user_id': user_id,
                    'store_id': store_id,
                    'count': count
                })
        
        # Check for suspicious patterns: users who only give extreme ratings
        user_ratings = {}
        for rating in self.ratings:
            user_id = rating['user_id']
            if user_id not in user_ratings:
                user_ratings[user_id] = []
            user_ratings[user_id].append(rating['rating'])
        
        for user_id, ratings in user_ratings.items():
            # Need at least 3 ratings to detect pattern
            if len(ratings) < 3:
                continue
            
            if all(r == 5 for r in ratings):
                suspicious.append({
                    'type': 'all_five_stars',
                    'user_id': user_id,
                    'rating_count': len(ratings)
                })
            elif all(r == 1 for r in ratings):
                suspicious.append({
                    'type': 'all_one_stars',
                    'user_id': user_id,
                    'rating_count': len(ratings)
                })
        
        return suspicious

    def get_store_ratings(self, store_id: int) -> List[Dict[str, Any]]:
        """Get all ratings for a specific store"""
        if store_id not in self.stores:
            return []
        return self.stores[store_id]['ratings']

    def total_ratings(self) -> int:
        """Get total number of ratings in the system"""
        return len(self.ratings)

    def total_stores(self) -> int:
        """Get total number of stores in the system"""
        return len(self.stores)

    # Private helper methods

    def _calculate_standard_deviation(self, values: List[float]) -> float:
        """Helper method to calculate standard deviation"""
        if not values or len(values) == 1:
            return 0.0
        
        mean = sum(values) / len(values)
        variance = sum((v - mean) ** 2 for v in values) / len(values)
        return math.sqrt(variance)

    def _validate_rating(self, rating: int) -> bool:
        """Helper method to validate rating value"""
        if not isinstance(rating, int) or rating < 1 or rating > 5:
            raise InvalidRatingError(
                f"Rating must be an integer between 1 and 5, got: {rating}"
            )
        return True

    def _duplicate_rating(self, user_id: int, store_id: int) -> bool:
        """Helper method to check for duplicate ratings"""
        return any(
            r['user_id'] == user_id and r['store_id'] == store_id
            for r in self.ratings
        )


# Example usage demonstration
if __name__ == "__main__":
    analyzer = StoreRatingAnalyzer()
    
    # Add sample ratings
    analyzer.add_rating(
        user_id=1, store_id=1, store_name="Coffee Paradise",
        rating=5, created_at=datetime.now()
    )
    analyzer.add_rating(
        user_id=2, store_id=1, store_name="Coffee Paradise",
        rating=4, created_at=datetime.now()
    )
    analyzer.add_rating(
        user_id=3, store_id=1, store_name="Coffee Paradise",
        rating=5, created_at=datetime.now()
    )
    
    analyzer.add_rating(
        user_id=4, store_id=2, store_name="Pizza Heaven",
        rating=3, created_at=datetime.now()
    )
    analyzer.add_rating(
        user_id=5, store_id=2, store_name="Pizza Heaven",
        rating=5, created_at=datetime.now()
    )
    analyzer.add_rating(
        user_id=6, store_id=2, store_name="Pizza Heaven",
        rating=1, created_at=datetime.now()
    )
    
    # Display results
    print("=== Store Rating Analytics ===")
    print(f"\nTotal Ratings: {analyzer.total_ratings()}")
    print(f"Total Stores: {analyzer.total_stores()}")
    
    print("\n--- Coffee Paradise (Store 1) ---")
    print(f"Average Rating: {analyzer.average_rating(1)}")
    print(f"Median Rating: {analyzer.median_rating(1)}")
    print(f"Weighted Average: {analyzer.weighted_average(1, decay_days=30)}")
    print(f"Distribution: {analyzer.rating_distribution(1)}")
    
    print("\n--- Pizza Heaven (Store 2) ---")
    print(f"Average Rating: {analyzer.average_rating(2)}")
    print(f"Median Rating: {analyzer.median_rating(2)}")
    print(f"Distribution: {analyzer.rating_distribution(2)}")
    
    print("\n--- Top Rated Stores ---")
    for store in analyzer.top_rated_stores(limit=5):
        print(f"{store['name']} (ID: {store['store_id']}): {store['avg_rating']} stars")
    
    print("\n--- Controversial Stores ---")
    controversial = analyzer.controversial_stores()
    if not controversial:
        print("No controversial stores found")
    else:
        for store in controversial:
            print(f"{store['name']} (ID: {store['store_id']}): Std Dev = {store['std_dev']}")
    
    print("\n--- Suspicious Ratings ---")
    suspicious = analyzer.suspicious_ratings()
    if not suspicious:
        print("No suspicious patterns detected")
    else:
        for pattern in suspicious:
            print(f"Type: {pattern['type']}, Details: {pattern}")
