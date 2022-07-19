import boto3
from botocore.exceptions import ClientError
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# define boto3 clients
asg_client = boto3.client('autoscaling')
ssm_client = boto3.client('ssm')
asg_name = ssm_client.get_parameter(Name='/dev/asg_refresh/asg_name', WithDecryption=False)
strategy = ssm_client.get_parameter(Name='/dev/asg_refresh/strategy', WithDecryption=False)
min_healthy_percentage = ssm_client.get_parameter(Name='/dev/asg_refresh/min_healthy_percentage', WithDecryption=False)
instance_warmup = ssm_client.get_parameter(Name='/dev/asg_refresh/instance_warmup', WithDecryption=False)

def trigger_auto_scaling_instance_refresh():


    try:
        print(asg_name)
        print(strategy)
        print(min_healthy_percentage)
        print(instance_warmup)
        response = asg_client.start_instance_refresh(
            AutoScalingGroupName=asg_name['Parameter']['Value'],
            Strategy=strategy['Parameter']['Value'],
            Preferences={
                'MinHealthyPercentage': int(min_healthy_percentage['Parameter']['Value']),
                'InstanceWarmup': int(instance_warmup['Parameter']['Value'])
            })
        logging.info("Triggered Instance Refresh {} for Auto Scaling "
                     "group {}".format(response['InstanceRefreshId'], asg_name['Parameter']['Value']))

    except ClientError as e:
        logging.error("Unable to trigger Instance Refresh for "
                      "Auto Scaling group {}".format(asg_name['Parameter']['Value']))
        raise e


def lambda_handler(event, context):

    # Trigger Auto Scaling group Instance Refresh
    trigger_auto_scaling_instance_refresh()

    return("Success")