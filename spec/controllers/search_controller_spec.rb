# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET search' do
    context 'when user is not found' do
      let(:name) { 'an invalid github username' }
      before { allow(Octokit).to receive(:user).with(name).and_raise Octokit::NotFound }

      it 'should redirect to the root path' do
        get :search, name: name
        expect(response).to redirect_to(root_path)
      end

      it 'should display an error message' do
        get :search, name: name
        expect(flash[:alert]).to eq "'#{name}' is not a valid github username."
      end
    end

    context 'when user is found' do
      let(:user_name) { Faker::Superhero.name }
      let(:name) { 'eunomie' }
      let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: name, name: user_name) }
      before { allow(Octokit).to receive(:user).with(name).and_return(octokit_user) }

      it 'should render the search template' do
        get :search, name: name
        expect(response).to render_template(:search)
      end

      it 'should not display an error message' do
        get :search, name: name
        expect(flash[:alert]).to be_nil
      end
    end
  end
end
