#!/usr/bin/env python3
"""
a simple module to practise projects on how to use redis
for caching and to redis client in python
"""
from redis import Redis
import uuid as uid
from typing import Union, Callable, Optional
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """
    This is a decorator funct that takes a callable and returns a Callable
    """
    key = method.__qualname__

    @wraps(method)
    def incr_func(self, *args, **kwargs):
        """increments the count for the key """
        self._redis.incr(key)
        return method(self, *args, **kwargs)
    return incr_func


def call_history(method: Callable) -> Callable:
    """
    a method that tracks the call details of a method in Cache class
    """
    @wraps(method)
    def setter(self, *args, **kwargs) -> any:
        """
         method returns the method's output after storing its
        inputs and output.
        """
        in_key = '{}:inputs'.format(method.__qualname__)
        out_key = '{}:outputs'.format(method.__qualname__)
        if isinstance(self._redis, Redis):
            self._redis.rpush(in_key, str(args))
        output = method(self, *args, **kwargs)
        if isinstance(self._redis, Redis):
            self._redis.rpush(out_key, output)
        return output
    return setter


def replay(fn: Callable):
    """
    This is a method that replays a function a bunch of times

    Args:
        fn (Callable): The callback function
    """
    cache_mem = Redis()
    func_name_qual = fn.__qualname__
    value = int(cache_mem.get(func_name_qual) or b"0")
    print(f"{func_name_qual} was called {value} times:")
    inputs = cache_mem.lrange(f"{func_name_qual}:inputs", 0, -1)
    outputs = cache_mem.lrange(f"{func_name_qual}:outputs", 0, -1)

    for input_bytes, output_bytes in zip(inputs, outputs):
        input_string = input_bytes.decode("utf-8")
        output_string = output_bytes.decode("utf-8")
        print(f"{func_name_qual}(*{input_string}) -> {output_string}")


class Cache:
    """
    This is a class to implement caching using redis
    """
    def __init__(self):
        """Class constructor for Cache"""
        self._redis = Redis()
        self._redis.flushdb(True)

    @call_history
    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        This is a method that stores data using a random key generated
        from the uuid library:

        Args:
            data (str | bytes | int | float) - input data to be written
            to the redis database

        Returns:
            String (str) result
        """
        u_id = str(uid.uuid4())
        self._redis.set(u_id, data)
        return u_id

    def get(self, key: str, fn: Callable = None) \
            -> Union[str, bytes, int, float]:
        """
        "This method retrieves data from Redis and converts it to Py data type

    Args:
        key (str): The key of the data to fetch from Redis.
        fn (Callable): The function to apply to the retrieved data.

    Returns:
        str | float | int | bytes: The data converted to the specified Python
        result = self._redis.get(key)
        if fn:
            return fn(result)
        return result

    def get_str(self, key: str) -> str:
        """
        This is a method that retrieves string data from the redis storage

        Args:
            key (str) - the key of the data to fetch

        Returns:
            String data (str)
        """
        return self.get(key, lambda x: x.decode('utf-8'))

    def get_int(self, key: str) -> int:
        """
        This is a method that retrieves integer data from the redis storage

        Args:
            key (str) - the key of the data to fetch

        Returns:
            Integer data (int)
        """
        return self.get(key, lambda x: int(x))
