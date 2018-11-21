require 'rails_helper'

describe FetchAllMasterJob, type: :model do
  describe 'perform' do
    subject { FetchAllMasterJob.perform_now }

    context 'exist and do something' do
      let(:repositories) { create_list(:github_repository, 3) }

      before do
        repositories
      end

      it do
        expect { subject }.
            to have_enqueued_job(::FetchMasterJob).with(repositories[0].id, true).
                and have_enqueued_job(::FetchMasterJob).with(repositories[1].id, true).
                    and have_enqueued_job(::FetchMasterJob).with(repositories[2].id, true)
      end
    end
  end
end
