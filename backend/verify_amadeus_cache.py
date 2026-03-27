import os
import django
import sys

# Setup Django environment
sys.path.append(os.getcwd())
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from travel_data.services.amadeus_service import AmadeusService
from django.core.cache import cache

def test_token_caching():
    print("--- Testing Token Caching ---")
    service = AmadeusService()
    
    # Clear cache for clean test
    cache.delete(service.TOKEN_CACHE_KEY)
    
    print("First call (should fetch and cache):")
    token1 = service._get_token()
    if token1:
        print(f"Token 1 acquired: {token1[:10]}...")
    else:
        print("Failed to acquire token 1")
        return

    print("\nSecond call (should use cache):")
    token2 = service._get_token()
    if token2:
        print(f"Token 2 acquired: {token2[:10]}...")
    else:
        print("Failed to acquire token 2")
        return

    if token1 == token2:
        print("\nSUCCESS: Tokens match! Caching is working.")
    else:
        print("\nFAILURE: Tokens do not match. Caching failed.")

if __name__ == "__main__":
    test_token_caching()
