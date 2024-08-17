#!/usr/bin/env python3
""" provides some stats about Nginx logs stored in MongoDB"""

from pymongo import MongoClient

def main():
    """ provides some stats about Nginx logs stored in MongoDB"""
    # Set up the connection to the MongoDB database
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx = client.logs.nginx

    # Get the number of documents in the collection
    num_docs = nginx.count_documents({})
    print("{} logs".format(num_docs))

    print("Methods:")

    # Get the number of documents with each method
    methods = ["GET", "POST", "PUT", "PATCH", "DELETE"]
    for method in methods:
        num_methods = nginx.count_documents({'method': method})
        print("\tmethod {}: {}".format(method, num_methods))

    # Get the number of documents with a path of /status
    num_docs = nginx.count_documents({'method': "GET", 'path': "/status"})
    print("{} status check".format(num_docs))
