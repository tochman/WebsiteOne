require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    before(:each) do
      @users = [
          double('User', country: 'some country'),
          double('User', country: 'some country'),
          double('User', country: 'some country'),
          double('User', country: 'some country')
      ]
      User.stub_chain(:where, :order).and_return(@users)
    end

    it 'returns http success' do
      get 'index'
      expect(response).to render_template 'index'
    end

    it 'assigns all users' do
      get 'index'
      assigns(:users).should eq @users
    end
  end

  describe 'GET show' do
    before :each do
      @projects = [
          mock_model(Project, friendly_id: 'title-1', title: 'Title 1'),
          mock_model(Project, friendly_id: 'title-2', title: 'Title 2'),
          mock_model(Project, friendly_id: 'title-3', title: 'Title 3')
      ]

      @user = double('User', id: 1,
                     first_name: 'Hermionie',
                     last_name: 'Granger',
                     friendly_id: 'harry-potter',
                     email: 'hgranger@hogwarts.ac.uk',
                     display_profile: true,
                     youtube_id: 'test_id'
      )
      @user.stub(:following_by_type).and_return(@projects)
      User.stub_chain(:friendly, :find).and_return(@user)

      @youtube_videos = [
          {
              url: "http://www.youtube.com/100",
              title: "Random",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/340",
              title: "Stuff",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/2340",
              title: "Here's something",
              published: '01/01/2015'
          }
      ]
      Youtube.stub(user_videos: @youtube_videos)
    end

    it 'assigns a user instance' do
      get 'show', id: @user.friendly_id
      expect(assigns(:user)).to eq(@user)
    end

    it 'assigns youtube videos' do
      get 'show', id: @user.friendly_id
      expect(assigns(:youtube_videos)).to eq(@youtube_videos)
    end

    it 'renders the show view' do
      get 'show', id: @user.friendly_id
      expect(response).to render_template :show
    end

    context 'with followed projects' do
      # Bryan: Empty before block?
      #before :each do
      #end

      it 'assigns a list of project being followed' do
        get 'show', id: @user.friendly_id
        expect(assigns(:users_projects)).to eq(@projects)
      end

      it 'it renders an error message when accessing a private profile' do
        @user.stub(display_profile: false)
        get 'show', id: @user.friendly_id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'send hire me button message' do
    let(:valid_params) { {name: 'Thomas', email: 'thomas@email.com', message: 'Want to hire you!'} }
    let(:user) { @user }
    before(:each) do
      @user = User.new(first_name: 'Marcelo',
                       last_name: 'Mr G',
                       email: 'marcelo@whatever.com',
                       password: '1234567890')

      @previous_page = '/'
      @request.env['HTTP_REFERER'] = @previous_page
     # Mailer.hire_me_form(user, valid_params)
      Mailer.stub_chain(:hire_me_form, :deliver).and_return(true)
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []

    end


    it 'renders successful message' do
      post :hire_me_contact_form, [user, valid_params]
      expect(response).to redirect_to @previous_page
      expect(flash[:notice]).to eq('Your message has been sent successfully!')
    end

    it 'renders failure message' do
      Mailer.stub_chain(:hire_me_form, :deliver).and_return(false)
      post :hire_me_contact_form, valid_params
      expect(response).to redirect_to @previous_page
      expect(flash[:alert]).to eq('Your message has not been sent!')
    end

    it 'checks field Name' do
      post :hire_me_contact_form, name: '', message: '123'
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'checks field Message' do
      post :hire_me_contact_form, name: '123', message: ''
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'calls mailer' do
      expect(Mailer).to receive(:hire_me_form) do |arg|
        expect(arg).to include(valid_params)
        double(ActionMailer::Base).as_null_object
      end
      post :hire_me_contact_form, valid_params
    end

    it 'sends the email to site admin' do
      allow(Mailer).to receive(:hire_me_form).and_call_original

      post :hire_me_contact_form, valid_params
      expect(ActionMailer::Base.deliveries[0].body).to include('Want to hire you!')
    end
  end
end
