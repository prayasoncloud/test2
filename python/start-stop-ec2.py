import boto3

ec2 = boto3.client("ec2")

def get_instances():
    
    response = ec2.describe_instances(
        Filters = [
            {"Name": "tag:env", "values": "dev"},
            {"Name": "instance-state-name", "values": ["running", "stopped"]}
        ]
    )
    instancess = []
    for reservations in response["Reservation"]:
        for instances in reservations["Instances"]:
            instancess.append(instances["InstanceId"])

    return instancess

def stop_instance(instance):
    ec2.stop_instances(InstanceId=instance)

def start_instance(instance):
    ec2.start_instances(InstanceId=instance)


def lambda_handler(event, context):
    action = event.get("action")
    isinstances = get_instances()

    if action == "stop":
        stop_instance(isinstance)
    elif action == "start":
        start_instance(isinstance)
    else:
        print("Bad action")

        