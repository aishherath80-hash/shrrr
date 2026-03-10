from pymongo import MongoClient
import os


class FeedingMongoDB:
    """
    Separate MongoDB connection for feeding data.

    This connects to the shrimp feeding database (shrimpfeeding) so that
    disease-detection can read/write aggregated feeding summaries while
    keeping environmental data on the IoT database.
    """

    _client = None
    _db = None

    @classmethod
    def connect(cls):
        """
        Establish connection to the shrimp feeding MongoDB.

        Connection parameters:
        - FEED_MONGO_URI: full MongoDB connection string
        - FEED_DB_NAME: database name (e.g. 'shrimpfeeding')
        """
        if cls._client is None:
            mongo_uri = os.getenv("FEED_MONGO_URI", "")
            db_name = os.getenv("FEED_DB_NAME", "")

            if not mongo_uri or not db_name:
                raise ValueError(
                    "FEED_MONGO_URI and FEED_DB_NAME environment variables are required "
                    "for accessing shrimp feeding database."
                )

            cls._client = MongoClient(mongo_uri)
            cls._db = cls._client[db_name]

        return cls._db

    @classmethod
    def get_db(cls):
        if cls._db is None:
            return cls.connect()
        return cls._db

