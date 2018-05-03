require 'rails_helper'

describe AnalyzeRevisionJob, type: :model do
  describe 'perform' do
    subject { AnalyzeRevisionJob.perform_now(revision_id, false) }

    context 'not exist' do
      let(:revision_id) { 0 }

      it do
        expect(subject).to eq false
      end
    end

    context 'exist and do something' do
      let(:revision) { create(:revision, repository: create(:github_repository)) }
      let(:revision_id) { revision.id }

      before do
        revision
        allow(V1::Analyzer::Revision).to receive(:execute).and_return(true)
      end

      it do
        expect(subject).to eq true
        expect(V1::Analyzer::Revision).to have_received(:execute).once
      end
    end
  end
end
