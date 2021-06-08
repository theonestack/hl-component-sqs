require 'yaml'

describe 'compiled component sqs' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/config_overrides.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/config_overrides/sqs.compiled.yaml") }
  
  context "Resource" do

    
    context "queue1" do
      let(:resource) { template["Resources"]["queue1"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue1"]]})
      end
      
      it "to have property VisibilityTimeout" do
          expect(resource["Properties"]["VisibilityTimeout"]).to eq(60)
      end
      
      it "to have property DelaySeconds" do
          expect(resource["Properties"]["DelaySeconds"]).to eq(20)
      end
      
      it "to have property MaximumMessageSize" do
          expect(resource["Properties"]["MaximumMessageSize"]).to eq(1024)
      end
      
      it "to have property MessageRetentionPeriod" do
          expect(resource["Properties"]["MessageRetentionPeriod"]).to eq(300)
      end
      
      it "to have property ReceiveMessageWaitTimeSeconds" do
          expect(resource["Properties"]["ReceiveMessageWaitTimeSeconds"]).to eq(120)
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue1"]]}}])
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
      
      it "to have property VisibilityTimeout" do
          expect(resource["Properties"]["VisibilityTimeout"]).to eq(120)
      end
      
      it "to have property DelaySeconds" do
          expect(resource["Properties"]["DelaySeconds"]).to eq(60)
      end
      
      it "to have property MaximumMessageSize" do
          expect(resource["Properties"]["MaximumMessageSize"]).to eq(256)
      end
      
      it "to have property MessageRetentionPeriod" do
          expect(resource["Properties"]["MessageRetentionPeriod"]).to eq(84600)
      end
      
      it "to have property ReceiveMessageWaitTimeSeconds" do
          expect(resource["Properties"]["ReceiveMessageWaitTimeSeconds"]).to eq(600)
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "queue2"]]}}])
      end
      
    end
    
  end

end