require 'yaml'

describe 'compiled component sqs' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/dlq.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/dlq/sqs.compiled.yaml") }
  
  context "Resource" do

    
    context "myqueue" do
      let(:resource) { template["Resources"]["myqueue"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "my-queue"]]})
      end
      
      it "to have property MessageRetentionPeriod" do
          expect(resource["Properties"]["MessageRetentionPeriod"]).to eq(600)
      end
      
      it "to have property RedrivePolicy" do
          expect(resource["Properties"]["RedrivePolicy"]).to eq({"deadLetterTargetArn"=>{"Fn::GetAtt"=>["myqueuedlq", "Arn"]}, "maxReceiveCount"=>10})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "my-queue"]]}}])
      end
      
    end
    
    context "myqueuedlq" do
      let(:resource) { template["Resources"]["myqueuedlq"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "my-queue-dlq"]]})
      end
      
      it "to have property MessageRetentionPeriod" do
          expect(resource["Properties"]["MessageRetentionPeriod"]).to eq(84600)
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "my-queue-dlq"]]}}])
      end
      
    end
    
  end

end