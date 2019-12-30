CloudFormation do

  tags = []
  tags << { Key: 'Environment', Value: Ref(:EnvironmentName) }
  tags << { Key: 'EnvironmentType', Value: Ref(:EnvironmentType) }

  extra_tags = external_parameters.fetch(:extra_tags, [])
  extra_tags.each { |key,value| tags << { Key: key, Value: value } } if defined? extra_tags

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

      Output("#{logical_id}QueueUrl") {
          Value(Ref(logical_id))
          Export FnSub("${EnvironmentName}-#{component_name}-#{logical_id}Url")
      }

      Output("#{logical_id}QueueName") {
          Value(FnGetAtt(logical_id, 'QueueName'))
          Export FnSub("${EnvironmentName}-#{component_name}-#{logical_id}Name")
      }

      Output("#{logical_id}QueueArn", FnGetAtt(logical_id, 'Arn'))

  end if (defined? queues) && (!queues.nil?)

end