require 'rails_helper'

describe V1::RubygemAnalyzer, type: :model do
  describe 'execute' do
    subject { analyzer.save! }

    let(:analyzer) { V1::RubygemAnalyzer.new(gem_data) }

    context 'analyze rubygem repository' do
      include_context 'shared_gemfile_text'

      let(:commit) do
        c = build(:github_commit)
        c.github_repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      let(:gem_data) do
        data = V1::Github::GemData.new(commit)
        data.instance_variable_set(:@gemfile_lock, gemfile_lock)
        data
      end

      let(:gemfile_lock) do
        ::V1::Dependency::GemLock.create_from_gemfile_lock(gemfile_text)
      end

      it do
        expect(subject).to eq true

        # expect(commit.github_ruby_commit_specifications.size).to eq 2
      end
    end
  end
end
