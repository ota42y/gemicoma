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
          branch: branch,
          public: true,
          bundle_files: bundle_files,
        }
      end

      let(:ruby_version_path) { { rubygem: { ruby_version_path: '' } } }
      let(:bundle_files) do
        {
          rubygem: {
            gemfile_path: '',
            ruby_version_path: './',
          },
        }
      end
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }
      let(:github_repository) { "#{github_user}/#{repository}" }
      let(:branch) { 'master' }

      let(:admin_user) { create(:admin, user: github_auth.user) }
      let(:github_auth) { create(:github_auth, user: build(:user)) }

      context 'correct' do
        before do
          admin_user
          github_login(github_auth.uid)
        end

        it do
          expect { subject }.to enqueue_job(::FetchMasterJob)

          expect(response.status).to eq 302

          user = Github::User.find_by!(name: github_user)

          # @type [Github::Repository] github_repository
          github_repository = user.github_repositories.find_by!(repository: repository)
          expect(github_repository.branch).to eq branch

          gem_info = github_repository.github_ruby_gem_info
          expect(gem_info.gemfile_path).to eq ''
          expect(gem_info.ruby_version_path).to eq './'
        end

        it 'check redirect' do
          expect(subject).to redirect_to('/github/users/ota42y/repositories/test')
        end

        it 'without ruby version path' do
          bundle_files[:rubygem].delete :ruby_version_path

          subject

          expect(response.status).to eq 302

          user = Github::User.find_by!(name: github_user)

          # @type [Github::Repository] github_repository
          github_repository = user.github_repositories.find_by!(repository: repository)

          gem_info = github_repository.github_ruby_gem_info
          expect(gem_info.ruby_version_path).to eq nil
        end
      end

      it 'not login' do
        subject

        expect(response.status).to eq 404
      end
    end
  end
end
