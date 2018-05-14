require 'rails_helper'

describe Github::UsersController, type: :request do
  describe '#show' do
    subject { get url, params: params }

    let(:url) { "/github/users/#{github_user_name}" }
    let(:params) { {} }

    context 'when not login' do
      let(:github_user_name) { 'test' }

      it do
        subject
        expect(response.status).to eq 404
      end
    end

    context 'when log in' do
      context 'user exist' do
        let(:github_user_name) { github_user.name }
        let(:github_user) { github_repository.github_user }
        let(:github_repository) { create(:github_repository) }
        let(:github_auth) { create(:github_auth, user: build(:user)) }

        before do
          github_login(github_auth.uid)
        end

        it do
          subject
          expect(response.status).to eq 200
          expect(response.body).to include(github_user_name)
          expect(response.body).to include(github_repository.github_path)
        end
      end

      context 'user not exist' do
        let(:github_user_name) { '0' }
        let(:github_auth) { create(:github_auth, user: build(:user)) }

        before do
          github_login(github_auth.uid)
        end

        it do
          subject
          expect(response.status).to eq 404
        end
      end
    end
  end
end
