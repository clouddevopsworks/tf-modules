#!/usr/bin/python3.6
import json
import os
import logging
import datetime as dt
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

# Microsoft Teams url webhook
HOOK_URL = os.environ['HOOK_URL']

# set logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    accountId = event['account']
    service = event['detail']['containers'][0]['name']
    time = event['time']
    event = event['detail']['lastStatus']


    # message information to display in Microsoft Teams
    teams_message = {
        "@context": "https://schema.org/extensions",
        "@type": "MessageCard",
        "themeColor": "64a837",
        "title": "AWS Container Service Notifications",
        "text": f"Docker Service Incident",
        "sections": [
            {
                "facts": [
                    {
                        "name": "Environment",
                        "value": os.environ['Environment']
                    },
                    {
                        "name": "AccountId",
                        "value": f"{accountId}"
                    },
                    {
                        "name": "service",
                        "value": f"{service}"
                    },
                                        {
                        "name": "Event-Time(UTC)",
                        "value": f"{time}"
                    },
                    {
                        "name": "Event",
                        "value": f"{event}"
                    }
                ]
            }
        ]
    }

    # request connection to Microsoft Teams
    request = Request(
        HOOK_URL,
        json.dumps(teams_message).encode('utf-8'))

    # post message to Microsoft Teams
    try:
        response = urlopen(request)
        response.read()
        logger.info("Message posted")
    except HTTPError as err:
        logger.error(f"Request failed: {err.code} {err.reason}")
    except URLError as err:
        logger.error(f"Server connection failed: {err.reason}")