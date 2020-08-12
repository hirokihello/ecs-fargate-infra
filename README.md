# インフラ共用コード

- 原則として消えるとサービス運営そのものに大きく影響が出るようなものが含まれています

# 事前準備

s3 に tfstate を置いています。通常 CircleCI 上で `terraform apply` が行われるようになっていますが、どうしても手元で試してみたい場合は以下の設定を行ってください。

- AWS系の環境変数を定義（AWS_ACCESS_KEY_IDなど）
- パスワードなどの環境変数を定義（xxxxの部分は *必ず正しい値を入れてください*）

必要のあるvariables

```
export TF_VAR_staging_db_password=xxxx
TF_VAR_domain_name
```


```
aws iam --region ap-northeast-1 create-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json

aws iam --region ap-northeast-1 attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

```

aws iam --region ap-northeast-1 delete-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json
