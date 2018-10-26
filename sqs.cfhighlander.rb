CfhighlanderTemplate do
  Name 'sqs'
  ComponentVersion component_version
  Description "#{component_name} - #{component_version}"

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', isGlobal: true, allowedValues: ['development', 'production']
  end

end
