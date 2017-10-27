require 'nokogiri'
require 'functions/custom_fields_examples'

def account_attributes(overrides = {})
  {
    accountno: '1',
    title: 'An Account',
    category: 'An Account Category',
    customfields: {
      custom_field_1: 'Custom Field 1 Value',
      custom_field_2: 'Custom Field 2 Value'
    }
  }.merge(overrides)
end

# function_name refers to the name that identifies the function to intacct,
# usually a snake-case variant of the class name.
shared_examples 'a account function' do |function_xml|
  let(:base_path) { function_base_path(function_name) }

  let(:function_name) { function_name_from(function_xml) }
  it 'contains expected standard params' do
    [:accountno, :title, :category].each do |param_key|
      param = function_xml.xpath("#{base_path}/#{param_key}")
      expected = account_attributes[param_key]
      expect(param.text)
        .to eq(expected),
            "Value mismatch on #{param_key}. Expected " \
            "\"#{account_attributes[param_key]}\", got \"#{param.text}\""
    end
  end
  it_behaves_like 'a custom fields function', function_xml, account_attributes

end
