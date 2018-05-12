require 'rails_helper'

describe Admin::Github::RepositoriesController, type: :request do
  describe '#new' do
    subject { get url }

    let(:url) { '/admin/github/repositories/new' }
    let(:github_auth) { create(:github_auth, user: build(:user)) }
    let(:admin_user) { create(:admin, user: github_auth.user) }

    it do
      admin_user
      github_login(github_auth.uid)

      subject

      expect(response.status).to eq 200
    end

    it 'not login' do
      subject

      expect(response.status).to eq 404
    end
  end

  describe '#create' do
    subject { post url, params: params }

    let(:url) { '/admin/github/repositories' }
    let(:params) { {} }

    context 'when correct params' do
      let(:params) do
        {
          github_repository: github_repository,
          public: true,
          bundle_files: bundle_files,
        }
      end

      let(:bundle_files) { { rubygem: { gemfile_path: '' } } }
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }
      let(:github_repository) { "#{github_user}/#{repository}" }

      let(:admin_user) { create(:admin, user: github_auth.user) }
      let(:github_auth) { create(:github_auth, user: build(:user)) }

      context 'correct' do
        before do
          admin_user
          github_login(github_auth.uid)
        end

        it do
          # expect { subject }.to enqueue_job(::FetchRevisionJob)
          subject

          expect(response.status).to eq 302

          user = Github::User.find_by!(name: github_user)

          # @type [Github::Repository] github_repository
          github_repository = user.github_repositories.find_by!(repository: repository)

          gem_info = github_repository.github_ruby_gem_info
          expect(gem_info.gemfile_path).to eq ''
        end

        it 'check redirect' do
          expect(subject).to redirect_to('/github/users/ota42y/repositories/test')
        end
      end

      it 'not login' do
        subject

        expect(response.status).to eq 404
      end
    end
  end
end
