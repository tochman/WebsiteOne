Then(/^I should see a activity feed$/) do
  expect(page).to have_css('div#feed')
end

And(/^activities exists$/) do
  pending
end

And(/^I edit article "([^"]*)"$/) do |article|
  steps %Q{
    And I am on the "Show" page for article "#{article}"
    And I click the very stylish "Edit article" button
    Then I should be on the "Edit" page for article "#{article}"
    And I fill in "Content" with "**New content** ``New Markdown``"
    And I click the "Update" button
}
end

And(/^I create a document named "([^"]*)"$/) do |document|
  steps %Q{ Given I am on the "Show" page for project "Hello Galaxy"
            And I click the "Join Project" button
            And I click "Project Actions"
            And I click "Create new document"
            And I fill in "Title" with "#{document}"
            And I click "Submit"
}
end

And(/^I create a project named "([^"]*)"$/) do |project|
  steps %Q{
    And I am on the "Projects" page
    And I click the very stylish "New Project" button
    When I fill in:
      | Field               | Text                                            |
      | Title               | #{project}                                      |
      | Description         | Description New                                 |
      | GitHub link         | http://www.github.com/abc                       |
      | PivotalTracker link | http://www.pivotaltracker.com/s/projects/982890 |
    And I select "Status" to "Active"
    And I click the "Submit" button
}
end

And(/^I create a PP session hangout for "([^"]*)"$/) do |project|
  steps %Q{
    And I am not a member of project "#{project}"
    And I am on the "Show" page for project "#{project}"
    And I click "Join Project"
    And I create a hangout for "#{project}"
}
end

Given(/^I watch the Activity feed$/) do
  steps %Q{
    Given I am on the "Dashboard" page
    And I click the "Activity feed" link
}
end

And (/^I create a hangout for "([^"]*)"$/) do |project|
  FactoryGirl.create(:hangout, title: project)
end


