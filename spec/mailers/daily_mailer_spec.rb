require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:users) { create_list :user, 3 }
    let(:user) { users.first }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end

    describe '.send_daily_digest' do
      it 'sends daily digest to all users' do
        User.all do |user|
          expect(DailyMailer).to receive(:digest).with(user).and_call_original
        end

        User.send_daily_digest
      end
    end
  end
end
