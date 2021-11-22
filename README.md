# sqs CfHighlander component

## Build status
![cftest workflow](https://github.com/theonestack/hl-component-sqs/actions/workflows/rspec.yaml/badge.svg)
## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development','production']

## Outputs/Exports

| Name | Value | Exported |
| ---- | ----- | -------- |
| {logical_id}QueueUrl | The URL to be used to interact with the SQS queue | true
| {logical_id}QueueName | The full queue name | true
| {logical_id}QueueArn | The queue ARN | false

## Included Components

[lib-ec2](https://github.com/theonestack/hl-component-lib-ec2)
## Example Configuration
### Highlander
```
Component name:'sqs', template: 'sqs'

```

### Elasticsearch Configuration
```
queues:
  -
    name: app1Queue
    visibility_timeout: 10
    delay_seconds: 1
    maximum_message_size: 4096 // An integer in bytes from 1,024 bytes (1 KiB) up to 262,144 bytes (256 KiB).
```

## Cfhighlander Setup

install cfhighlander [gem](https://github.com/theonestack/cfhighlander)

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```
## Testing Components

Running the tests

```bash
cfhighlander cftest sqs
```