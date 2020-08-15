# インフラ共用コード

- 原則として消えるとサービス運営そのものに大きく影響が出るようなものが含まれています

# 事前準備

s3 に tfstate を置いています。通常 CircleCI 上で `terraform apply` が行われるようになっています。
下記の準備が必要です。

- AWS系の環境変数を定義（AWS_ACCESS_KEY_IDなど）
- パスワードなどの環境変数を定義（variables.tfに格納されています）
- 事前にAWSで*variableのterraform_state_bucket_nameと同じ命名のbucketを作成してください(デフォルトのbucket nameは”hirokihello-ecs-fargate-infra-deploy-sample”)*

そのほか必要のあるvariables

```
TF_VAR_db_password=xxxx
TF_VAR_domain_name
```
