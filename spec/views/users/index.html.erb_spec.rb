require 'spec_helper'

describe 'users/index.html.erb', :type => :view do
  before(:each) do
    @users = FactoryGirl.build_list(:user, 4, updated_at: '2013-09-30 05:00:00 UTC')
  end

  it 'should display user filter form' do
    render
    expect(rendered).to have_content('Filter users')
    expect(rendered).to have_css('#user-filter')
  end

  it 'should display a list of users' do
    render
    @users.each do |user|
      expect(rendered).to have_content(user.first_name)
    end
  end

  it 'renders User name link with href' do
    render
    @users.each do |user|
      expect(rendered).to have_xpath("//a[contains(@href, '/users/#{user.slug}')]")
    end
  end

  context 'renders the users count in the sentence above' do
    it 'has valid users count' do
      render
      expect(rendered).to have_content("Check out our #{@users.count} awesome volunteers from all over the globe!")
    end

    it 'shows different sentence if invalid users count' do
      @users = []
      render
      expect(rendered).to have_content('It is a lonely planet we live in')
    end
  end

  context 'display user status' do

    before(:each) do
      @users_online = FactoryGirl.create_list(:user, 4, updated_at: '2014-09-30 05:00:00 UTC')
      @users_offline = FactoryGirl.create_list(:user, 4, updated_at: '2014-09-30 04:00:00 UTC')
      @users = [@users_online, @users_offline].flatten
      user = @users_online.first
      user.status.create(attributes = FactoryGirl.attributes_for(:status))
    end

    after(:each) do
      Delorean.back_to_the_present
    end

    it 'display green dot for online users' do
      Delorean.time_travel_to(Time.parse('2014-09-30 05:09:00 UTC'))
      render
      expect(rendered).to have_css('img[src*="/assets/green-dot.png"]')
    end

    it 'there should be 4 green dots' do
      Delorean.time_travel_to(Time.parse('2014-09-30 05:09:00 UTC'))
      render
      expect(rendered).to have_css('img[src*="/assets/green-dot.png"]', count: 4)
    end

    it 'do not display green dot for offline users' do
      Delorean.time_travel_to(Time.parse('2014-09-30 05:19:00 UTC'))
      render
      expect(rendered).to_not have_css('img[src*="/assets/green-dot.png"]')
    end

    it 'displays the user\'s status with a speech bubble' do
      Delorean.time_travel_to(Time.parse('2014-09-30 05:09:00 UTC'))
      render
      rendered.within('div#user-status') do |status|
        expect(status).to have_content("\"My status\"")
        expect(status).to have_css(".glyphicon-comment")
      end
    end
  end
end
