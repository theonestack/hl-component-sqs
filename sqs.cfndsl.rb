CloudFormation do

  tags = []
  tags << { Key: 'Environment', Value: Ref(:EnvironmentName) }
  tags << { Key: 'EnvironmentType', Value: Ref(:EnvironmentType) }

  extra_tags = external_parameters.fetch(:extra_tags, {})
  extra_tags.each { |key,value| tags << { Key: key, Value: value } }

  queues = external_parameters.fetch(:queues, [])
  filter = /[^0-9a-z ]/i
  queues.each do |queue|
      logical_id = queue['name'].gsub(filter, '')
      SQS_Queue(logical_id) do
          QueueName FnJoin("-", [Ref('EnvironmentName'), queue['name']]) unless (queue.has_key?('generated_name')) && (queue['generated_name'])
          VisibilityTimeout queue['visibility_timeout'] if queue.has_key?('visibility_timeout')
          DelaySeconds queue['delay_seconds'] if queue.has_key?('delay_seconds')
          MaximumMessageSize queue['maximum_message_size'] if queue.has_key?('maximum_message_size')
          MessageRetentionPeriod queue['message_retention_period'] if queue.has_key?('message_retention_period')
          ReceiveMessageWaitTimeSeconds queue['receive_message_wait_time_seconds'] if queue.has_key?('receive_message_wait_time_seconds')
          KmsMasterKeyId queue['kms_master_key'] if queue.has_key?('kms_master_key')
          KmsDataKeyReusePeriodSeconds queue['kms_data_key_reuse_seconds'] if queue.has_key?('kms_data_key_reuse_seconds')

          if queue.has_key?('redrive_policy')
            RedrivePolicy ({
                deadLetterTargetArn: FnGetAtt(queue['redrive_policy']['queue'].gsub(filter, ''), 'Arn'),
                maxReceiveCount: queue['redrive_policy']['count']
            })
          end

          if (queue.has_key?('fifo_queue')) && (queue['fifo_queue'])
            FifoQueue true
            ContentBasedDeduplication queue['content_based_deduplication'] if queue.has_key?('content_based_deduplication')
          end
          Tags tags + [{ Key: 'Name', Value: FnJoin('-', [ Ref(:EnvironmentName), queue['name'] ]) }]
          
      end

      queue_policies = []

      if queue.has_key?('topics')
        queue['topics'].each_with_index do |topic, i|
          SNS_Subscription("#{logical_id}Subscription#{i}") do
            TopicArn topic
            Protocol 'sqs'
            Endpoint FnGetAtt(logical_id, 'Arn')
          end
          statement = {
            Sid: "#{logical_id}Subscription#{i}",
            Action: 'SQS:SendMessage',
            Resource: FnGetAtt(logical_id,'Arn'),
            Effect: 'Allow',
            Principal: { AWS: Ref('AWS::AccountId')},
            Condition: { ArnEquals: { "aws:SourceArn": topic }}
          }
          queue_policies << statement
        end
      end


      if queue.has_key?('policies')  
        queue['policies'].each do |name,policy|
          resources = policy.fetch('resource', FnGetAtt(logical_id,'Arn'))
          resources = (resources.kind_of?(Array) ? resources : [resources])
  
          statement = {
              Sid: name,
              Action: policy.fetch('action', 'SQS:SendMessage'),
              Resource: resources,
              Effect: policy.fetch('effect', 'Allow'),
              Principal: policy.fetch('principal', {AWS: Ref('AWS::AccountId')})
          }
        
          if policy.has_key?('condition')
            statement[:Condition] = policy['condition']
          end
          
          queue_policies << statement
        end
      end

      if queue_policies.any?
        SQS_QueuePolicy("#{logical_id}Policy") do
          PolicyDocument({
            Version: '2012-10-17',
            Statement: queue_policies
          })
          Queues [Ref(logical_id)]
        end 
      end
      
      Output("#{logical_id}QueueUrl") {
          Value(Ref(logical_id))
          Export FnSub("${EnvironmentName}-#{external_parameters[:component_name]}-#{logical_id}Url")
      }

      Output("#{logical_id}QueueName") {
          Value(FnGetAtt(logical_id, 'QueueName'))
          Export FnSub("${EnvironmentName}-#{external_parameters[:component_name]}-#{logical_id}Name")
      }

      Output("#{logical_id}QueueArn", FnGetAtt(logical_id, 'Arn'))

  end

end
