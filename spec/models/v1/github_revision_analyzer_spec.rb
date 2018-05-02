require 'rails_helper'

describe V1::GithubRevisionAnalyzer, type: :model do
  describe 'execute' do
    subject { V1::GithubRevisionAnalyzer.execute(revision) }

    context 'analyze rubygem repository' do
      let(:revision) do
        c = build(:revision, repository: create(:github_repository))
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
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
        expect(revision.done?).to eq true
      end
    end

    context 'skip already done' do
      let(:revision) do
        c = build(:revision, repository: create(:github_repository), status: :done)
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
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
