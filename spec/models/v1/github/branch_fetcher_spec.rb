require 'rails_helper'

describe V1::Github::BranchFetcher, type: :model do
  describe 'execute' do
    subject { V1::Github::BranchFetcher.execute(repository) }

    context 'get commit hash from github' do
      let(:repository) do
        repository = build(:github_repository)
        repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        repository.save!
        repository
      end

      let(:commit_hash) { SecureRandom.hex(40) }

      before do
        allow(::V1::GithubRepository).to receive(:branch_commit_hash).
                                           with(repository.github_path, 'master').
                                           and_return(commit_hash)
      end

      it do
        revision = nil
        expect { revision = subject }.to change(Revision, :count).by(1)

        expect(revision.commit_hash).to eq commit_hash
        expect(revision.initialized?).to eq true
      end

      context 'already exist commit' do
        let(:revision) { create(:revision, repository: repository, status: :downloaded) }
        let(:commit_hash) { revision.commit_hash }

        before { revision }

        it do
          ret = nil
          expect { ret = subject }.not_to change(Revision, :count)
          expect(ret).to eq nil

          revision.reload
          expect(revision.downloaded?).to eq true
        end
      end
    end
  end
end
