require 'rails_helper'

describe V1::Analyzer::GemLock, type: :model do
  describe 'execute' do
    subject { V1::Analyzer::GemLock.execute(dependency_file) }

    context 'analyze rubygem repository' do
      let(:dependency_file) do
        r = build(:revision, repository: create(:github_repository), status: :downloaded)
        create(:revision_dependency_file, :gemfile_lock, revision: r)
      end

      let(:already_exist_spec) do
        dependency_file.revision_ruby_specifications.create!(name: 'ota42y_test_gem', version: '0.1', platform: 'ruby')
      end

      let(:unknown_gem) do
        dependency_file.revision_ruby_specifications.create!(name: 'unknown', version: '0.1', platform: 'ruby')
      end

      it do
        already_exist_spec
        unknown_gem

        expect(dependency_file.revision_ruby_specifications.size).to eq 2

        subject
        dependency_file.save!

        expect(dependency_file.revision_ruby_specifications.size).to eq 2

        specification = dependency_file.revision_ruby_specifications.select { |n| n.name == 'ota42y_rubygems_hands_on' }
        expect(specification[0].platform).to eq 'ruby'
        expect(specification[0].version).to eq '0.1.2'

        specification = dependency_file.revision_ruby_specifications.select { |n| n.name == already_exist_spec.name }
        expect(specification[0].platform).to eq 'ruby'
        expect(specification[0].version).to eq '0.2.0'

        deleted_gem = dependency_file.revision_ruby_specifications.select { |n| n.name == unknown_gem.name }
        expect(deleted_gem.size).to eq 0

        expect(dependency_file.revision_ruby_version.version).to eq 'ruby 2.5.3p105'
      end
    end
  end
end
