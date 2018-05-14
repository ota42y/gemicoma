shared_context 'shared_gemfile_text' do
  let(:gemfile_text) do
    <<~GEMFILE
      GEM
        remote: https://rubygems.org/
        specs:
          ota42y_rubygems_hands_on (0.1.2)
            ota42y_test_gem
          ota42y_test_gem (0.2.0)

      PLATFORMS
        ruby

      DEPENDENCIES
        ota42y_rubygems_hands_on (>= 0.1.2)

      BUNDLED WITH
         1.16.1

GEMFILE
  end
end
