require 'rails_helper'

RSpec.describe Track, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:track_comments) }
  it { should have_many(:track_playlists) }
  it { should have_many(:playlists).through(:track_playlists) }
  it { should have_many(:listening_events) }
  it { should have_many(:reposts) }
  it { should have_many(:purchased_items) }
  it { should have_many(:likes) }
  it { should have_many(:comments) }

  it { should have_one_attached(:cover) }
  it { should have_one_attached(:audio) }
  it { should have_one_attached(:mp3_audio) }
  it { should have_one_attached(:zip) }

  let!(:user) {
    FactoryBot.create(:user, username: "user", role: "user")
  }

  describe 'scopes' do
    before do
      @track1 = FactoryBot.create(:track, private: false, user: user, created_at: 1.day.ago)
      @track2 = FactoryBot.create(:track, private: true, user: user, created_at: 2.days.ago)
      @track3 = FactoryBot.create(:track, private: false, user: user, created_at: 3.days.ago)
    end

    describe '.published' do
      it 'returns only published tracks' do
        expect(Track.published).to contain_exactly(@track1, @track3)
      end
    end

    describe '.latests' do
      it 'returns tracks in descending order of creation' do
        expect(Track.latests.ids).to eq([@track3.id, @track2.id, @track1.id])
      end
    end
  end

  describe 'state' do
    it "pending" do
      @track = FactoryBot.create(:track, private: false, user: user, created_at: 1.day.ago)
      expect(@track).to be_pending
    end
  end

  describe 'tags' do
    it "create with tags" do
      @track = FactoryBot.create(:track, user: user, tags: ["Ambient", "Techno"])
      expect(@track.tags).to be == ["ambient", "techno"]
      expect(Track.get_tracks_by_tag("Ambient")).to be_any
      expect(Track.get_tracks_by_tag("ambient")).to be_any
    end
  end

  describe 'audio' do
    xit 'can be created with an audio file' do
      audio = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'audio.mp3'), 'audio/mp3')
      track = FactoryBot.create(:track, audio: audio, user: user)
      expect_any_instance_of(Track).to receive(:reprocess_async)
      expect(track).to be_persisted
      expect(track.audio).to be_persisted
    end
  end

end
