helpers do
  
  def get_reader
    rv = `python tikirdr/tikitag_reader.py`
    return rv
  end
  
end