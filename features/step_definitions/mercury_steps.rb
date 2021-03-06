When /^(?:|I )click "([^"]*)" within Mercury Editor toolbar$/ do |button|
  selector_for = {
      'save' => 'mercury-save-button'
  }
  page.execute_script("$('.#{selector_for[button.downcase]}').click()")
  p 'sleep(0.1)'
  sleep(0.1)
end

Given(/^I am going to use the Mercury Editor/) do
  Capybara.current_driver = :selenium
end

When(/^I fill in the editable field "([^"]*)" with "([^"]*)"$/) do |field, s|
  page.driver.within_frame('mercury_iframe') {
    field = field.downcase.singularize
    # This selector is specific to the mercury region used!
    if field == 'title'
      find(:css, 'div#document_title>textarea').set(s)
    elsif field == 'body'
      page.execute_script("$('#document_body').text('#{s}')")
      #find(:css, 'div#document_body').set(s)
    end
  }
end

Then(/^I should be in the Mercury Editor$/) do
  expect(current_path).to match(/\/editor\//i)
end

When(/^I (try to use|am using) the Mercury Editor to edit ([^"]*) "([^"]*)"$/) do |opt, model, title|
  #Capybara.current_driver = :selenium
  visit "/editor#{url_for_title(action: 'show', controller: model, title: title)}"
end

# Bryan: not completely reliable but works for the time being
Then(/^I should see the editable field "([^"]*)"$/) do |field|
  find(:css, "div#document_#{field.downcase.singularize}")
end

When(/^I try to edit the page$/) do
  visit '/editor' + current_path
end