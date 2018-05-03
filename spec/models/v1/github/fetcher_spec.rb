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

      before do
        stub_request(:get, "https://raw.githubusercontent.com/#{revision.repository.github_path}/#{revision.commit_hash}/Gemfile.lock").
          to_return(body: gemfile_text)
      end

      it do
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
