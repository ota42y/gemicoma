require 'rails_helper'

describe V1::Github::Fetcher, type: :model do
  describe 'execute' do
    subject { V1::Github::Fetcher.execute(revision) }

    context 'get gemfile from github' do
      include_context 'shared_gemfile_text'

      let(:revision) do
        c = build(:revision, repository: create(:github_repository))
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c.save!
        c
      end

      it do
        allow(::V1::GithubRepository).to receive(:contents_by_string).
                                           with(revision.repository.github_path,
                                                revision.repository.github_ruby_gem_info.gemfile_lock_relative_path,
                                                revision.commit_hash).
                                           and_return(gemfile_text)

        expect(subject).to eq true

        revision.reload
        expect(revision.downloaded?).to eq true

        dependency_file = revision.revision_dependency_files.first
        expect(dependency_file.source_filepath).to eq('./Gemfile.lock')
        expect(dependency_file.body).to eq(gemfile_text)
        expect(dependency_file.gemfile_lock?).to eq true
      end
    end

    context 'already downloaded' do
      let(:revision) { build(:revision, repository: create(:github_repository), status: :downloaded) }

      it do
        expect(subject).to eq false
      end
    end

    context 'already done' do
      let(:revision) { build(:revision, repository: create(:github_repository), status: :done) }

      it do
        expect(subject).to eq false
      end
    end
  end
end
