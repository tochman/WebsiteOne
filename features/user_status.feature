Feature: User status
  As site administrator
  In order to simplify interactions between users
  I would like them to be able to set current availability status on their user profile.

  PT story: https://www.pivotaltracker.com/story/show/78088070

  Background:
    Given the following users exist
      | first_name | last_name | email                  | updated_at               |
      | Alice      | Jones     | alicejones@hotmail.com | 2014-09-30 05:09:00 UTC' |
      | Bob        | Butcher   | bobb112@hotmail.com    | 2014-09-30 04:00:00 UTC' |
    And the following statuses have been set
      | status         | user  |
      | I want to pair | Alice |
      | I'm offline    | Bob   |

  @time-travel-step
  Scenario: I should see a users status on index page if user is online
    Given the date is "2014-09-30 05:15:00 UTC"
    And I visit "/users"
    And I should see "2" user avatars within the main content
    And I should see "I want to pair"
    And I should not see "I'm offline"

  @time-travel-step
  Scenario: I should see a users status on his profile page if user is online
    Given the date is "2014-09-30 05:15:00 UTC"
    Given I visit Alice's profile page
    Then I should see "I want to pair"

  @time-travel-step
  Scenario: I should not see a users status on his profile page if user is offline
    Given the date is "2014-09-30 05:15:00 UTC"
    And I visit Bob's profile page
    Then I should not see "I'm offline"