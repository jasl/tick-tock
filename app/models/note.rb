class Note
  include Mongoid::Document

  field :body, :type => String, :null => false, :autosave => true

  embedded_in :moment, :inverse_of => :note
end
