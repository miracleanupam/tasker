require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'when creating a project' do
    let(:user) { build :user }
    let(:project) { build :project, user: user }

    describe 'validations' do
      it 'should be valid' do
        expect(project.valid?).to be true
      end

      it 'should have a name' do
        project.name = nil
        expect(project.valid?).to be false
      end

      it 'name should not exceed 100 characters' do
        project.name = 'a' * 101
        expect(project.valid?).to be false
      end
    end

    describe 'associations' do
      it 'should belong to a user' do
        project.user = nil
        expect(project.valid?).to be false
      end

      it 'deletion of user should delete the projects too' do
        user.save
        project.save

        expect { user.destroy }.to change { Project.count }.by(-1 * user.projects.count).and change {
                                                                                               User.count
                                                                                             }.by(-1)
      end
    end
  end
end
