#!/usr/bin/env python
""" Writing strings to Redis """

import redis
from uuid import uuid4
from typing import Union, Callable, Optional
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """ Count Cache calls """
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """ Wrapper """
        key: str = method.__qualname__
        self._redis.incr(key)
        return method(self, *args, **kwargs)
    
    return wrapper


def call_history(method: Callable) -> Callable:
    """ Store history of inputs and outputs """
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """ Wrapper """
        self._redis.rpush(method.__qualname__ + ":inputs", str(args))
        output: str = str(method(self, *args, **kwargs))
        self._redis.rpush(method.__qualname__ + ":outputs", output)

        return output
    return wrapper


class Cache:
    """ Redis Cache class """

    def __init__(self) -> None:
        """ Constructor """
        self._redis = redis.Redis(host='localhost', port=6379, db=0)
        self._redis.flushdb()

    @call_history
    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """ Store data in Redis """
        key: str = str(uuid4())
        self._redis.set(key, data)
        return key
    
    def get(self, key: str, fn: Optional[Callable] = None) -> Union[str, bytes, int, float]:
        """ Get data from Redis """
        data: bytes = self._redis.get(key)
        if data is None:
            return None
        
        if fn:
            return fn(data)
        
        try:
            return int(data)
        except ValueError:
            try:
                return float(data)
            except ValueError:
                return data.decode('utf-8')  # Decode bytes to string if applicable
            

def replay(method: Callable):
    """Display the history of calls of a particular function

    Args:
        method (Callable): Method to display history
    """
    r = redis.Redis()
    key = method.__qualname__
    count = r.get(key).decode('utf-8')
    inputs = r.lrange(key + ":inputs", 0, -1)
    outputs = r.lrange(key + ":outputs", 0, -1)
    print("{} was called {} times:".format(key, count))
    for inp, outp in zip(inputs, outputs):
        print("{}(*{}) -> {}".format(key, inp.decode('utf-8'),
                                     outp.decode('utf-8')))
