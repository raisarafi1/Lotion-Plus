import boto3
import json

# create a DynamoDB resource
dynamodb = boto3.resource("dynamodb")
table_name = "lotion-30140980"
table = dynamodb.Table(table_name)

def handler(event, context):
    email = event["queryStringParameters"]["email"]
    access_token = event["headers"]["access_token"]

    # TODO: Add authentication and authorization code using access_token

    # retrieve all the notes for the user
    response = table.query(
        IndexName="email-index",
        KeyConditionExpression="email = :email",
        ExpressionAttributeValues={":email": email}
    )

    # format the notes into a list
    notes = []
    for item in response["Items"]:
        notes.append(item["note"])

    return {
        "statusCode": 200,
        "body": json.dumps({
            "notes": notes
        })
    }