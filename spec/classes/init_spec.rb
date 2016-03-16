require 'spec_helper'
describe 'magnolia' do

  context 'with defaults for all parameters' do
    it { should contain_class('magnolia') }
  end
end
