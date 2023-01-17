version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "${taskdefinition_arn}"
        LoadBalancerInfo:
          ContainerName: "${containername}"
          ContainerPort: ${containerport}