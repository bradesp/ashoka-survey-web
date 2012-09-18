require 'spec_helper'

describe RatingQuestion do
  it { should respond_to :content }
  it { should respond_to :mandatory }
  it { should respond_to :image }
  it { should respond_to :max_length }
  it { should belong_to :survey }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :content }
  
  it "is a question with type = 'RatingQuestion'" do
    RatingQuestion.create(:content => "hello")
    question = Question.find_by_content("hello")
    question.should be_a RatingQuestion
    question.type.should == "RatingQuestion"
  end
end