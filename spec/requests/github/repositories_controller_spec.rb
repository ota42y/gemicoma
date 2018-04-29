require 'rails_helper'

describe Github::RepositoriesController, type: :request do
  describe '#new' do
    subject { get url }

    let(:url) { '/github/repositories/new' }

    it do
      subject

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    subject { post url, params: params }

    let(:url) { '/github/repositories' }
    let(:params) { {} }

    context 'when correct params' do
      let(:params) do
        {
          user: github_user,
          repository: repository,
          public: true,
          bundle_files: bundle_files,
          commit_hash: commit_hash,
        }
      end

      let(:bundle_files) { { rubygem: { filepath: './' } } }
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }
      let(:commit_hash) { SecureRandom.hex(40) }

      it do
        expect { subject }.to enqueue_job(::CheckNewRevisionJob)

        expect(response.status).to eq 302

        user = Github::User.find_by!(name: github_user)
        github_repository = user.github_repositories.find_by!(repository: repository)

        gemfile_info = github_repository.github_ruby_gemfile_info
        expect(gemfile_info.filepath).to eq './'

        revision = github_repository.github_revisions.first
        expect(revision.commit_hash).to eq commit_hash
        expect(revision.status).to eq 'initialized'
      end

      it 'check redirect' do
        expect(subject).to redirect_to('/github/users/ota42y/repositories/test')
      end
    end
  end
end
