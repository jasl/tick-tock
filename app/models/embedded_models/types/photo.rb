class Photo < Content
  field :body, :type => String, :null => false, :autosave => true

  validates :body, :presence => true, :length => 4..10

  embedded_in :moment, :inverse_of => :photo

  def filled?
    self.body.blank? ? false : true
  end

  def blank!
    self.body = nil
  end

end
