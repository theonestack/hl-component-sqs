require 'yaml'

describe 'compiled component sqs' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/queue_policy.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/queue_policy/sqs.compiled.yaml") }
  
  context "Resource" do

    
    context "Test" do
      let(:resource) { template["Resources"]["Test"] }

      it "is of type AWS::SQS::Queue" do
          expect(resource["Type"]).to eq("AWS::SQS::Queue")
      end
      
      it "to have property QueueName" do
          expect(resource["Properties"]["QueueName"]).to eq({"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "Test"]]})
      end
      
      it "to have property MessageRetentionPeriod" do
          expect(resource["Properties"]["MessageRetentionPeriod"]).to eq(3600)
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}, {"Key"=>"EnvironmentType", "Value"=>{"Ref"=>"EnvironmentType"}}, {"Key"=>"Name", "Value"=>{"Fn::Join"=>["-", [{"Ref"=>"EnvironmentName"}, "Test"]]}}])
      end
      
    end
    
    context "TestPolicy" do
      let(:resource) { template["Resources"]["TestPolicy"] }

      it "is of type AWS::SQS::QueuePolicy" do
          expect(resource["Type"]).to eq("AWS::SQS::QueuePolicy")
      end
      
      it "to have property PolicyDocument" do
          expect(resource["Properties"]["PolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Sid"=>"S3EventTrigger", "Action"=>"SQS:SendMessage", "Resource"=>[{"Fn::GetAtt"=>["Test", "Arn"]}], "Effect"=>"Allow", "Principal"=>{"AWS"=>{"Ref"=>"AWS::AccountId"}}, "Condition"=>{"ArnEquals"=>{"aws:SourceArn"=>{"Fn::Sub"=>"arn:aws:s3:::${Bucket}"}}}}, {"Sid"=>"CrossAccount", "Action"=>["sqs:ReceiveMessage"], "Resource"=>[{"Fn::GetAtt"=>["Test", "Arn"]}], "Effect"=>"Allow", "Principal"=>{"AWS"=>[{"Fn::Sub"=>"arn:aws:iam::${ReceivingAccount}:role/role1"}]}}]})
      end
      
      it "to have property Queues" do
          expect(resource["Properties"]["Queues"]).to eq([{"Ref"=>"Test"}])
      end
      
    end
    
  end

end