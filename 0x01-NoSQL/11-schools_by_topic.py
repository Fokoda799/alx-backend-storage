#!/usr/bin/env python3
""" Get a school by specific topic """


def schools_by_topic(mongo_collection, topic):
    """ Get a school by specific topic """
    return mongo_collection.find({'topics': topic})
