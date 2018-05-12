require 'rails_helper'

describe FetchMasterJob, type: :model do
  describe 'perform' do
    subject { FetchMasterJob.perform_now(repository_id, false) }

    context 'not exist' do
      let(:repository_id) { 0 }

      it do
        expect(subject).to eq false
      end
    end

    context 'exist and do something' do
      let(:repository) { create(:github_repository) }
      let(:repository_id) { repository.id }

      before do
        repository
      end

      it do
        expect(subject).to eq true
      end
    end
  end
end
