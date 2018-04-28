require 'rails_helper'

describe Github::RepositoriesController, type: :request do
  describe '#create' do
    subject { post url, params: params }

    let(:url) { '/github/repositories' }
    let(:params) { {} }

    context 'when correct params' do
      let(:params) { { user: github_user, repository: repository, public: true, bundle_files: bundle_files } }

      let(:bundle_files) { [{ file_type: :rubygem, filepath: './' }] }
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }

      it do
        expect(subject).to redirect_to('/github/users/ota42y/repositories/test')
        expect(response.status).to eq 302

        user = Github::User.find_by!(name: github_user)
        github_repository = user.github_repositories.find_by!(repository: repository)

        bundle_file = github_repository.github_bundle_files.first
        expect(bundle_file.file_type).to eq 'rubygem'
        expect(bundle_file.filepath).to eq './'
      end
    end
  end
end
