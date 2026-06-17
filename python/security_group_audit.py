import boto3

sg_client = boto3.client("ec2")

# response = sg_client.describe_security_groups()

sg_paginator = sg_client.get_paginator("describe_security_groups")



for page in sg_paginator.paginate():
    for sg in page["SecurityGroups"]:
        sg_name = sg.get("GroupName")
        sg_id = sg.get("GroupId")

        # if sg["IpPermissions"].get('FromPort') <= 22 & sg["IpPermissions"].get('ToPort') >= 3389:

        #     if "0.0.0.0" == sg["IpPermissions"].get('IpProtocol'):
        #         print(f"0.0.0.0/0 on port 22\n0.0.0.0/0 on port 3389\n Opened on Groupid {sg_id} and Group {sg_name}")

        for perm in sg["IpPermissions"]:

            for cidr in perm['IpRanges']:
                if cidr['CidrIp'] == "0.0.0.0/0":
                
                    from_port = perm.get('FromPort')
                    to_port = perm.get('ToPort')

                    if from_port <= 22 <= to_port:
                        print(f"Group name :  and GroupId {sg_id} is publicly open on port 22")

                    if from_port <= 3389 <= to_port:
                        print(f"Group name :  and GroupId {sg_id} is publicly open on port 3389")
