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

    accountId = json.loads(event['Records'][0]['Sns']['Message'])['AWSAccountId']
    service = json.loads(event['Records'][0]['Sns']['Message'])['AlarmName']
    time = json.loads(event['Records'][0]['Sns']['Message'])['StateChangeTime']
    status = json.loads(event['Records'][0]['Sns']['Message'])['NewStateValue']
    reason = json.loads(event['Records'][0]['Sns']['Message'])['NewStateReason']
    
    # message information to display in Microsoft Teams
    teams_message = {
        "@context": "https://schema.org/extensions",
        "@type": "MessageCard",
        "themeColor": "64a837",
        "title": "AWS Container Performance Notifications",
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
                        "name": "Event-Time (UTC)",
                        "value": f"{time}"
                    },
                    {
                        "name": "Event",
                        "value": f"{status}"
                    },
                    {
                        "name": "Reason",
                        "value": f"{reason}"
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