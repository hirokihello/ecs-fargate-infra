resource "aws_ecr_repository" "hirokihello-app-master" {
  name = "hirokihello/hirokihello-app/master"
}

resource "aws_ecr_lifecycle_policy" "hirokihello-app-master" {
  repository = aws_ecr_repository.hirokihello-app-master.name
  policy = file("ecr_lifecycle_policy.json")
}
