require 'rails_helper'

describe V1::Analyzer::Revision, type: :model do
  describe 'execute' do
    subject { V1::Analyzer::Revision.execute(revision) }

    context 'analyze rubygem repository' do
      let(:revision) do
        r = build(:revision, repository: create(:github_repository), status: :downloaded)
        r.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        r.save!
        r
      end

      let(:dependency_file) do
        f = build(:revision_dependency_file, :gemfile_lock)
        revision.revision_dependency_files << f
        revision.save!
        f
      end

      it do
        dependency_file

        expect(subject).to eq true

        revision.reload
        dependency_file.reload

        expect(revision.done?).to eq true
        expect(dependency_file.revision_ruby_specifications.count).to eq 2
        expect(revision.repository.revision_latest.revision_id).to eq revision.id
      end

      it 'overwrite revision' do
        old_revision = build(:revision, repository: revision.repository, status: :done)
        revision.repository.update_revision(old_revision)

        expect(subject).to eq true
        expect(revision.repository.revision_latest.revision_id).to eq revision.id
      end
    end

    context 'skip already done' do
      let(:revision) do
        c = build(:revision, repository: create(:github_repository), status: :done)
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      it do
        expect(subject).to eq false
      end
    end

    context 'skip not download' do
      let(:revision) do
        c = build(:revision, repository: create(:github_repository), status: :initialized)
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      it do
        expect(subject).to eq false
      end
    end
  end
end
