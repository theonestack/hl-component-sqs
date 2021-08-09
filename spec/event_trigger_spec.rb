require 'yaml'

describe 'compiled component sqs' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/event_trigger.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/event_trigger/sqs.compiled.yaml") }
  
  context "Resource" do

    
    context "queue1" do
      let(:resource) { template["Resources"]["queue1"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue1"]]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue1"]]}}])
      end
      
    end
    
    context "testevent1" do
      let(:resource) { template["Resources"]["testevent1"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq("testevent1")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("Test event1")
      end
      
      it "to have property ScheduleExpression" do
          expect(resource["Properties"]["ScheduleExpression"]).to eq("rate(5 minutes)")
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq("ENABLED")
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>{"Fn::GetAtt"=>["queue1", "Arn"]}, "Id"=>"queue1", "Input"=>"{\"event\":\"test\"}", "SqsParameters"=>{"MessageGroupId"=>"default"}}])
      end
      
    end
    
    context "queue1Policy" do
      let(:resource) { template["Resources"]["queue1Policy"] }

      it "is of type AWS::SQS::QueuePolicy" do
          expect(resource["Type"]).to eq("AWS::SQS::QueuePolicy")
      end
      
      it "to have property PolicyDocument" do
          expect(resource["Properties"]["PolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Sid"=>"queue1Eventtestevent1", "Action"=>"SQS:SendMessage", "Resource"=>{"Fn::GetAtt"=>["queue1", "Arn"]}, "Effect"=>"Allow", "Principal"=>{"Service"=>"events.amazonaws.com"}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::GetAtt"=>["testevent1", "Arn"]}}}}]})
      end
      
      it "to have property Queues" do
          expect(resource["Properties"]["Queues"]).to eq([{"Ref"=>"queue1"}])
      end
      
    end
    
    context "queue2" do
      let(:resource) { template["Resources"]["queue2"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue2"]]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue2"]]}}])
      end
      
    end
    
    context "testevent2" do
      let(:resource) { template["Resources"]["testevent2"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq("testevent2")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("Test event2")
      end
      
      it "to have property ScheduleExpression" do
          expect(resource["Properties"]["ScheduleExpression"]).to eq("cron(* * * * *)")
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq("ENABLED")
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>{"Fn::GetAtt"=>["queue2", "Arn"]}, "Id"=>"queue2", "InputPath"=>"$.detail", "SqsParameters"=>{"MessageGroupId"=>"default"}}])
      end
      
    end
    
    context "queue2Policy" do
      let(:resource) { template["Resources"]["queue2Policy"] }

      it "is of type AWS::SQS::QueuePolicy" do
          expect(resource["Type"]).to eq("AWS::SQS::QueuePolicy")
      end
      
      it "to have property PolicyDocument" do
          expect(resource["Properties"]["PolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Sid"=>"queue2Eventtestevent2", "Action"=>"SQS:SendMessage", "Resource"=>{"Fn::GetAtt"=>["queue2", "Arn"]}, "Effect"=>"Allow", "Principal"=>{"Service"=>"events.amazonaws.com"}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::GetAtt"=>["testevent2", "Arn"]}}}}]})
      end
      
      it "to have property Queues" do
          expect(resource["Properties"]["Queues"]).to eq([{"Ref"=>"queue2"}])
      end
      
    end
    
    context "queue3" do
      let(:resource) { template["Resources"]["queue3"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue3"]]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue3"]]}}])
      end
      
    end
    
    context "testevent3" do
      let(:resource) { template["Resources"]["testevent3"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq("testevent3")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("Test event3")
      end
      
      it "to have property EventPattern" do
          expect(resource["Properties"]["EventPattern"]).to eq("{\"source\": [\"aws.ec2\"]}")
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq("ENABLED")
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>{"Fn::GetAtt"=>["queue3", "Arn"]}, "Id"=>"queue3", "InputTransformer"=>{"InputPathsMap"=>{"instance"=>"$.detail.instance", "status"=>"$.detail.status"}, "InputTemplate"=>"<instance> is in state <status>"}, "SqsParameters"=>{"MessageGroupId"=>"default"}}])
      end
      
    end
    
    context "queue3Policy" do
      let(:resource) { template["Resources"]["queue3Policy"] }

      it "is of type AWS::SQS::QueuePolicy" do
          expect(resource["Type"]).to eq("AWS::SQS::QueuePolicy")
      end
      
      it "to have property PolicyDocument" do
          expect(resource["Properties"]["PolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Sid"=>"queue3Eventtestevent3", "Action"=>"SQS:SendMessage", "Resource"=>{"Fn::GetAtt"=>["queue3", "Arn"]}, "Effect"=>"Allow", "Principal"=>{"Service"=>"events.amazonaws.com"}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::GetAtt"=>["testevent3", "Arn"]}}}}]})
      end
      
      it "to have property Queues" do
          expect(resource["Properties"]["Queues"]).to eq([{"Ref"=>"queue3"}])
      end
      
    end
    
    context "queue4" do
      let(:resource) { template["Resources"]["queue4"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue4"]]})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue4"]]}}])
      end
      
    end
    
    context "testevent4" do
      let(:resource) { template["Resources"]["testevent4"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq("testevent4")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("")
      end
      
      it "to have property ScheduleExpression" do
          expect(resource["Properties"]["ScheduleExpression"]).to eq("cron(* * * * *)")
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq("ENABLED")
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>{"Fn::GetAtt"=>["queue4", "Arn"]}, "Id"=>"queue4", "Input"=>"{\"event\":\"test\"}"}])
      end
      
    end
    
    context "testevent5" do
      let(:resource) { template["Resources"]["testevent5"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Name" do
          expect(resource["Properties"]["Name"]).to eq("testevent5")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq("")
      end
      
      it "to have property EventPattern" do
          expect(resource["Properties"]["EventPattern"]).to eq("{\"source\": [\"aws.ec2\"]}")
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq("ENABLED")
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>{"Fn::GetAtt"=>["queue4", "Arn"]}, "Id"=>"queue4", "Input"=>"{\"event\":\"test\"}"}])
      end
      
    end
    
    context "queue4Policy" do
      let(:resource) { template["Resources"]["queue4Policy"] }

      it "is of type AWS::SQS::QueuePolicy" do
          expect(resource["Type"]).to eq("AWS::SQS::QueuePolicy")
      end
      
      it "to have property PolicyDocument" do
          expect(resource["Properties"]["PolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Sid"=>"queue4Eventtestevent4", "Action"=>"SQS:SendMessage", "Resource"=>{"Fn::GetAtt"=>["queue4", "Arn"]}, "Effect"=>"Allow", "Principal"=>{"Service"=>"events.amazonaws.com"}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::GetAtt"=>["testevent4", "Arn"]}}}}, {"Sid"=>"queue4Eventtestevent5", "Action"=>"SQS:SendMessage", "Resource"=>{"Fn::GetAtt"=>["queue4", "Arn"]}, "Effect"=>"Allow", "Principal"=>{"Service"=>"events.amazonaws.com"}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::GetAtt"=>["testevent5", "Arn"]}}}}]})
      end
      
      it "to have property Queues" do
          expect(resource["Properties"]["Queues"]).to eq([{"Ref"=>"queue4"}])
      end
      
    end
    
  end

end