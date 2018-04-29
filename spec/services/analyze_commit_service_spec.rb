require 'rails_helper'

describe AnalyzeCommitService, type: :model do
  describe 'execute' do
    subject { AnalyzeCommitService.execute(commit) }

    context 'analyze rubygem repository' do
      let(:commit) do
        c = build(:github_commit)
        c.github_repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      it do
        d = instance_double(V1::RubygemAnalyzer)
        allow(d).to receive(:save!)
        allow(V1::RubygemAnalyzer).to receive(:new).and_return(d)

        expect(subject).to eq true

        expect(d).to have_received(:save!).once
        expect(commit.done?).to eq true
      end
    end

    context 'skip already done' do
      let(:commit) do
        c = build(:github_commit, status: :done)
        c.github_repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      it do
        allow(V1::RubygemAnalyzer).to receive(:new)

        expect(subject).to eq false

        expect(V1::RubygemAnalyzer).not_to have_received(:new)
      end
    end
  end
end
