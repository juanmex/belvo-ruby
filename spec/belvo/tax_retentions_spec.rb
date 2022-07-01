# frozen_string_literal: true

RSpec.describe Belvo::TaxRetentions do
  let(:tax_retentions_response) do
    {
      id: 'Openbeynking',
      link: 'chicechi',
      collected_at: '2019-09-27T13:01:41.941Z'
    }
  end

  let(:tax_retentions) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/tax-retentions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        type: described_class::TaxRetentionsType::INFLOW,
        date_from: '2021-01-01',
        date_to: '2021-01-03',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: tax_retentions_response.to_json
    )
  end

  def mock_create_with_dates
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/tax-retentions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2021-01-01',
        date_to: '2021-01-03',
        save_data: true,
        type: described_class::TaxRetentionsType::INFLOW
      }
    ).to_return(
      status: 201,
      body: tax_retentions_response.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/tax-retentions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2021-01-01',
        date_to: '2021-01-03',
        save_data: false,
        type: described_class::TaxRetentionsType::INFLOW,
        attach_xml: true
      }
    ).to_return(
      status: 201,
      body: tax_retentions_response.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      tax_retentions.retrieve(
        link: 'some-link-uuid',
        type: described_class::TaxRetentionsType::INFLOW,
        options: {
          date_from: '2021-01-01',
          date_to: '2021-01-03',
          save_data: true
        }
      )
    ).to eq(tax_retentions_response.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      tax_retentions.retrieve(
        link: 'some-link-uuid',
        type: described_class::TaxRetentionsType::INFLOW,
        options: {
          date_from: '2021-01-01',
          date_to: '2021-01-03',
          save_data: false,
          attach_xml: true
        }
      )
    ).to eq(tax_retentions_response.transform_keys(&:to_s))
  end

  it 'can create with dates' do
    mock_create_with_dates
    expect(
      tax_retentions.retrieve(
        link: 'some-link-uuid',
        type: described_class::TaxRetentionsType::INFLOW,
        options: {
          date_from: '2021-01-01',
          date_to: '2021-01-03',
          save_data: true
        }
      )
    ).to eq(tax_retentions_response.transform_keys(&:to_s))
  end
end
