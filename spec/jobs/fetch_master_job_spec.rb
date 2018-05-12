require 'rails_helper'

describe FetchMasterJob, type: :model do
  describe 'perform' do
    subject { FetchMasterJob.perform_now(repository_id, false) }

    context 'not exist' do
      let(:repository_id) { 0 }

      it do
        ret = nil
        expect { ret = subject }.not_to enqueue_job(::FetchRevisionJob)
        expect(ret).to eq false
      end
    end

    context 'exist' do
      let(:repository) { create(:github_repository) }
      let(:repository_id) { repository.id }

      before do
        repository
        allow(V1::Github::MasterFetcher).to receive(:execute).and_return(fetch_result)
      end

      context 'do something' do
        let(:revision) { create(:revision, repository: repository) }
        let(:fetch_result) { revision }

        it do
          ret = nil
          expect { ret = subject }.to have_enqueued_job(::FetchRevisionJob).with(revision.id, true)
          expect(ret).to eq true
          expect(V1::Github::MasterFetcher).to have_received(:execute).once
        end
      end

      context 'dont update revision' do
        let(:fetch_result) { nil }

        it do
          ret = nil
          expect { ret = subject }.not_to enqueue_job(::FetchRevisionJob)
          expect(ret).to eq false
          expect(V1::Github::MasterFetcher).to have_received(:execute).once
        end
      end
    end
  end
end
