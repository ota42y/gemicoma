require 'test_helper'

class ::V1::DependencyGraphTest < ActiveSupport::TestCase
  test 'the truth' do
    gem = ::Dump::Rubygems::Rubygem.create!(name: 'rails')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.1.0', platform: 'ruby')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.2.0', platform: 'ruby')

    no_platform = ::Dump::Rubygems::Rubygem.create!(name: 'no_platform')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: no_platform, number: '5.1.0', platform: 'ruby')

    rails_gem = V1::GemSpecification.new('rails', '5.0.0', 'ruby')
    unknown_gem = V1::GemSpecification.new('unknown_gem', '1.0.0', 'ruby')
    no_platform = V1::GemSpecification.new('no_platform', '1.0.0', 'none')

    lock = V1::Dependency::GemLock.new(nil, [rails_gem, unknown_gem, no_platform])
    graph = ::V1::DependencyGraph.new(lock)

    assert_not_empty graph.dependencies

    assert_equal 'rails', graph.dependencies.first.name
    assert_equal '5.0.0', graph.dependencies.first.version
    assert_equal '5.2.0', graph.dependencies.first.new_version

    assert_equal 'unknown_gem', graph.dependencies[1].name
    assert_equal '1.0.0', graph.dependencies[1].version
    assert_equal '-', graph.dependencies[1].new_version

    assert_equal 'no_platform', graph.dependencies[2].name
    assert_equal '1.0.0', graph.dependencies[2].version
    assert_equal '-', graph.dependencies[2].new_version

    assert_not_nil graph
  end
end
