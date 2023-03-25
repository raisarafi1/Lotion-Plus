# add your save-note function here

import boto3
import json




dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('lotion-30140980')


def handler(event, context):
    if "httpMethod" not in event:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "httpMethod not specified in request"})
        }
    http_method = event["httpMethod"]
    email = event["headers"]["email"]
    access_token = event["headers"]["access_token"]


    if http_method == "POST":
        # Parse request body to get note data
        note_data = json.loads(event["body"])
        # Add email to note data
        note_data["email"] = email
        # Write note to DynamoDB
        table.put_item(Item=note_data)
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Note saved successfully"})
        }
    else:
        return {
            "statusCode": 405,
            "body": json.dumps({"message": "Method not allowed"})
        }
