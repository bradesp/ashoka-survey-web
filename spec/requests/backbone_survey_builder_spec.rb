describe 'BackboneSurveyBuilder', js: true do
  self.use_transactional_fixtures = false
  context "when adding a new radio question" do
    before(:each) do
      @survey = FactoryGirl.create(:survey)
      visit(surveys_build_path(:id => @survey.id))
      click_on('Radio Question')
    end

    it "should create a new question in the database" do
      sleep(1)
      question = Question.find_by_survey_id(@survey.id)
      question.should_not be_nil
      question.type.should == "RadioQuestion"
    end

    it "should add a radio question in the dummy" do
      dummy = find("#dummy_pane").find('div')
      dummy['type'].should == "RadioQuestion"
      dummy.should have_content("Untitled question")
      dummy.should have_content("First Option")
      dummy.should have_content("Second Option")
      dummy.should have_content("Third Option")
    end

    it "should add a hidden radio question in the settings pane" do
      actual = find("#settings_pane").find('div')
      actual['type'].should == "RadioQuestion"
      actual['style'].should == "display: none; "
      actual.should have_button("Add Option")
      actual.should have_field('content', :type => 'text')
      actual.should have_field('mandatory', :type => 'checkbox')
      actual.should have_field('image', :type => 'file')
      actual.should have_content("Option")
      actual.should have_selector('input', :count => 6 )
    end

    context "when clicking on a dummy" do
      it "should show a radio question in the settings pane" do
        find("#dummy_pane").find('div').click
        find("#settings_pane").find('div')['style'].should == "display: block; "
      end
    end

    context "when saving" do
      it "saves a question successfully" do
        pending "Something to do with poltergiest and ajax timeouts"
        find("#dummy_pane").find('div').click
        within("#settings_pane") do
          fill_in('content', :with => 'Some question')
          check('mandatory')
        end
        p Question.last
        find("#save").click
        sleep(10)
        question = Question.find_by_survey_id(@survey.id)
        question.content.should == "Some question"
        question.mandatory.should be_true
        question.options.length.should == 3
      end

      it "saves all options for a question" do
        pending "Something to do with poltergiest and ajax timeouts"
        find("#dummy_pane").find('div').click
        within("#settings_pane") do
          click_on('Add Option')
          click_on('Add Option')
        end
        find("#save").click
        sleep(10)
        question = Question.find_by_survey_id(@survey.id)
        question.options.length.should == 5
      end
    end
  end
  context "when adding a new single line question" do
    before(:each) do
      Survey.delete_all
      Question.delete_all
      @survey = FactoryGirl.create(:survey)
      visit(surveys_build_path(:id => @survey.id))
      click_on('Single Line Question')
    end

    it "should create a new question in the database" do
      sleep(1)
      question = Question.find_by_survey_id(@survey.id)
      question.should_not be_nil
      question.type.should == "SingleLineQuestion"
    end

    it "should add a single line question in the dummy" do
      dummy = find("#dummy_pane").find('div')
      dummy['type'].should == "SingleLineQuestion"
      dummy.should have_content("Untitled question")
    end

    it "should add a hidden single line question in the settings pane" do
      actual = find("#settings_pane").find('div')
      actual['type'].should == "SingleLineQuestion"
      actual['style'].should == "display: none; "
      actual.should have_field('content', :type => 'text')
      actual.should have_field('mandatory', :type => 'checkbox')
      actual.should have_field('image', :type => 'file')
    end

    context "when clicking on a dummy" do
      it "should show a single line question in the settings pane" do
        find("#dummy_pane").find('div').click
        find("#settings_pane").find('div')['style'].should == "display: block; "
      end
    end

    context "when saving" do
      it "saves a question successfully" do
        pending "Something to do with poltergiest and ajax timeouts"
        find("#dummy_pane").find('div').click
        within("#settings_pane") do
          fill_in('content', :with => 'Some question')
          check('mandatory')
        end
        p Question.last
        find("#save").click
        sleep(10)
        question = Question.find_by_survey_id(@survey.id)
        question.content.should == "Some question"
        question.mandatory.should be_true
      end
    end
  end
end