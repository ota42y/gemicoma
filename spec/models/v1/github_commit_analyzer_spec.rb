require 'rails_helper'

describe V1::GithubCommitAnalyzer, type: :model do
  describe 'execute' do
    subject { V1::GithubCommitAnalyzer.execute(commit) }

    context 'analyze rubygem repository' do
      let(:commit) do
        c = build(:github_commit)
        c.github_repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      it do
        data = instance_double(V1::Github::GemData)
        allow(data).to receive(:build!)
        allow(data).to receive(:save!)
        allow(V1::Github::GemData).to receive(:new).and_return(data)

        expect(subject).to eq true

        expect(data).to have_received(:save!).once
        expect(data).to have_received(:build!).once
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
        allow(V1::Github::GemData).to receive(:new)

        expect(subject).to eq false

        expect(V1::Github::GemData).not_to have_received(:new)
      end
    end
  end
end
