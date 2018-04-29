require 'rails_helper'

describe Github::Users::RepositoriesController, type: :request do
  describe '#show' do
    subject { get url }

    let(:url) { "/github/users/#{github_user}/repositories/#{repository}" }

    context 'when correct params' do
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }

      it do
        user = ::Github::User.find_or_create_by!(name: github_user)
        user.github_repositories.find_or_create_by!(repository: repository)

        subject

        expect(response.status).to eq 200
      end
    end

    context 'when no data' do
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }

      it 'no github user' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'no repository' do
        ::Github::User.find_or_create_by!(name: github_user)

        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
