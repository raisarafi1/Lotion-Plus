# add your delete-note function here

import boto3


def handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = "lotion-30140980"
    table = dynamodb.Table(table_name)
    response = table.delete_item(
        Key={
            'email': 'partition_key_value',
            'note_id': 'sort_key_value'
        }
    )
    print(response)


