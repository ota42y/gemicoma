require 'rails_helper'

describe FetchRevisionJob, type: :model do
  describe 'perform' do
    subject { FetchRevisionJob.perform_now(revision_id, false) }

    context 'not exist' do
      let(:revision_id) { 0 }

      it do
        ret = nil
        expect { ret = subject }.not_to enqueue_job(::AnalyzeRevisionJob)
        expect(ret).to eq false
      end
    end

    context 'exist and do something' do
      let(:revision) { create(:revision, repository: create(:github_repository)) }
      let(:revision_id) { revision.id }

      before do
        revision
        allow(V1::Github::Fetcher).to receive(:execute).and_return(true)
      end

      it do
        ret = nil
        expect { ret = subject }.to enqueue_job(::AnalyzeRevisionJob)
        expect(ret).to eq true
        expect(V1::Github::Fetcher).to have_received(:execute).once
      end
    end
  end
end
