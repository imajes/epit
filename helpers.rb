helpers do
  
  def get_reader(from)
    rv = `python tikirdr/tikitag_reader.py`
    if rv == "No tikitag on the reader\n"
      redirect "#{from}?no_tag=true" and return
    end
    return rv
  end
  
end