# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPresenter do
  let(:repositories) do
    [
      Repository.new(name: Faker::Superhero.name,
                     updated_at: Faker::Time.between(10.days.ago, Time.zone.today)),
      Repository.new(name: Faker::Superhero.name,
                     updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
    ]
  end
  let(:name) { Faker::Superhero.name }
  let(:user_name) { Faker::Superhero.name }
  let(:user) { User.new(login: user_name, name: name, repositories: repositories) }

  describe '::new' do
    it 'should accept User' do
      expect { UserPresenter.new(user) }.not_to raise_error
    end

    it 'should not accept other than User' do
      expect { UserPresenter.new(2) }.to raise_error ContractError
      expect { UserPresenter.new(nil) }.to raise_error ContractError
      expect { UserPresenter.new([]) }.to raise_error ContractError
      expect { UserPresenter.new([User]) }.to raise_error ContractError
      expect { UserPresenter.new({}) }.to raise_error ContractError
      expect { UserPresenter.new(true) }.to raise_error ContractError
      expect { UserPresenter.new(repositories.first) }.to raise_error ContractError
    end
  end

  subject { UserPresenter.new(user) }

  it { expect(subject.user).to eq(user) }
  it { expect(subject.name).to eq(user.name) }
  it { expect(subject.repositories).to eq(repositories.sort_by(&:updated_at).reverse) }
end