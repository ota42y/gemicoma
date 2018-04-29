require 'rails_helper'

describe CheckNewCommitJob, type: :model do
  describe 'perform' do
    subject { CheckNewCommitJob.perform_now(commit_id, false) }

    context 'not exist' do
      let(:commit_id) { 0 }

      it do
        expect(subject).to eq false
      end
    end

    context 'exist and do something' do
      let(:github_commit) { create(:github_commit) }
      let(:commit_id) { github_commit.id }

      before do
        github_commit
        allow(AnalyzeCommitService).to receive(:execute).and_return(true)
      end

      it do
        expect(subject).to eq true
        expect(AnalyzeCommitService).to have_received(:execute).once
      end
    end
  end
end
