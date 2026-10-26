
import json
import logging
from datetime import datetime, timezone

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    execution_time = datetime.now(timezone.utc).isoformat()

    result = {
        "message": "Hello from Deepak!",
        "trigger": event.get("source", "manual"),
        "task": event.get("task", "test"),
        "execution_time_utc": execution_time
    }

    logger.info(json.dumps(result))

    return {
        "statusCode": 200,
        "body": json.dumps(result)
    }
