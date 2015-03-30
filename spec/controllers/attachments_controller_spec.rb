require 'rails_helper'

describe AttachmentsController do

  describe 'DELETE #destroy' do
    let!(:author) { create :user }
    let!(:question) { create :question,
                             :with_attachments,
                             user: author }
    let!(:attachment) { question.attachments.first }
    let!(:delete_params) {{ id: attachment.id, attachable_id: question.id, format: :js }}
    let!(:another_users_question) { create :question,
                                           :with_attachments,
                                           user: create(:user) }
    before { sign_in(author) }

    it 'assigns attachment to @attachment' do
      delete :destroy, id: attachment.id, attachable_id: question.id,format: :js
      expect(assigns(:attachment)).to eq attachment
    end

    it 'assigns entity to @entity' do
      delete :destroy, delete_params
      expect(assigns(:entity)).to eq question
    end

    it "deletes author's attachment" do
      expect{ delete :destroy, delete_params }
          .to change(Attachment, :count).by(-1)
    end

    it "can not delete another user's attachment" do
      expect{ delete :destroy, delete_params.merge(attachable_id: another_users_question.id) }
          .not_to change(Attachment, :count)
    end

    it 'renders destroy template' do
      delete :destroy, delete_params
      expect(response).to render_template :destroy
    end
  end
end
