import boto3

s3_client = boto3.client("s3")

buckets =  s3_client.list_buckets()["Buckets"]

buckets_all_status = []

for bucket in buckets:
    bucket_name = bucket["Name"]

    #public
    try:
        is_public = s3_client.get_bucket_policy_status(
            Bucket=bucket_name
        )["PolicyStatus"]["IsPublic"]

    except Exception:
        is_public = False

    # encryption
    try:
        s3_client.get_bucket_encryption(
            Bucket=bucket_name
        )
        is_encrypted = True
      
    except Exception:
        is_encrypted = False

    #versioning
    response = s3_client.get_bucket_versioning(
        Bucket=bucket_name
    )
    if response == "Enabled":
        is_versioning = True
    else:
        is_versioning = False

    buckets_all_status.append({
        "bucket": bucket_name,
        "public": is_public,
        "versioning": is_versioning,
        "encryption": is_encrypted
    })
