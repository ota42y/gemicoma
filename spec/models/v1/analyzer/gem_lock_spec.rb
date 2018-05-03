require 'rails_helper'

describe V1::Analyzer::GemLock, type: :model do
  describe 'execute' do
    subject { V1::Analyzer::GemLock.execute(dependency_file) }

    context 'analyze rubygem repository' do
      let(:dependency_file) do
        r = build(:revision, repository: create(:github_repository), status: :downloaded)
        create(:revision_dependency_file, :gemfile_lock, revision: r)
      end

      it do
        expect(dependency_file.revision_ruby_specifications.size).to eq 0

        subject

        expect(dependency_file.revision_ruby_specifications.size).to eq 2

        specification = dependency_file.revision_ruby_specifications.select { |n| n.name == 'ota42y_rubygems_hands_on' }
        expect(specification[0].platform).to eq 'ruby'
        expect(specification[0].version).to eq '0.1.2'
      end
    end
  end
end
