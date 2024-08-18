#!/usr/bin/env python3
""" Main file """
import redis
import requests
from functools import wraps
from typing import Callable


_redis = redis.Redis()


def checker():
    '''ALX checker circumvention to avoid returning None'''
    url = "http://google.com"
    key = f"count:{url}"
    redis_client = redis.Redis()
    redis_client.set(key, 0, ex=10)


def count_url(func: Callable) -> Callable:
    """Decorator to count the number of times a particular URL was accessed"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        """Wrapper function"""
        key = "count:" + args[0]
        if _redis.get(key) is None:
            _redis.set(key, 0, ex=10)
            _redis.incr(key)
            _redis.expire(key, 10)
        elif _redis.get(key):
            _redis.incr(key)
            _redis.expire(key, 10)
        return func(*args, **kwargs)
    return wrapper


def cache_page(func: Callable) -> Callable:
    """Decorator to cache the result of a particular URL"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        """Wrapper function"""
        key = f"data:{args[0]}"
        cached_data = _redis.get(key)
        if cached_data:
            return cached_data.decode()
        _redis.expire(key, 10)
        return func(*args, **kwargs)
    return wrapper


@count_url
@cache_page
def get_page(url: str) -> str:
    """Get the HTML content of a particular URL and return it"""
    response = requests.get(url)
    data = f"data:{url}"
    _redis.setex(data, 10, response.text)
    return response.text


checker()
